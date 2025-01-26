import os
from loguru import logger
from ipfs_functions import *
import integration_helpers
from super_helper import *
import tika
from tika import parser
from iroha_helper import *
from super_helper import index_metadata
import re
from typing import Optional



# Initialize Tika
tika.initVM()

# Function to read accounts from JSON-LD
def read_user_accounts_from_jsonld(file_path):
    with open(file_path, mode='r', encoding='utf-8') as file:
        data = json.load(file)
        user_accounts = []
        for entry in data["@graph"]:
            if entry["@type"] == "foaf:Person":
                account_id = entry.get("foaf:holdsAccount", {}).get("schema:identifier")
                if account_id:
                    user_accounts.append({'account_id': account_id})
        return user_accounts


def read_project_accounts_from_jsonld(file_path):
    with open(file_path, mode='r', encoding='utf-8') as file:
        data = json.load(file)
        project_accounts = []
        for entry in data["@graph"]:
            if entry["@type"] == "schema:ResearchProject":
                project_id = entry.get("schema:identifier")
                if project_id:
                    project_accounts.append({'account_id': project_id})
        return project_accounts


# Individual functions
def list_files(directory_path):
    """Return a list of files in the specified directory path."""
    try:
        return [filename for filename in os.listdir(directory_path) if not os.path.basename(filename).startswith('.')]
        logger.info(f"Listing {filename}")
    except Exception as e:
        logger.error(f"Error listing files in {directory_path}: {e}")
        return []

def parse_file_with_tika(file_path):
    """Use Apache Tika to parse the file and extract its metadata."""
    try:
        parsed = parser.from_file(file_path)
        logger.info(f"Parsing {file_path} with Tika...")
        metadata = parsed["metadata"]
        return metadata
    except Exception as e:
        logger.error(f"Error parsing {file_path} with Tika: {e}")
        return None

def index_file_with_woosh(file_path, metadata_cid):
    # Index the file with Woosh using the provided metadata CID
    try:
        pass  # TO DO: implement this function
        logger.info(f"Indexing {file_path} with Woosh...")
    except Exception as e:
        logger.error(f"Error indexing {file_path} with Woosh: {e}")






import mimetypes

# Function to parse and index documents from a directory
def parse_documents_in_directory(file_path, filename,project_id):
    """Parses documents in a directory and indexes them."""
    
    parsed_document = parser.from_file(file_path)
    # logger.info(parsed_document)
    
    metadata = parsed_document.get('metadata', {}) or "No metadata extracted"
                
    full_text = parsed_document.get("content", "") or "No content extracted"
                
    return metadata, full_text
    

# Function to normalize metadata and handle lists
def normalize_metadata_value(value):
    """Normalize metadata value by handling strings and lists."""
    if isinstance(value, list):
        # Join the list into a single string
        return ', '.join([str(v).lower() for v in value])
    elif isinstance(value, str):
        return value.lower()
    return str(value).lower()  # For any other types, convert to string and lowercase



#Current
def process_files(directory_path, project_id, schema):
    """Process files in the specified directory path."""
    
    try:
        cids = []
        file_count = 0

        # Initialize address to None (will be set later)
        address = None

        for filename in list_files(directory_path):
            file_path = os.path.join(directory_path, filename)
            logger.info(f"Indexing file:  {file_path}")
            # logger.info("file name: ", filename)
            
            try:
                
                result = parse_documents_in_directory(file_path, filename, project_id)
                metadata, full_text = result
                # logger.info("metadata:", metadata)
                
                
            except Exception as e:
                logger.error(f"Error extracting and normalizing {file_path}: {e}")
          
            if metadata is not None and isinstance(metadata, dict):
                file_cid = upload_file_to_ipfs(file_path)
                # logger.info("file cid: ", file_cid)

                if file_cid is not None:
                    metadata_cid = upload_json_to_ipfs(metadata)
                    # logger.info("file metadata cid: ", metadata_cid)

                    # Create a unique key for the file and return its CIDs
                    file_key = f"file_{file_count + 1}"
                    # logger.info("file_key :", file_key)
                    cids.append((file_key, file_cid, metadata_cid))
                    file_count += 1

                    # # Assign cid_str here, so it gets updated for each file
                    cid_str = (file_key, file_cid, metadata_cid)
                    # logger.info("cid_str :", cid_str)

                    # # Join file_cid and metadata_cid with a comma
                    joined_cids = f"{file_cid}, {metadata_cid}"
                    # logger.info("joined_cids :", joined_cids)

                    if address is None:
                        hash = create_contract()
                        address = integration_helpers.get_engine_receipts_address(hash)

                    logger.debug(project_id)
                    
                    hash = set_account_detail(
                        address, 
                        project_id,  # Project ID as account
                        f"{file_key}",    # The key we're setting
                        joined_cids      # The value (CID from IPFS)
                    )
                    # logger.info("hash :", hash)
                    
            try:
                ix = index_metadata(metadata, full_text, schema, project_id, file_cid, metadata_cid) #calls super_helper.py
                
                
            except Exception as e:
                logger.error(f"Error indexing metadata")

        return cids, cid_str, joined_cids if len(cids) > 0 else None
    except Exception as e:
        logger.error(f"Error processing files in {directory_path}: {e}")




@integration_helpers.trace
def extract_account_metadata_cid_from_data(data: dict) -> Optional[str]:
    try:
        # Step 1: Ensure 'data' is a dictionary
        if not isinstance(data, dict):
            raise ValueError("Expected input 'data' to be a dictionary.")
        
        # Step 2: Ensure 'json_data' is a valid JSON string
        json_data_str = data.get('json_data', '')  # Safely get 'json_data'
        json_data = json.loads(json_data_str)  # Parse 'json_data' into a dictionary
        
        # Step 3: Access the 'admin@test' key inside the parsed dictionary
        if 'admin@test' in json_data:
            admin_data = json_data['admin@test']
            
            # Step 4: Access 'account_metadata_cid'
            if 'account_metadata_cid' in admin_data:
                return admin_data['account_metadata_cid']
            else:
                raise KeyError("'account_metadata_cid' not found in the data")
        else:
            raise KeyError("'admin@test' not found in the parsed data")
            
    except (KeyError, json.JSONDecodeError, ValueError) as e:
        logger.error(f"Error during JSON processing: {e}")
        return None

# Main function to clean input, log, and test
@integration_helpers.trace
def process_raw_data(raw_data: str) -> Optional[str]:
    try:
        # Clean non-printable characters (e.g., \u0001)
        clean_data = re.sub(r'[^\x20-\x7E]', '', raw_data)
        
        # Parse the cleaned JSON string into a dictionary
        data = json.loads(clean_data)
        
        # Extract the CID
        account_metadata_cid = extract_account_metadata_cid_from_data(data)
        
        # Log the results
        if account_metadata_cid:
            logger.info(f"User Metadata CID: {account_metadata_cid}")
        else:
            logger.info("'account_metadata_cid' not found or an error occurred.")
        
        return account_metadata_cid
    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON: {e}")
        return None

import json
import os
import base64

def dump_variable(variable, variable_name, temp="temp"):
    """
    Dumps a Python variable to a JSON file, handling bytes by encoding them to base64 strings.

    Args:
        variable: The variable to dump (must be JSON-serializable or contain bytes).
        variable_name: Name of the variable (used for the filename).
        temp: Directory to save the file (default is "temp").
    """
    os.makedirs(temp, exist_ok=True)  # Ensure the directory exists
    file_path = os.path.join(temp, f"{variable_name}.json")
    
    def encode_bytes(obj):
        if isinstance(obj, bytes):
            return {"__bytes__": True, "data": base64.b64encode(obj).decode("utf-8")}
        raise TypeError(f"Object of type {type(obj)} is not JSON serializable")
    
    try:
        with open(file_path, "w") as f:
            json.dump(variable, f, indent=4, default=encode_bytes)
        logger.info(f"Variable '{variable_name}' successfully dumped to {file_path}")
    except Exception as e:
        logger.error(f"Failed to dump variable '{variable_name}': {e}")

def load_variable(variable_name, temp="temp"):
    """
    Loads a Python variable from a JSON file, decoding base64-encoded bytes.

    Args:
        variable_name: Name of the variable (used for the filename).
        temp: Directory where the file is stored (default is "temp").

    Returns:
        The loaded variable, or None if the file does not exist or loading fails.
    """
    file_path = os.path.join(temp, f"{variable_name}.json")
    
    def decode_bytes(obj):
        if "__bytes__" in obj:
            return base64.b64decode(obj["data"].encode("utf-8"))
        return obj
    
    try:
        with open(file_path, "r") as f:
            variable = json.load(f, object_hook=decode_bytes)
        logger.info(f"Variable '{variable_name}' successfully loaded from {file_path}")
        return variable
    except FileNotFoundError:
        logger.error(f"File '{file_path}' not found.")
    except Exception as e:
        logger.error(f"Failed to load variable '{variable_name}': {e}")
    
    return None

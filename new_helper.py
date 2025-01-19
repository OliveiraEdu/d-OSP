import os
from loguru import logger
from ipfs_functions import *
import integration_helpers
from super_helper import *
import tika
from tika import parser
from iroha_helper import *
from super_helper import index_metadata


# Initialize Tika
tika.initVM()

# Set up a basic configuration for Loguru
logger.add("logs/file_{time}.log", format="{time:MM.DD/YYYY} | {level} | {message}", level="INFO")

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




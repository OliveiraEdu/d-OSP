import json
import logging
import os
from whoosh.index import create_in, open_dir, LockError, EmptyIndexError
from whoosh.fields import Schema, TEXT, ID
from whoosh.qparser import MultifieldParser
import tika
from tika import parser
from datetime import datetime
from loguru import logger
import shutil
import time
from ipfs_functions import download_json_from_ipfs, download_file_from_ipfs
from iroha_helper import get_account_detail
from clean_file_name import clean_file_name

# Initialize Tika
tika.initVM()

from contextlib import contextmanager
import sys

@contextmanager
def with_logging_block(block_name, logger):
    """
    A reusable context manager for logging structured execution blocks.

    Args:
        block_name (str): The name of the block being executed.
        logger (Logger): The logger instance.
    """
    try:
        logger.info("\n" + "=" * 50)
        logger.info(f"STARTING BLOCK: {block_name}")
        logger.info("=" * 50)
        yield  # Code within the `with` block will execute here
    except Exception as e:
        logger.error(f"An error occurred in block '{block_name}': {e}. Exiting.")
        sys.exit(1)  # Graceful exit on error
    finally:
        logger.info(f"COMPLETED BLOCK: {block_name}")
        logger.info("-" * 50 + "\n")


def processing_search_results_block(search_results):
    """
    Process search results by fetching and validating data, downloading metadata,
    and processing linked user and project information.

    Args:
        search_results (list): A list of dictionaries containing search result data.
                               Each dictionary must include 'project_id', 'file_cid',
                               and 'metadata_cid' keys.

    Returns:
        list: A list of tuples, where each tuple contains 
              (project_metadata_cid, linked_user, metadata_cid, project_id, file_cid)
    """
    results = []

    with with_logging_block("Processing Search Results", logger):
        for result_dict in search_results:
            project_id = result_dict.get('project_id')
            file_cid = result_dict.get('file_cid')
            metadata_cid = result_dict.get('metadata_cid')

            with with_logging_block(f"Processing Result for Project ID: {project_id or 'Unknown'}", logger):
                if not project_id or not file_cid or not metadata_cid:
                    logger.error(f"Missing required data in result: {result_dict}")
                    continue

                logger.info(f"File CID: {file_cid}")
                logger.info(f"Metadata CID: {metadata_cid}")

                # Fetch project details
                with with_logging_block("Fetching Project Details in the blockchain", logger):
                    project_details = get_account_detail(project_id)
                    blockchain_data = json.loads(project_details)
                    if not project_details:
                        logger.error(f"No project details found for Project ID: {project_id}.")
                        continue
                    logger.info(f"Fetched project details for {project_id}: {project_details}")

                # Validate file CID
                with with_logging_block("Validating File CID", logger):
                    validation_result = fetch_project_details(file_cid, blockchain_data)
                    
                    if not validation_result["is_valid"]:
                        logger.warning(f"Invalid File CID for Project ID: {project_id}. Skipping metadata processing.")
                        continue

                project_metadata_cid = validation_result.get("project_metadata_cid")
                linked_user = validation_result.get("linked_user")
                
                # Append the processed data to results
                results.append((project_metadata_cid, linked_user, metadata_cid, project_id, file_cid))

    return results


def metadata_block(processed_results, download_path):
    """
    Process the metadata for a list of processed results.

    Args:
        processed_results (list): A list of tuples containing 
                                  (project_metadata_cid, linked_user, metadata_cid, project_id, file_cid).
        download_path (str): The path where files will be downloaded.
    """
    with with_logging_block("Processing Metadata Block", logger):
        for project_metadata_cid, linked_user, metadata_cid, project_id, file_cid in processed_results:
            # Process project metadata
            if project_metadata_cid:
                with with_logging_block("Processing Project Metadata", logger):
                    try:
                        project_metadata = download_json_from_ipfs(project_metadata_cid)
                        logger.info(f"Downloaded project metadata: {project_metadata}")
                    except Exception as e:
                        logger.error(f"Error processing project metadata CID {project_metadata_cid}: {e}")

            # Process linked user details
            if linked_user:
                with with_logging_block(f"Processing Linked User: {linked_user}", logger):
                    try:
                        user_details = get_account_detail(linked_user)
                        user_details = json.loads(user_details)
                        
                        account_metadata_cid = user_details.get("admin@test", {}).get("account_metadata_cid")
                        if account_metadata_cid:
                            try:
                                user_metadata = download_json_from_ipfs(account_metadata_cid)
                                logger.info(f"Downloaded user metadata: {user_metadata}")
                            except Exception as e:
                                logger.error(f"Error downloading user metadata for CID {account_metadata_cid}: {e}")
                        else:
                            logger.warning(f"User JSON-LD CID not found for linked user {linked_user}.")
                    except json.JSONDecodeError as e:
                        logger.error(f"Error decoding user details JSON for {linked_user}: {e}")
                    except Exception as e:
                        logger.error(f"Error processing linked user {linked_user}: {e}")

            # Process metadata CID
            if metadata_cid:
                with with_logging_block("Processing Metadata CID", logger):
                    try:
                        file_metadata = download_json_from_ipfs(metadata_cid)
                        file_metadata_json = download_file(file_metadata, download_path, project_id, file_cid)
                        logger.info(f"Downloaded file metadata for {file_cid} in project {project_id}.")
                    except Exception as e:
                        logger.error(f"Error processing metadata CID {metadata_cid} for file {file_cid}: {e}")



def download_file(file_metadata_json, download_path, project_id, file_cid):
    if "resourceName" in file_metadata_json:
        # Extract and clean the filename
        raw_file_name = file_metadata_json["resourceName"]
        cleaned_file_name = clean_file_name(raw_file_name)  # Renamed to avoid conflict
        logger.info(f"Cleaned file name: {cleaned_file_name}")

        # Create user-specific download directory if it doesn't exist
        download_directory = os.path.join(download_path, project_id)
        os.makedirs(download_directory, exist_ok=True)
        logger.info(f"Download directory ready: {download_directory}")

        # Construct the full file path with the cleaned filename
        file_path = os.path.join(download_directory, cleaned_file_name)
        logger.info(f"Downloading file to: {file_path}")

        # Download file using the file CID
        try:
            download_file_from_ipfs(file_cid, file_path)
        except Exception as e:
            logger.error(f"Failed to download file {cleaned_file_name}: {e}")
    else:
        logger.error(f"No 'resourceName' found for metadata CID: {file_metadata_json}")
       

# JSON Decoding Helper
def decode_json(data, context):
    try:
        return json.loads(data)
    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON for {context}: {e}")
        return None

#Blockchain Fetch Helper
def fetch_blockchain_data(account_id):
    details = get_account_detail(account_id)
    if not details:
        logger.error(f"No details found for account ID: {account_id}")
        return None
    return decode_json(details, f"account ID {account_id}")


def process_valid_result(project_id, validation_result):
    project_metadata_cid = validation_result.get("project_metadata_cid")
    linked_user = validation_result.get("linked_user")

    if project_metadata_cid:
        try:
            project_metadata = download_json_from_ipfs(project_metadata_cid)
            logger.info(f"Downloaded project metadata: {project_metadata}")
        except Exception as e:
            logger.error(f"Failed to download project metadata from IPFS: {e}")

    if linked_user:
        user_details = fetch_blockchain_data(linked_user)
        if user_details:
            account_metadata_cid = user_details.get("admin@test", {}).get("account_metadata_cid")
            if account_metadata_cid:
                try:
                    user_metadata = download_json_from_ipfs(account_metadata_cid)
                    logger.info(f"Downloaded user metadata: {user_metadata}")
                except Exception as e:
                    logger.error(f"Failed to download user metadata: {e}")


def process_search_result(result_dict):
    project_id = result_dict.get('project_id')
    file_cid = result_dict.get('file_cid')
    metadata_cid = result_dict.get('metadata_cid')

    if not project_id or not file_cid or not metadata_cid:
        logger.error(f"Missing required data in result: {result_dict}")
        return

    logger.info(f"Processing Project ID: {project_id}")
    project_details = fetch_blockchain_data(project_id)
    if not project_details:
        return

    validation_result = fetch_project_details(file_cid, project_details)
    if validation_result["is_valid"]:
        process_valid_result(project_id, validation_result)
    else:
        logger.warning(f"Invalid File CID for Project ID: {project_id}. Skipping metadata processing.")



# Schema definition remains unchanged.
def get_schema():
    return Schema(
        project_id=TEXT(stored=True),
        file_cid=ID(stored=True),
        metadata_cid=ID(stored=True),
        creator=TEXT(stored=True),
        language=TEXT(stored=True),
        title=TEXT(stored=True),
        description=TEXT(stored=True),
        subject=TEXT(stored=True),
        publisher=TEXT(stored=True),
        date=TEXT(stored=True),
        abstract=TEXT(stored=True),
        format=TEXT(stored=True),
        created=TEXT(stored=True),
        modified=TEXT(stored=True),
        full_text=TEXT(stored=True)  # Updated to stored=True
    )
                           

# def _normalize_value(value):
#     return str(value) if isinstance(value, (str, int, float)) else 'Unknown'
                             
# Function to normalize metadata values
def normalize_metadata_value(value):
    """
    Normalize metadata values to lowercase and handle missing values.
    :param value: Metadata value (str, list, or other types).
    :return: Normalized metadata value as a string.
    """
    try:
        if value is None:
            return "Unknown"
        if isinstance(value, list):
            return ', '.join([str(v).lower().strip() for v in value])
        if isinstance(value, dict):
            return json.dumps(value, ensure_ascii=False)  # For nested dicts
        return str(value).lower().strip() if isinstance(value, str) else str(value)
    except Exception as e:
        logger.error(f"Error normalizing metadata value: {e}")
        return "Error"


# Function to extract only Dublin Core related metadata
def extract_dublin_core(metadata):
    """
    Extract only Dublin Core-related metadata.
    :param metadata: The full metadata dictionary.
    :return: A dictionary of Dublin Core metadata.
    """
    dc_metadata = {k: v for k, v in metadata.items() if k.startswith(('dc:', 'dcterms:'))}
    logger.info(f"Dublin Core metadata extracted: {len(dc_metadata)} fields.")
    return dc_metadata

# Updated index_metadata function.
def index_metadata(metadata, full_text, schema, project_id, file_cid, metadata_cid, index_dir="indexdir", recreate=False):
    try:
        ix = recreate_index() if recreate else setup_index()
        writer = get_writer_with_retry(ix)

        writer.add_document (
        project_id= project_id,
        file_cid= file_cid,
        metadata_cid= metadata_cid,
        title= normalize_metadata_value(metadata.get("dc:title")),
        creator= normalize_metadata_value(metadata.get("dc:creator", "Unknown")),
        language= normalize_metadata_value(metadata.get("dc:language", "en")),
        subject= normalize_metadata_value(metadata.get("dc:subject", "")),
        description= normalize_metadata_value(metadata.get("dc:description", "")),
        publisher= normalize_metadata_value(metadata.get("dc:publisher", "Unknown")),
        date= normalize_metadata_value(metadata.get("dc:date", "")),
        abstract= normalize_metadata_value(metadata.get("dc:abstract", "")),
        format= normalize_metadata_value(metadata.get("dc:format", "")),
        created= normalize_metadata_value(metadata.get("dcterms:created", "")),
        modified= normalize_metadata_value(metadata.get("dcterms:modified", "")),
        full_text= full_text)
       
        writer.commit()
        logger.info(f"Metadata indexed successfully: {metadata_cid}")
        return ix
    
    except Exception as e:
        logger.error(f"Error indexing metadata: {e}")
        return None
    


def search_index(index, keyword):
    """
    Search for a keyword in the index and log the outcome.
    
    Parameters:
        index: The Whoosh index to search.
        keyword: The keyword to search for.
    
    Returns:
        tuple: A list of search results as dictionaries and a list of project IDs.
    """
    try:
        logger.info("Starting keyword search...")
        logger.info(f"Keyword: '{keyword}'")
        
        with index.searcher() as searcher:
            # Create a query parser for multiple fields
            parser = MultifieldParser(
                ["abstract", "full_text", "name", "title", "subject"], 
                schema=index.schema
            )
            query = parser.parse(keyword)
            results = searcher.search(query, limit=20)  # Limit to 20 results
            
            with with_logging_block("Keyword Search", logger):
                if not results:
                    logger.warning(f"No search results found for keyword: '{keyword}'. Exiting the script.")
                    sys.exit(1)

                # Log the total number of search results
                total_results = len(results)
                logger.info(f"Total search results found for keyword '{keyword}': {total_results}")
                
                # List the `project_id` and `file_cid` for each search result
                logger.info("Listing all search results:")
                for idx, result in enumerate(results, 1):
                    project_id = result.get('project_id', 'N/A')
                    file_cid = result.get('file_cid', 'N/A')
                    logger.info(f"Result {idx}: Project ID: {project_id}, File CID: {file_cid}")
                
                # Log the full details of search results, excluding the 'full_text' field
                logger.info(f"Full search results for keyword '{keyword}' (excluding 'full_text'):")
                for idx, result in enumerate(results, 1):
                    filtered_result = {k: v for k, v in result.items() if k != "full_text"}
                    logger.info(f"Result {idx}: {json.dumps(filtered_result, indent=2)}")

            # Convert results to a list of dictionaries and extract project IDs
            return [dict(result) for result in results], [result['project_id'] for result in results]
    
    except Exception as e:
        logger.error(f"Error during keyword search: {e}")
        return None, []




def validate_file_cid(file_cid, project_details):
    logger.info(f"Validating CID: {file_cid}")

    # Fetch the project details for the specific project
    try:
        for user, user_data in project_details.items():
            for file_key, cids in user_data.items():
                if file_key != 'project_metadata_cid':  # Skip project_metadata_cid key
                    if file_cid in cids.split(', '):  # Check if the CID exists in the value
                        logger.info(f"CID {file_cid} found in {file_key}.")
                        return True
        logger.warning(f"CID {file_cid} not found in any file key.")
        return False
    except Exception as e:
        logger.error(f"Error validating file CID: {e}")
        return False




def fetch_project_details(file_cid, blockchain_data):
    """
    Fetch project metadata CID, linked user, and validate file CID from blockchain data.

    Args:
        file_cid (str): The CID of the file to be validated.
        blockchain_data (dict): The blockchain data containing file and project details.

    Returns:
        dict: Dictionary with 'is_valid', 'project_metadata_cid', and 'linked_user'.
    """
    logger.info(f"Validating and fetching details for CID: {file_cid}")
    try:
        for admin, details in blockchain_data.items():
            # Check for file CIDs
            for key, value in details.items():
                if key not in ["account_metadata_cid", "linked_user"]:  # Skip metadata and linked user
                    cids = value.split(", ")
                    if file_cid in cids:
                        logger.info(f"***** File CID {file_cid} found under {key}, the file is VALID *****")
                        return {
                            "is_valid": True,
                            "project_metadata_cid": details.get("project_metadata_cid"),
                            "linked_user": details.get("linked_user"),
                        }
        
        # File CID not found
        logger.warning(f"File CID {file_cid} not found in blockchain data.")
        return {
            "is_valid": False,
            "project_metadata_cid": None,
            "linked_user": None,
        }
    except Exception as e:
        logger.error(f"Error fetching project details: {e}")
        raise

    
# Recreate index
def recreate_index():
    if os.path.exists("indexdir"):
        shutil.rmtree("indexdir")
    os.mkdir("indexdir")
    ix = create_in("indexdir", get_schema())
    logger.info("Index recreated.")
    return ix

# Retry obtaining writer
def get_writer_with_retry(ix, retries=5, delay=1):
    for attempt in range(retries):
        try:
            return ix.writer()
        except LockError:
            logger.warning(f"Writer is locked, retrying in {delay} seconds... (Attempt {attempt + 1})")
            time.sleep(delay)

    reset_index_writer()
    raise Exception("Failed to acquire writer lock after several attempts.")

# Reset writer lock
def reset_index_writer():
    lock_file = "indexdir/WRITELOCK"
    if os.path.exists(lock_file):
        os.remove(lock_file)
        logger.info("Lock file removed. Writer reset.")

# Setup index
def setup_index():
    index_dir = "indexdir"
    if not os.path.exists(index_dir):
        os.mkdir(index_dir)
        logger.info("Index directory created.")
        ix = create_in(index_dir, get_schema())
    else:
        try:
            ix = open_dir(index_dir)
            logger.info("Opened existing index.")
        except EmptyIndexError:
            logger.warning("Index is empty. Creating a new index.")
            ix = create_in(index_dir, get_schema())
    return ix

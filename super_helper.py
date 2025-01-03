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



# Initialize Tika
tika.initVM()

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
    :param index: The Whoosh index to search.
    :param keyword: The keyword to search for.
    :return: List of search results or None if no results.
    """

    try:
        logger.info("Starting keyword search...")
        logger.info(f"Keyword: '{keyword}'")
        
        with index.searcher() as searcher:
            parser = MultifieldParser(
                ["abstract", "full_text", "name", "title", "subject"], 
                schema=index.schema
            )
            query = parser.parse(keyword)
            results = searcher.search(query, limit=20)  # Limit to 10 results

            if results:
                logger.info(f"Search successful: Found {len(results)} result(s).")
                for i, result in enumerate(results, 1):
                    logger.info(f"{i}. Project Id: {result['project_id']}, File CID: {result['file_cid']}, Metadata CID: {result['metadata_cid']}, Title: {result['title']}")
                    # print(result)
                return [dict(result) for result in results], [result['project_id'] for result in results]
            else:
                logger.warning("No results found for the given keyword.")
                logger.info("Suggestion: Refine the keyword or try broader terms.")
                return None, []

    except Exception as e:
        logger.error(f"Error during keyword search: {e}")
        return None, []



# def validate_file_cid(index_cid, blockchain_data):
#     """
#     Validate the File CID from the index against all File CIDs in the blockchain data.

#     Args:
#         index_cid (str): File CID retrieved from the index.
#         blockchain_data (dict): Encoded blockchain data containing file CIDs.

#     Returns:
#         bool: True if valid, False otherwise.
#     """
    
#     logging.basicConfig(level=logging.INFO)

#     try:
#         logging.debug(f"Validating CID: {index_cid}")
#         logging.debug(f"Blockchain Data: {blockchain_data}")

#         # Check the data for the admin account
#         admin_data = blockchain_data.get("admin@test", {})
#         logging.debug(f"Admin Data: {admin_data}")

#         # Iterate through all keys in the admin data
#         for key, encoded_cids in admin_data.items():
#             logging.debug(f"Checking Key: {key}, Encoded CIDs: {encoded_cids}")

#             # Skip non-file keys like project_metadata_cid
#             if key == "project_metadata_cid":
#                 continue

#             # Parse the CIDs for the current file key
#             blockchain_cids = [cid.strip() for cid in encoded_cids.split(",")]
#             logging.debug(f"Parsed CIDs: {blockchain_cids}")

#             # Check if the index CID matches any CID in the list
#             if index_cid in blockchain_cids:
#                 logging.info(f"Match found for CID: {index_cid}")
#                 return True

#         # If no match is found
#         logging.info("No match found for the CID.")
#         return False
#     except Exception as e:
#         logging.error(f"Error validating file CID: {e}")
#         return False


def validate_file_cid(file_cid, project_details):
    logger.debug(f"Validating CID: {file_cid}")

    # Fetch the project details for the specific project
    try:
        for user, user_data in project_details.items():
            for file_key, cids in user_data.items():
                if file_key != 'project_metadata_cid':  # Skip project_metadata_cid key
                    if file_cid in cids.split(', '):  # Check if the CID exists in the value
                        logger.debug(f"CID {file_cid} found in {file_key}.")
                        return True
        logger.debug(f"CID {file_cid} not found in any file key.")
        return False
    except Exception as e:
        logger.error(f"Error validating file CID: {e}")
        return False



from loguru import logger

def fetch_project_details(file_cid, blockchain_data):
    """
    Fetch project metadata CID, linked user, and validate file CID from blockchain data.

    Args:
        file_cid (str): The CID of the file to be validated.
        blockchain_data (dict): The blockchain data containing file and project details.

    Returns:
        dict: Dictionary with 'is_valid', 'project_metadata_cid', and 'linked_user'.
    """
    logger.debug(f"Validating and fetching details for CID: {file_cid}")
    try:
        for admin, details in blockchain_data.items():
            # Check for file CIDs
            for key, value in details.items():
                if key not in ["project_metadata_cid", "linked_user"]:  # Skip metadata and linked user
                    cids = value.split(", ")
                    if file_cid in cids:
                        logger.debug(f"File CID {file_cid} found under {key}.")
                        return {
                            "is_valid": True,
                            "project_metadata_cid": details.get("project_metadata_cid"),
                            "linked_user": details.get("linked_user"),
                        }
        
        # File CID not found
        logger.debug(f"File CID {file_cid} not found in blockchain data.")
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

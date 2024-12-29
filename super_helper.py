import json
import logging
import os
from whoosh.index import create_in, open_dir, LockError, EmptyIndexError
from whoosh.fields import Schema, TEXT, ID
from whoosh.qparser import QueryParser
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
        cid=ID(stored=True),
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

# Adjusted add_document function.
# Adjusted add_document function.
def add_document(project_id, file_cid, metadata, full_text):
    """
    Add a document to the Whoosh index.
    :param writer: The index writer.
    :param project_id: The associated project ID.
    :param file_cid: The file CID.
    :param metadata: A dictionary containing metadata.
    """
    normalized_metadata = {
        'project_id': project_id,
        'cid': file_cid,  # Upload the full metadata
        # 'name': filename,
        # 'size': os.path.getsize(file_path),
        # 'filetype': mimetypes.guess_type(filename)[0] or "unknown",
        'title': normalize_metadata_value(metadata.get("dc:title")),
        'creator': normalize_metadata_value(metadata.get("dc:creator", "Unknown")),
        'language': normalize_metadata_value(metadata.get("dc:language", "en")),
        'subject': normalize_metadata_value(metadata.get("dc:subject", "")),
        'description': normalize_metadata_value(metadata.get("dc:description", "")),
        'publisher': normalize_metadata_value(metadata.get("dc:publisher", "Unknown")),
        'date': normalize_metadata_value(metadata.get("dc:date", "")),
        'abstract': normalize_metadata_value(metadata.get("dc:abstract", "")),
        'format': normalize_metadata_value(metadata.get("dc:format", "")),
        'created': normalize_metadata_value(metadata.get("dcterms:created", "")),
        'modified': normalize_metadata_value(metadata.get("dcterms:modified", "")),
        'full_text': full_text
    }
    
    print(normalized_metadata)
    
    return normalized_metadata
                            

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
def index_metadata(metadata, full_text, schema, project_id, file_cid, index_dir="indexdir", recreate=False):
    try:
        ix = recreate_index() if recreate else setup_index()
        writer = get_writer_with_retry(ix)

        # metadata = {k: normalize_metadata_value(v) for k, v in metadata.items()}
        # x = add_document(project_id, file_cid, metadata, full_text)
        
        writer.add_document (
        project_id= project_id,
        cid= file_cid,
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
        logger.info(f"Metadata indexed successfully: {file_cid}")
        return ix
    
    except Exception as e:
        logger.error(f"Error indexing metadata: {e}")
        return None
    

from whoosh.qparser import MultifieldParser

import logging

# logger = logging.getLogger("super_helper")

# Updated search_index function.
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
                ["full_text", "name", "title", "subject"], 
                schema = index.schema
            )
            query = parser.parse(keyword)
            results = searcher.search(query, limit=10)  # Limit to 10 results

            if results:
                logger.info(f"Search successful: Found {len(results)} result(s).")
                for i, result in enumerate(results, 1):
                    # logger.info(f"{i}. Title: {result.get('title', 'N/A')}")
                    print(result)
                return [dict(result) for result in results]
            else:
                logger.warning("No results found for the given keyword.")
                logger.info("Suggestion: Refine the keyword or try broader terms.")
                return None
    except Exception as e:
        logger.error(f"Error during keyword search: {e}")
        return None


def check_fields(ix):
    try:
        logger.info("Checking which fields have data...")
        
        with ix.searcher() as searcher:
            # Get the schema of the Whoosh index
            schema = ix.schema
            
            print("All fields:")
            for field_name in sorted(schema.keys()):
                print(field_name)
            
    except Exception as e:
        logger.error(f"Error during check: {e}")


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

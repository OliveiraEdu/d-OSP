import os
import logging
import shutil
import mimetypes
from tika import parser
from whoosh.index import create_in, open_dir, LockError
from whoosh.fields import Schema, TEXT, ID, NUMERIC
from whoosh.qparser import QueryParser
from ipfs_functions import upload_file_to_ipfs, upload_json_to_ipfs
from dump_to_json import update_project_entry_with_file_data

# Logging configuration
logging.basicConfig(level=logging.INFO)

# Function to normalize metadata and handle lists
def normalize_metadata_value(value):
    """Normalize metadata value by handling strings and lists."""
    if isinstance(value, list):
        # Join the list into a single string
        return ', '.join([str(v).lower() for v in value])
    elif isinstance(value, str):
        return value.lower()
    return str(value).lower()  # For any other types, convert to string and lowercase

def reset_index_writer():
    """Manually remove the lock file if it exists."""
    lock_file = "indexdir/WRITELOCK"
    if os.path.exists(lock_file):
        os.remove(lock_file)
        logging.info("Lock file removed. Writer reset.")

def recreate_index(schema):
    """Recreate the index directory and start fresh."""
    if os.path.exists("indexdir"):
        shutil.rmtree("indexdir")  # Remove the entire index directory
    os.mkdir("indexdir")
    ix = create_in("indexdir", schema)  # Recreate index
    logging.info("Index recreated.")
    return ix

def get_writer_with_retry(ix, retries=5, delay=1):
    """Retry acquiring the writer with a delay, and reset lock if retries exhausted."""
    for attempt in range(retries):
        try:
            return ix.writer()
        except LockError:
            logging.warning(f"Writer is locked, retrying in {delay} seconds... (Attempt {attempt + 1})")
            time.sleep(delay)

    reset_index_writer()
    raise Exception("Failed to acquire writer lock after several attempts.")


def add_document(writer, metadata, full_text):
    """Normalize the metadata and add it to the index."""
    writer.add_document(
        cid=metadata['cid'],
        name=normalize_metadata_value(metadata['name']),
        size=metadata['size'],
        filetype=normalize_metadata_value(metadata['filetype']),
        title=normalize_metadata_value(metadata['title']),
        creator=normalize_metadata_value(metadata['creator']),
        language=normalize_metadata_value(metadata['language']),
        subject=normalize_metadata_value(metadata['subject']),
        description=normalize_metadata_value(metadata['description']),
        publisher=normalize_metadata_value(metadata['publisher']),
        date=normalize_metadata_value(metadata['date']),
        abstract=normalize_metadata_value(metadata.get('abstract', '')),
        format=normalize_metadata_value(metadata.get('format', '')),
        created=normalize_metadata_value(metadata.get('created', '')),
        modified=normalize_metadata_value(metadata.get('modified', '')),
        full_text=full_text
    )
    logging.info(f"Document {metadata['name']} indexed successfully.")


def search_ipfs(keyword, ix):
    """Search for a keyword in the indexed documents."""
    try:
        with ix.searcher() as searcher:
            query = QueryParser("full_text", ix.schema).parse(keyword)
            results = searcher.search(query)

            if results:
                for result in results:
                    logging.info(f"CID: {result['cid']}, Name: {result['name']}, Title: {result['title']}, "
                                 f"Creator: {result['creator']}, Size: {result['size']} bytes")
            else:
                logging.info(f"No results found for '{keyword}'")
    except Exception as e:
        logging.error(f"Error occurred during search: {e}")


# Function to extract only Dublin Core related metadata
def extract_dublin_core(metadata):
    return {k: v for k, v in metadata.items() if k.startswith('dc:') or k.startswith('dcterms:')}

# Function to parse a file and extract Dublin Core metadata
def extract_metadata_from_file(file_path):
    # Parse the file with Tika
    parsed = parser.from_file(file_path)
    
    # Get the full metadata from the parsed content
    metadata = parsed.get("metadata", {})
    
    # Extract only Dublin Core related metadata
    dublin_core_metadata = extract_dublin_core(metadata)
    
    return dublin_core_metadata

# Function to read a file and print Dublin Core metadata
def process_file(file_path):
    dublin_core_metadata = extract_metadata_from_file(file_path)
    
    # Check if any Dublin Core metadata was found
    if dublin_core_metadata:
        print("Dublin Core Metadata Extracted:")
        print(json.dumps(dublin_core_metadata, indent=4))
    else:
        print("No Dublin Core metadata found.")
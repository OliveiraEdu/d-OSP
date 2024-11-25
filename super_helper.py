import json
import os
from whoosh.index import create_in, open_dir, LockError, EmptyIndexError
from whoosh.fields import Schema, TEXT, ID, NUMERIC
from whoosh.qparser import QueryParser
import tika
from tika import parser
# import ipfshttpclient
from pyvis.network import Network
from datetime import datetime
from loguru import logger
from new_helper import *
import shutil
import time  # Import time for sleep

# Initialize Tika
tika.initVM()

# # Configure IPFS client
# client = ipfshttpclient.connect('/ip4/127.0.0.1/tcp/5001')

# Directory for Whoosh index
INDEX_DIR = "indexdir"
if not os.path.exists(INDEX_DIR):
    os.mkdir(INDEX_DIR)

# Define the schema
schema = Schema(
    project_id=TEXT(stored=True),
    cid=ID(stored=True),
    name=TEXT(stored=True),
    size=NUMERIC(stored=True),
    filetype=TEXT(stored=True),
    title=TEXT(stored=True),
    creator=TEXT(stored=True),
    language=TEXT(stored=True),
    subject=TEXT(stored=True),
    description=TEXT(stored=True),
    publisher=TEXT(stored=True),
    date=TEXT(stored=True),
    abstract=TEXT(stored=True),
    format=TEXT(stored=True),
    created=TEXT(stored=True),
    modified=TEXT(stored=True),
    full_text=TEXT(stored=False)
)

def get_schema():
    return Schema(
        project_id=TEXT(stored=True),
        cid=ID(stored=True),
        name=TEXT(stored=True),
        size=NUMERIC(stored=True),
        filetype=TEXT(stored=True),
        title=TEXT(stored=True),
        creator=TEXT(stored=True),
        language=TEXT(stored=True),
        subject=TEXT(stored=True),
        description=TEXT(stored=True),
        publisher=TEXT(stored=True),
        date=TEXT(stored=True),
        abstract=TEXT(stored=True),
        format=TEXT(stored=True),
        created=TEXT(stored=True),
        modified=TEXT(stored=True),
        full_text=TEXT(stored=False)
    )



# def add_document(writer, metadata, full_text):
#     """Normalize the metadata and add it to the index."""
    
#     writer.add_document(
#         project_id = metadata['project_id'],
#         cid=metadata['cid'],
#         name=normalize_metadata_value(metadata['name']),
#         size=metadata['size'],
#         filetype=normalize_metadata_value(metadata['filetype']),
#         title=normalize_metadata_value(metadata['title']),
#         creator=normalize_metadata_value(metadata['creator']),
#         language=normalize_metadata_value(metadata['language']),
#         subject=normalize_metadata_value(metadata['subject']),
#         description=normalize_metadata_value(metadata['description']),
#         publisher=normalize_metadata_value(metadata['publisher']),
#         date=normalize_metadata_value(metadata['date']),
#         abstract=normalize_metadata_value(metadata.get('abstract', '')),  # Provide fallback
#         format=normalize_metadata_value(metadata.get('format', '')),      # Provide fallback
#         created=normalize_metadata_value(metadata.get('created', '')),    # Provide fallback
#         modified=normalize_metadata_value(metadata.get('modified', '')),  # Provide fallback
#         full_text=full_text
#     )
#     logger.info(f"Document {metadata['name']} indexed successfully.")


# Call add_document function to execute document writing to the index - WIP for tomorrow UAI!
# Step 2: Index Metadata
def index_metadata(metadata, recreate=False):
    ix = recreate_index(schema) if recreate else create_in("indexdir", schema)
    writer = get_writer_with_retry(ix)
    
    
    writer.add_document(
        project_id=metadata.get("project_id", ""),
        cid=metadata.get("cid", ""),
        name=metadata.get("name", ""),
        size=int(metadata.get("size", 0)),
        filetype=metadata.get("filetype", ""),
        title=metadata.get("title", ""),
        creator=metadata.get("creator", ""),
        language=metadata.get("language", ""),
        subject=metadata.get("subject", ""),
        description=metadata.get("description", ""),
        publisher=metadata.get("publisher", ""),
        date=metadata.get("date", ""),
        abstract=metadata.get("abstract", ""),
        format=metadata.get("format", ""),
        created=metadata.get("created", ""),
        modified=metadata.get("modified", ""),
        full_text=metadata.get("full_text", "")
    )
    writer.commit()
    logger.info("File indexed")
    
    return ix  # Return the ix object here

# Step 4: Search Metadata by Keyword
# def search_metadata(keyword):
#     ix = open_dir(INDEX_DIR)
#     qp = QueryParser("full_text", schema=ix.schema)
#     query = qp.parse(keyword)
#     results = []
#     with ix.searcher() as searcher:
#         result = searcher.search(query)
#         results = [hit["cid"] for hit in result]
#     return results

def search_index(keyword, ix):
    """Search for a keyword in the indexed documents."""
    try:
        with ix.searcher() as searcher:
            query = QueryParser("full_text", ix.schema).parse(keyword)
            results = searcher.search(query)

            project_ids = []
            if results:
                for result in results:
                    logger.info(f"CID: {result['cid']}, Project: {result['project_id']}, Name: {result['name']}, Title: {result['title']}, "
                                 f"Creator: {result['creator']}, Size: {result['size']} bytes")
                    project_ids.append(result['project_id'])
            else:
                logger.info(f"No results found for '{keyword}'")

        return project_ids
    except Exception as e:
        logger.error(f"Error occurred during search: {e}")



# Step 5: Fetch Metadata from IPFS
def fetch_metadata_from_ipfs(cid):
    return client.get_json(cid)

# Step 6: Build and Display Knowledge Graph
def build_and_display_knowledge_graph(project_id, related_data):
    net = Network(height="750px", width="100%", directed=True)
    net.add_node(project_id, label=project_id, color="lightblue")
    for key, value in related_data.items():
        if isinstance(value, dict):  # For nested files
            for sub_key, sub_value in value.items():
                net.add_node(sub_value, label=sub_key)
                net.add_edge(project_id, sub_value, label=key)
        else:
            net.add_node(value, label=key)
            net.add_edge(project_id, value, label=key)
    net.show("knowledge_graph.html")


def recreate_index(schema):
    """Recreate the index directory and start fresh."""
    if os.path.exists("indexdir"):
        shutil.rmtree("indexdir")  # Remove the entire index directory
    os.mkdir("indexdir")
    ix = create_in("indexdir", schema)  # Recreate index
    logger.info("Index recreated.")
    return ix

def get_writer_with_retry(ix, retries=5, delay=1):
    """Retry acquiring the writer with a delay, and reset lock if retries exhausted."""
    for attempt in range(retries):
        try:
            return ix.writer()
        except LockError:
            logger.warning(f"Writer is locked, retrying in {delay} seconds... (Attempt {attempt + 1})")
            time.sleep(delay)

    reset_index_writer()
    raise Exception("Failed to acquire writer lock after several attempts.")


def reset_index_writer():
    """Manually remove the lock file if it exists."""
    lock_file = "indexdir/WRITELOCK"
    if os.path.exists(lock_file):
        os.remove(lock_file)
        logger.info("Lock file removed. Writer reset.")


# Function to set up the Whoosh index directory
def setup_index(schema):
    """Sets up the Whoosh index directory and returns the index object."""
    index_dir = "indexdir"
    if not os.path.exists(index_dir):
        os.mkdir(index_dir)
        logger.info("Index directory created.")
        ix = create_in(index_dir, schema)
    else:
        try:
            ix = open_dir(index_dir)
            logger.info("Opened existing index.")
        except EmptyIndexError:
            logger.warning("Index is empty. Creating a new index.")
            ix = create_in(index_dir, schema)
    return ix


# # Step 1: Extract and Normalize Metadata
# print("Step 1: Extracting and Normalizing Metadata")
# metadata = extract_and_normalize_metadata(file_path)
# print("Extracted Metadata:", json.dumps(metadata, indent=2))

# # Step 2: Index Metadata
# print("\nStep 2: Indexing Metadata")
# index_metadata(metadata)
# print("Metadata indexed successfully.")

# # Step 3: Send Metadata JSON to IPFS
# print("\nStep 3: Sending Metadata JSON to IPFS")
# metadata_cid = send_metadata_to_ipfs(metadata)
# print("Metadata CID:", metadata_cid)

# # Step 4: Search Metadata by Keyword
# keyword = "sample_keyword"  # Replace with an actual keyword relevant to your metadata
# print("\nStep 4: Searching Metadata by Keyword")
# metadata_cids = search_metadata(keyword)
# print("Search Results (Metadata CIDs):", metadata_cids)

# # Step 5: Fetch Metadata from IPFS
# if metadata_cids:
#     print("\nStep 5: Fetching Metadata from IPFS")
#     fetched_metadata = fetch_metadata_from_ipfs(metadata_cids[0])
#     print("Fetched Metadata from IPFS:", json.dumps(fetched_metadata, indent=2))
# else:
#     print("\nNo metadata found for the specified keyword.")

# # Step 6: Build and Display Knowledge Graph
# project_id = metadata.get("project_id", "default_project_id")  # Fallback if no project account is in metadata
# print("\nStep 6: Building and Displaying Knowledge Graph")
# sample_related_data = {
#     "Owner": "Researcher_A",
#     "Funding Agency": "Agency_X",
#     "Files": {
#         "File 1": "file_cid_1",
#         "File 2": "file_cid_2"
#     },
#     "Keywords": ["Keyword_1", "Keyword_2"],
#     "Affiliated Institute": "Institute_Y"
# }
# build_and_display_knowledge_graph(project_id, sample_related_data)
# print("Knowledge graph created and saved as 'knowledge_graph.html'. Open this file to view the graph.")
# print("\nWorkflow Complete!")

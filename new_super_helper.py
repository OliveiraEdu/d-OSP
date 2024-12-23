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

# Directory for Whoosh index
INDEX_DIR = "indexdir"
if not os.path.exists(INDEX_DIR):
    os.mkdir(INDEX_DIR)

# Define the schema
schema = Schema(
    project_id=TEXT(stored=True),
    cid=ID(stored=True),
    metadata=TEXT(stored=True)
)

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

# Function to get the writer with retries
def get_writer_with_retry(ix):
    """Retry acquiring the writer with a delay."""
    for attempt in range(5):  # Define the number of retries here
        try:
            return ix.writer()
        except LockError:
            logger.warning(f"Writer is locked, retrying... (Attempt {attempt + 1})")
            time.sleep(1)  # Set the delay between retries

    reset_index_writer(ix)
    raise Exception("Failed to acquire writer lock after several attempts.")

# Function to set up the Whoosh index directory
def setup_writer(ix):
    """Sets up the writer for the Whoosh index."""
    try:
        return ix.writer()
    except LockError:
        logger.warning("Writer is locked. Retrying...")
        time.sleep(1)  # Set the delay between retries
        return get_writer_with_retry(ix)

# Function to reset the writer and acquire it again
def reset_index_writer(ix):
    """Reset the writer for the Whoosh index."""
    try:
        os.remove(os.path.join(INDEX_DIR, 'whoosh.lock'))
    except FileNotFoundError:
        pass  # The lock file doesn't exist
    
    time.sleep(0.1)  

    return ix.writer()

# Function to index metadata
def index_metadata(ix, data):
    """Index the given metadata."""
    with setup_writer(ix) as writer:
        writer.add_document(project_id=data['project_id'], 
                             cid=data['cid'],
                             metadata=data['metadata'])

# Function to search for project metadata
def search_project_metadata(ix, query):
    """Search for project metadata using the given query."""
    try:
        result = ix.search(query)
        return [doc.project_id for doc in result]
    except Exception as e:
        logger.error(f"Error searching index: {str(e)}")

# Function to build knowledge graph
def build_knowledge_graph(project_id, data):
    """Build the knowledge graph based on the given project ID and metadata."""
    network = Network()
    # Add nodes and edges to the network...
    return network

# Function to display knowledge graph
def display_knowledge_graph(network, output_file):
    """Display the knowledge graph in a web browser."""
    network.show(output_file)
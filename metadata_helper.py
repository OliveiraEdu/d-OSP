import os
import logging
import shutil
import mimetypes
import time  # Import time for sleep
from tika import parser
from whoosh.index import create_in, open_dir, LockError
from whoosh.fields import Schema, TEXT, ID, NUMERIC
from whoosh.qparser import QueryParser
from ipfs_functions import upload_file_to_ipfs, upload_json_to_ipfs
from dump_to_json import update_project_entry_with_file_data
import json  # Added for printing metadata

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
        project_id = metadata['project_id'],
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
        abstract=normalize_metadata_value(metadata.get('abstract', '')),  # Provide fallback
        format=normalize_metadata_value(metadata.get('format', '')),      # Provide fallback
        created=normalize_metadata_value(metadata.get('created', '')),    # Provide fallback
        modified=normalize_metadata_value(metadata.get('modified', '')),  # Provide fallback
        full_text=full_text
    )
    logging.info(f"Document {metadata['name']} indexed successfully.")
    

def search_index(keyword, ix):
    """Search for a keyword in the indexed documents."""
    try:
        with ix.searcher() as searcher:
            query = QueryParser("full_text", ix.schema).parse(keyword)
            results = searcher.search(query)

            project_ids = []
            if results:
                for result in results:
                    logging.info(f"CID: {result['cid']}, Project: {result['project_id']}, Name: {result['name']}, Title: {result['title']}, "
                                 f"Creator: {result['creator']}, Size: {result['size']} bytes")
                    project_ids.append(result['project_id'])
            else:
                logging.info(f"No results found for '{keyword}'")

        return project_ids
    except Exception as e:
        logging.error(f"Error occurred during search: {e}")

#Put the Iroha related function here for temporary tests

from Crypto.Hash import keccak
import os
import binascii
from iroha import IrohaCrypto
from iroha import Iroha, IrohaGrpc
from iroha.ed25519 import H
import integration_helpers
from iroha.primitive_pb2 import can_set_my_account_detail
import sys
import json
import icecream as ic

if sys.version_info[0] < 3:
    raise Exception("Python 3 or a more recent version is required.")

# Load configuration from config.json file
config_path = "config.json"  # Update this path as needed
with open(config_path, "r") as f:
    config = json.load(f)

IROHA_HOST_ADDR = config["IROHA_HOST_ADDR"]
IROHA_PORT = config["IROHA_PORT"]
ADMIN_ACCOUNT_ID = config["ADMIN_ACCOUNT_ID"]
ADMIN_PRIVATE_KEY = config["ADMIN_PRIVATE_KEY"]

iroha = Iroha(ADMIN_ACCOUNT_ID)
net = IrohaGrpc("{}:{}".format(IROHA_HOST_ADDR, IROHA_PORT))

# #Query - GetAccountDetail
# query = iroha.query('GetAccountDetail', account_id=project_id)
# IrohaCrypto.sign_query(query, ADMIN_PRIVATE_KEY)
# response = net.send_query(query)
# # print(response)
# project_data = response.account_detail_response
# project_details = project_data.detail
# print(f'Project Account id = {project_account}, {project_details}')

#---

import logging
from rdflib import Graph, Literal, RDF, URIRef, Namespace
from rdflib.namespace import FOAF, DC
from whoosh.qparser import QueryParser
from iroha import IrohaCrypto

# Sample namespaces
SCHEMA = Namespace("http://schema.org/")
EX = Namespace("http://example.org/")

# Functions provided earlier
def get_project_details(project_ids, net, iroha):
    admin_private_key = ADMIN_PRIVATE_KEY
    project_accounts = []
    
    for project_id in set(project_ids):  # Remove duplicates by converting to a set
        query = iroha.query('GetAccountDetail', account_id=project_id)
        IrohaCrypto.sign_query(query, admin_private_key)
        response = net.send_query(query)
        project_data = response.account_detail_response
        project_details = project_data.detail
        logging.info(f"Project Account id = {project_id}, {project_details}")
        
        project_accounts.append({
            "account_id": project_id,
            "project_details": project_details
        })
    return project_accounts

def search_index(keyword, ix):
    try:
        with ix.searcher() as searcher:
            query = QueryParser("full_text", ix.schema).parse(keyword)
            results = searcher.search(query)

            project_ids = []
            search_results = []
            if results:
                for result in results:
                    logging.info(f"CID: {result['cid']}, Project: {result['project_id']}, Name: {result['name']}, Title: {result['title']}, "
                                 f"Creator: {result['creator']}, Size: {result['size']} bytes")
                    project_ids.append(result['project_id'])
                    search_results.append({
                        "cid": result['cid'],
                        "project_id": result['project_id'],
                        "name": result['name'],
                        "title": result['title'],
                        "creator": result['creator'],
                        "size": result['size']
                    })
            else:
                logging.info(f"No results found for '{keyword}'")

        # Ensure both lists are returned, even if empty
        return project_ids, search_results
    except Exception as e:
        logging.error(f"Error occurred during search: {e}")
        return [], []  # Return empty lists in case of an error

import json

def generate_knowledge_graph(search_results, project_details):
    g = Graph()
    
    for search_result in search_results:
        # Create project node
        project_uri = URIRef(f"http://example.org/project/{search_result['project_id']}")
        g.add((project_uri, RDF.type, EX.Project))
        g.add((project_uri, EX.hasCID, Literal(search_result['cid'])))
        g.add((project_uri, EX.hasTitle, Literal(search_result['title'])))
        
        # Find matching project details for the current project ID
        matching_details = next((detail for detail in project_details if detail['account_id'] == search_result['project_id']), None)
        if not matching_details:
            continue
        
        # Parse project details, assuming JSON format
        project_data = matching_details['project_details']
        if isinstance(project_data, str):
            try:
                project_data = json.loads(project_data)
            except json.JSONDecodeError:
                logging.error(f"Failed to parse project details for project_id {search_result['project_id']}")
                continue

        # Check for matching CIDs in project details
        for key, value in project_data.items():
            if isinstance(value, dict):
                for sub_key, sub_value in value.items():
                    if sub_value == search_result['cid']:
                        g.add((project_uri, EX.hasFile, Literal(sub_key)))
            elif value == search_result['cid']:
                g.add((project_uri, EX.hasFile, Literal(key)))
    
    # Serialize and print graph for debugging
    print(g.serialize(format='turtle'))


#---
# def get_project_details(project_ids, net, iroha):
#     """Get account details for each project ID."""
#     admin_private_key = ADMIN_PRIVATE_KEY
#     project_accounts = []
    
#     unique_project_ids = set(project_id for _, project_id in project_ids)  # Remove duplicates

#     for project_id in unique_project_ids:
#         query = iroha.query('GetAccountDetail', account_id=project_id)
#         IrohaCrypto.sign_query(query, admin_private_key)
#         response = net.send_query(query)
#         project_data = response.account_detail_response
#         project_details = project_data.detail
#         print(f"Project Account id = {project_id}, {project_details}")
#         project_accounts.append({
#             "account_id": project_id,
#             "project_details": project_details
#         })

#     return project_accounts


# def search_index(keyword, ix):
#     """Search for a keyword in the indexed documents."""
#     project_ids = []
#     try:
#         with ix.searcher() as searcher:
#             query = QueryParser("full_text", ix.schema).parse(keyword)
#             results = searcher.search(query)

#             if results:
#                 for result in results:
#                     logging.info(f"CID: {result['cid']}, Project: {result['project_id']}, Name: {result['name']}, Title: {result['title']}, "
#                                  f"Creator: {result['creator']}, Size: {result['size']} bytes")
#                     project_ids.append((result['cid'], result['project_id']))
#             else:
#                 logging.info(f"No results found for '{keyword}'")

#     except Exception as e:
#         logging.error(f"Error occurred during search: {e}")
    
#     return project_ids


def check_cid_in_project_details(keyword, ix, net, iroha):
    """Check if CID from search results is found in the project account details."""
    # Step 1: Search for the keyword in the index
    project_id_cid_pairs = search_index(keyword, ix)
    
    if not project_id_cid_pairs:
        logging.info("No projects found for the given keyword.")
        return

    # Step 2: Get project details for each unique project ID
    project_details_list = get_project_details(project_id_cid_pairs, net, iroha)

    # Step 3: Check for each CID and Project ID in the fetched project details
    for cid, project_id in project_id_cid_pairs:
        found = False
        for project in project_details_list:
            if project["account_id"] == project_id and cid in project["project_details"]:
                logging.info(f"Match found! CID: {cid} is associated with Project ID: {project_id} in the project details.")
                found = True
                break
        if not found:
            logging.info(f"No match found for CID: {cid} and Project ID: {project_id} in the project details.")



# Function to extract only Dublin Core related metadata
def extract_dublin_core(metadata):
    return {k: v for k, v in metadata.items() if k.startswith('dc:') or k.startswith('dcterms:')}


# Function to parse a file and extract Dublin Core metadata
def extract_metadata_from_file(file_path):
    try:
        # Parse the file with Tika
        parsed = parser.from_file(file_path)
        
        # Get the full metadata from the parsed content
        metadata = parsed.get("metadata", {})
        
        # Extract only Dublin Core related metadata
        dublin_core_metadata = extract_dublin_core(metadata)
        
        return dublin_core_metadata
    except Exception as e:
        logging.error(f"Error extracting metadata from file '{file_path}': {e}")
        return {}


# Function to read a file and print Dublin Core metadata
def process_file(file_path):
    dublin_core_metadata = extract_metadata_from_file(file_path)
    
    # Check if any Dublin Core metadata was found
    if dublin_core_metadata:
        print("Dublin Core Metadata Extracted:")
        print(json.dumps(dublin_core_metadata, indent=4))
    else:
        print("No Dublin Core metadata found.")
import os
from loguru import logger
from ipfs_functions import *
import tika
from tika import parser

# Initialize Tika
tika.initVM()

# Set up a basic configuration for Loguru
logger.add("logs.log", format="{time:MM.DD/YYYY} | {level} | {message}", level="INFO")


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

# Helper function to orchestrate the entire process
def process_files(directory_path):
    """Process files in the specified directory path."""
    try:
        for filename in list_files(directory_path):
            file_path = os.path.join(directory_path, filename)
            print(file_path)
            metadata = parse_file_with_tika(file_path)
            print(metadata)
            if metadata is not None and isinstance(metadata, dict):
                cid = upload_file_to_ipfs(file_path)
                print(cid)
                if cid is not None:
                    metadata_cid = upload_json_to_ipfs(metadata)
                    print(metadata_cid)
                    index_file_with_woosh(file_path, metadata_cid)
    except Exception as e:
        logger.error(f"Error processing files in {directory_path}: {e}")




# # Helper function to orchestrate the entire process
# def process_files(directory_path):
#     """Process files in the specified directory path."""
#     for filename in list_files(directory_path):
#         file_path = os.path.join(directory_path, filename)
#         metadata = parse_file_with_tika(file_path)
#         cid = upload_file_to_ipfs(file_path)
#         metadata_cid = upload_json_to_ipfs(metadata)
#         # index_file_with_woosh(file_path, metadata_cid)



# def upload_documents_in_directory(directory_path):
#     # Set up Loguru's logger with a basic configuration
#     logger.add("logs/logs.log", format="{time:MM.DD/YYYY} | {level} | {message}")
    
#     for filename in os.listdir(directory_path):
#         try:
#             if not os.path.basename(filename).startswith('.'):
#                 file_path = os.path.join(directory_path, filename)
                
#                 # Upload the file to IPFS and get its CID
#                 file_cid = upload_file_to_ipfs(file_path)
#                 logger.info(f"File {filename} uploaded to IPFS with CID: {file_cid}")

#                 # # Call some other function to handle metadata_cid and upload it to IPFS
#                 # metadata_cid = handle_metadata_and_upload_to_ipfs(file_path)

#                 # # Add the file_cid and metadata_cid into the database or do something else
#                 # add_file_cids_to_database(file_cid, metadata_cid)
#         except Exception as e:
#             logger.error(f"Error processing file {filename}: {e}")

#     # Use Loguru's `catch` decorator to catch any unexpected errors in the function
#     @logger.catch
#     def upload_file_to_ipfs(file_path):
#         try:
#             raise ValueError("Mock error")
#         except Exception as e:
#             logger.error(f"Error uploading file {file_path} to IPFS: {e}")

#     # Call the `upload_file_to_ipfs` function with a mock file path
#     upload_file_to_ipfs("/path/to/mock/file.txt")

# # Define the other functions used in this example
# def handle_metadata_and_upload_to_ipfs(file_path):
#     return "Metadata CID"

# def add_file_cids_to_database(file_cid, metadata_cid):
#     # Simulate adding the CIDs to the database


#     print(f"Added file CID: {file_cid} and metadata CID: {metadata_cid} to the database")
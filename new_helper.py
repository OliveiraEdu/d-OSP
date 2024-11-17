import os
from loguru import logger
from ipfs_functions import *
import tika
from tika import parser
import integration_helpers

# Initialize Tika
tika.initVM()

# Set up a basic configuration for Loguru
logger.add("logs/file_{time}.log", format="{time:MM.DD/YYYY} | {level} | {message}", level="INFO")


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

#Current
# Helper function to orchestrate the entire process
# def process_files(directory_path):
#     """Process files in the specified directory path."""
#     try:
#         for filename in list_files(directory_path):
#             file_path = os.path.join(directory_path, filename)
#             print("file: ", file_path)
#             metadata = parse_file_with_tika(file_path)
#             print("file metadata: ", metadata)
#             if metadata is not None and isinstance(metadata, dict):
#                 file_cid = upload_file_to_ipfs(file_path)
#                 print("file cid: ", file_cid)
#                 if file_cid is not None:
#                     metadata_cid = upload_json_to_ipfs(metadata)
#                     print("file metadata cid: ", metadata_cid)
#                     index_file_with_woosh(file_path, metadata_cid)
#     except Exception as e:
#         logger.error(f"Error processing files in {directory_path}: {e}")

#Option 1
# Helper function to orchestrate the entire process
# def process_files(directory_path):
#     """Process files in the specified directory path."""
#     try:
#         for filename in list_files(directory_path):
#             file_path = os.path.join(directory_path, filename)
#             print("File: ", file_path)
#             metadata = parse_file_with_tika(file_path)
#             print("File metadata: ", metadata)
#             if metadata is not None and isinstance(metadata, dict):
#                 file_cid = upload_file_to_ipfs(file_path)
#                 # print("file cid: ", file_cid)
#                 if file_cid is not None:
#                     metadata_cid = upload_json_to_ipfs(metadata)
#                     # print("file metadata cid: ", metadata_cid)
#                     yield file_cid, metadata_cid
#     except Exception as e:
#         logger.error(f"Error processing files in {directory_path}: {e}")


# Option 2
# Helper function to orchestrate the entire process
# def process_files(directory_path):
#     """Process files in the specified directory path."""
#     try:
#         cid_dict = {}
#         for filename in list_files(directory_path):
#             file_path = os.path.join(directory_path, filename)
#             print("file: ", file_path)
#             metadata = parse_file_with_tika(file_path)
#             print("file metadata: ", metadata)
#             if metadata is not None and isinstance(metadata, dict):
#                 file_cid = upload_file_to_ipfs(file_path)
#                 print("file cid: ", file_cid)
#                 if file_cid is not None:
#                     metadata_cid = upload_json_to_ipfs(metadata)
#                     print("file metadata cid: ", metadata_cid)
#                     cid_dict[filename] = (file_cid, metadata_cid)
#         return cid_dict
#     except Exception as e:
#         logger.error(f"Error processing files in {directory_path}: {e}")

# # Example usage
# if __name__ == "__main__":
#     directory_path = "/path/to/directory"
#     cid_dict = process_files(directory_path)
#     print("CID Dictionary:")
#     for filename, (file_cid, metadata_cid) in cid_dict.items():
#         print(f"File: {filename}, File CID: {file_cid}, Metadata CID: {metadata_cid}")

#Option 3
# def process_files(directory_path):
#     """Process files in the specified directory path."""
#     try:
#         cid_dict = {}
#         for filename in list_files(directory_path):
#             file_path = os.path.join(directory_path, filename)
#             print("file: ", file_path)
#             metadata = parse_file_with_tika(file_path)
#             print("file metadata: ", metadata)
#             if metadata is not None and isinstance(metadata, dict):
#                 file_cid = upload_file_to_ipfs(file_path)
#                 print("file cid: ", file_cid)
#                 if file_cid is not None:
#                     metadata_cid = upload_json_to_ipfs(metadata)
#                     print("file metadata cid: ", metadata_cid)
#                     cid_dict[filename] = (file_cid, metadata_cid)
#         return list(cid_dict.values())
#     except Exception as e:
#         logger.error(f"Error processing files in {directory_path}: {e}")

# def encoder(input_value):
#     """Encode the provided input values using argument encoding."""
#     encoded_value = ''.join(
#         integration_helpers.argument_encoding(v).decode('utf-8') 
#         for v in input_value
#      )
    
#     # Return the string value
#     return encoded_value

#Option 4
def process_files(directory_path):
    """Process files in the specified directory path."""
    try:
        cid_dict = {}
        file_count = 0

        for filename in list_files(directory_path):
            file_path = os.path.join(directory_path, filename)
            print("file: ", file_path)

            metadata = parse_file_with_tika(file_path)
            print("file metadata: ", metadata)

            if metadata is not None and isinstance(metadata, dict):
                file_cid = upload_file_to_ipfs(file_path)
                print("file cid: ", file_cid)

                if file_cid is not None:
                    metadata_cid = upload_json_to_ipfs(metadata)
                    print("file metadata cid: ", metadata_cid)

                    # Create a unique key for the file and update the CID dictionary
                    file_key = f"file_{file_count + 1}"
                    cid_dict[filename] = {file_key: [file_cid, metadata_cid]}
                    print(cid_dict[filename])
                    file_count += 1

        return cid_dict
    except Exception as e:
        logger.error(f"Error processing files in {directory_path}: {e}")
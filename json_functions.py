import json
import os
from ipfs_functions import upload_json_to_ipfs, download_json_from_ipfs, upload_file_to_ipfs

def extract_file_names(data):
    """
    Extract file names from a JSON object or list of objects.
    
    Args:
        data (dict or list): The input JSON data
    
    Returns:
        list: A list of file names
    """
    file_names = []
    for obj in data:
        if isinstance(obj, dict) and 'file_name' in obj:
            file_names.append(obj['file_name'])
    return file_names

def process_objects(data):
    """
    Process a JSON object or list of objects by extracting file names,
    uploading files to IPFS, and uploading JSON objects to IPFS.
    
    Args:
        data (dict or list): The input JSON data
    """
    file_names = extract_file_names(data)
    for obj in data:
        if isinstance(obj, dict):
            print(f"File Name: {file_names[0]}")
            upload_file_to_ipfs("upload/"+file_names[0])
            print()
            print(obj)
            upload_json_to_ipfs(obj)
            # download_json_from_ipfs(obj)




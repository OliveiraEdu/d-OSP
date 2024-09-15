#json_processing.py
import os
import json
from ipfs_functions import *

def process_json_data(data):
    """
    Process JSON data by uploading files and JSON to IPFS.

    Args:
        data (dict or list): JSON data to process

    Returns:
        dict: Dictionary with file CIDs, JSON metadata CIDs.
    """
    result = []
    for obj in data:
        if isinstance(obj, dict) and 'file_name' in obj:
            cid_file = upload_file_to_ipfs("upload/" + obj['file_name'])
            key_json = upload_json_to_ipfs(obj)
            json_cid = f"{obj['file_name']}_json_cid"
            result.append({
                "cid": cid_file,
                "json_cid_value": key_json
            })

    return {
        'file_cids': result,
        'json_cids': {}
    }


def display_json_data(file_path):
    """
    Opens a JSON file, displays its contents as JSON-formatted dictionaries.
    
    Args:
        file_path (str): The path to the JSON file.
        
    Returns:
        None
    """

    try:
        with open(file_path, 'r') as f:
            data = json.load(f)
            
            # Check if data is a list or a dictionary
            if isinstance(data, list):
                print("List of dictionaries:")
                for i, item in enumerate(data, start=1):  
                    if isinstance(item, dict):  
                        print(f"Dictionary {i}:")
                        # print(json.dumps(item, indent=4))  # Display each dictionary as formatted JSON
                        project_metadata = json.dumps(item)
                        print(project_metadata)
                        project_metadata_cid = upload_json_to_ipfs(project_metadata)
                        print(project_metadata_cid)
                        
            elif isinstance(data, dict):
                print("Dictionary:")
                print(json.dumps(data, indent=4))  # Display the single dictionary as formatted JSON
                
    except FileNotFoundError:
        print("File not found.")
        
    except json.JSONDecodeError:
        print("Invalid JSON format.")

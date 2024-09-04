#json_processing.py
import os
import json
from ipfs_functions import *

def process_json_data(data):
    """
    Process JSON data by uploading files and JSON to IPFS.

    Args:
        client (ipfshttpclient): IPFS client connection
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
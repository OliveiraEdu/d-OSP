import os
import json
import logging
import ipfshttpclient
from icecream import ic

# Connect to the IPFS node at a specific IP address
client = ipfshttpclient.connect('/dns/10.0.0.100/tcp/5001/http')  # Replace with your IP address and port

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# client = connect('/dns/10.0.0.100/tcp/5001/http')  # Replace with your IP address and port

def process_json_data(data):
    """
    Process JSON data by uploading files and JSON to IPFS.

    Args:
        client (ipfshttpclient): IPFS client connection
        data (dict or list): JSON data to process

    Returns:
        dict: Dictionary with file CIDs and JSON metadata CIDs.
    """
    file_names = []
    json_cids = {}
    for obj in data:
        if isinstance(obj, dict) and 'file_name' in obj:
            file_names.append(obj['file_name'])

    for i, obj in enumerate(data):
        if isinstance(obj, dict):
            # logger.info(f"Processing object {i+1}")
            cid_file = upload_file_to_ipfs("upload/" + file_names[i])
            key_json = upload_json_to_ipfs(obj)
            json_cids[f"{obj['file_name']}_json_cid"] = key_json
            # logger.info("JSON object:")
            # logger.info(json.dumps(obj, indent=4))

    # Return a dictionary with the file CIDs and JSON metadata CIDs.
    return {"file_cids": {fn: cid for fn, cid in zip(file_names, [cid_file]*len(file_names))},
            "json_cids": json_cids}

def upload_file_to_ipfs(file_path):
    # Add the file to IPFS
    result = client.add(file_path)
    key = result['Hash']
    ic(key)
    return key

def download_file_from_ipfs(cid, output_path):
    # Retrieve the file from IPFS
    file_data = client.cat(cid)
    # Save the file locally
    with open(output_path, 'wb') as f:
        f.write(file_data)

def upload_json_to_ipfs(json):
    # Add the JSON to IPFS
    value = client.add_json(json)
    ic(value)
    return value

def download_json_from_ipfs(json):
    metadata_cid = client.get_json(metadata_cid)
    return metadata_cid

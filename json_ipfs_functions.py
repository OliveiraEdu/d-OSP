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

def upload_file_to_ipfs(file_path):
    # Add the file to IPFS
    result = client.add(file_path)
    key = result['Hash']
    return key

def download_file_from_ipfs(cid, output_path):
    try:
        # Retrieve the file from IPFS
        file_data = client.cat(cid)
        # Save the file locally
        with open(output_path, 'wb') as f:
            f.write(file_data)
        return True  # File downloaded successfully
    except Exception as e:
        logging.error(f"Error downloading file: {e}")
        return False  # File download failed


def download_json_from_ipfs(cid):
    metadata_cid = client.get_json(cid)
    return metadata_cid

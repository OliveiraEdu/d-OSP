# json_ipfs_functions.py

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

# def process_json_data(data):
#     result = {'file_cids': [], 'json_cids': {}}
#     for key, value in data.items():
#         if isinstance(value, dict):  # handle nested dictionaries
#             processed_value = process_json_data(value)
#             result['file_cids'].extend(processed_value['file_cids'])
#             result['json_cids'].update(processed_value['json_cids'])
#         else:
#             result['file_cids'].append({'cid': value, 'json_cid_value': key})
#     return result

# def upload_file_to_ipfs(file_path):
#     # Add the file to IPFS
#     result = client.add(file_path)
#     key = result['Hash']
#     return key

def upload_json_to_ipfs(obj):
    # Convert the object into a JSON string and add it to IPFS
    json_str = json.dumps(obj, indent=4)
    result = client.add_json(json_str.encode('utf-8'))  # Ensure bytes input for encoding
    return result

def download_file_from_ipfs(cid, output_path):
    # Retrieve the file from IPFS
    file_data = client.cat(cid)
    # Save the file locally
    with open(output_path, 'wb') as f:
        f.write(file_data)

def download_json_from_ipfs(cid):
    try:
        metadata_cid = client.get_json(cid)
        return metadata_cid
    except Exception as e:
        logging.error(f"Error retrieving JSON from IPFS: {e}")
        return None
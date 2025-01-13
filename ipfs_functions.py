import ipfshttpclient
import json
from icecream import ic
from loguru import logger


# Load configuration from config.json file
config_path = "config.json"  # Update this path as needed
with open(config_path, "r") as f:
    config = json.load(f)

IPFS_ADDRESS = config["IPFS_ADDRESS"]

# Connect to the IPFS node at a specific IP address and port
ipfs_address = f"/dns/{config['IPFS_ADDRESS']}/tcp/{config['IPFS_PORT']}/http"
client = ipfshttpclient.connect(ipfs_address)

def upload_file_to_ipfs(file_path):

    # Add the file to IPFS
    result = client.add(file_path)
    # ic(result['Name'], result['Hash'])
    value = result['Hash']
    return value

def download_file_from_ipfs(cid, output_path):
    # Retrieve the file from IPFS
    file_data = client.cat(cid)
    # Save the file locally
    with open(output_path, 'wb') as f:
        f.write(file_data)

def upload_json_to_ipfs(json):
    # Add the JSON to IPFS
    file_metadata_CID = client.add_json(json)
    return file_metadata_CID


def download_json_from_ipfs(cid):
    try:
        metadata_cid = client.get_json(cid)
        return metadata_cid
    except Exception as e:
        logger.error(f"Error retrieving JSON from IPFS: {e}")
        return None


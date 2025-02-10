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
    try:
        result = client.add(file_path)
        file_cid = result['Hash']
        logger.success(f"Success uploading file to IPFS. CID: {file_cid}")
        return file_cid
    except Exception as e:
        logger.error(f"Error uploading file to IPFS: {e}")
        return None

def download_file_from_ipfs(cid, output_path):
    try:
        file_data = client.cat(cid)
        with open(output_path, 'wb') as f:
            f.write(file_data)
        logger.success(f"Success downloading file from IPFS. Saved to: {output_path}")
        return output_path
    except Exception as e:
        logger.error(f"Error retrieving file from IPFS: {e}")
        return None

def upload_json_to_ipfs(json_data):
    try:
        metadata_cid = client.add_json(json_data)
        logger.success(f"Success uploading JSON to IPFS. CID: {metadata_cid}")
        return metadata_cid
    except Exception as e:
        logger.error(f"Error uploading JSON to IPFS: {e}")
        return None

    
def download_json_from_ipfs(cid):
    try:
        metadata = client.get_json(cid)
        logger.success(f"Success downloading JSON from IPFS. Metadata: {metadata}")
        return metadata
    except Exception as e:
        logger.error(f"Error retrieving JSON from IPFS: {e}")
        return None


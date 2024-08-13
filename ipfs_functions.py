import ipfshttpclient

# Connect to the IPFS node at a specific IP address
client = ipfshttpclient.connect('/dns/10.0.0.100/tcp/5001/http')  # Replace with your IP address and port

def upload_file_to_ipfs(file_path):
    # Add the file to IPFS
    result = client.add(file_path)
    print (result)
    print(result['Name'], result['Hash'])
    return result['Hash']

def download_file_from_ipfs(cid, output_path):
    # Retrieve the file from IPFS
    file_data = client.cat(cid)
    # Save the file locally
    with open(output_path, 'wb') as f:
        f.write(file_data)

def upload_json_to_ipfs(json):
    # Add the JSON to IPFS
    result = client.add_json(json)
    print ("JSON_metadata_CID : ", result)
    return result

def download_json_from_ipfs(json):
    metadata_cid = client.get_json(metadata_cid)
    return metadata_cid



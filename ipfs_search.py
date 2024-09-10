import ipfshttpclient
import hashlib
import os
import json
from tika import parser
from cuckoo_filter import CuckooFilter
import icecream as ic

# Initialize IPFS client to connect to the local IPFS node running in Docker
# client = ipfshttpclient.connect('/ip4/127.0.0.1/tcp/5001')
client = ipfshttpclient.connect('/dns/10.0.0.1/tcp/5001/http')  # Replace with your IP address and port

# Initialize Cuckoo filter for cache
cache_filter = CuckooFilter(capacity=1000, bucket_size=4)

# Function to extract metadata and keywords using Apache Tika
def extract_metadata(file_path):
    try:
        parsed = parser.from_file(file_path)
        ic(parse)
        metadata = parsed.get('metadata', {})
        ic(metadata)
        content = parsed.get('content', '')
        ic(content)
        
        # Simplified keyword extraction: split content into keywords
        # You might want to use more sophisticated NLP techniques here
        keywords = [word.lower() for word in content.split() if len(word) > 3]  # Filter short wordsss
        ic(keywords)
        
        cid = add_file_to_ipfs(file_path)
        ic(cid)
        if cid:
            return {"CID": cid, "metadata": metadata, "keywords": keywords}
        else:
            return None
    except Exception as e:
        print(f"Error extracting metadata with Tika: {e}")
        return None

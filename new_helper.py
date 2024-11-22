import os
from loguru import logger
from ipfs_functions import *
# import tika
# from tika import parser
import integration_helpers
from super_helper import *

# # Initialize Tika
# tika.initVM()

# Set up a basic configuration for Loguru
logger.add("logs/file_{time}.log", format="{time:MM.DD/YYYY} | {level} | {message}", level="INFO")


# Individual functions
def list_files(directory_path):
    """Return a list of files in the specified directory path."""
    try:
        return [filename for filename in os.listdir(directory_path) if not os.path.basename(filename).startswith('.')]
        logger.info(f"Listing {filename}")
    except Exception as e:
        logger.error(f"Error listing files in {directory_path}: {e}")
        return []

def parse_file_with_tika(file_path):
    """Use Apache Tika to parse the file and extract its metadata."""
    try:
        parsed = parser.from_file(file_path)
        logger.info(f"Parsing {file_path} with Tika...")
        metadata = parsed["metadata"]
        return metadata
    except Exception as e:
        logger.error(f"Error parsing {file_path} with Tika: {e}")
        return None

def index_file_with_woosh(file_path, metadata_cid):
    # Index the file with Woosh using the provided metadata CID
    try:
        pass  # TO DO: implement this function
        logger.info(f"Indexing {file_path} with Woosh...")
    except Exception as e:
        logger.error(f"Error indexing {file_path} with Woosh: {e}")

#Current
# Helper function to orchestrate the entire process
# def process_files(directory_path):
#     """Process files in the specified directory path."""
#     try:
#         for filename in list_files(directory_path):
#             file_path = os.path.join(directory_path, filename)
#             print("file: ", file_path)
#             metadata = parse_file_with_tika(file_path)
#             print("file metadata: ", metadata)
#             if metadata is not None and isinstance(metadata, dict):
#                 file_cid = upload_file_to_ipfs(file_path)
#                 print("file cid: ", file_cid)
#                 if file_cid is not None:
#                     metadata_cid = upload_json_to_ipfs(metadata)
#                     print("file metadata cid: ", metadata_cid)
#                     index_file_with_woosh(file_path, metadata_cid)
#     except Exception as e:
#         logger.error(f"Error processing files in {directory_path}: {e}")

#Option 1
# Helper function to orchestrate the entire process
# def process_files(directory_path):
#     """Process files in the specified directory path."""
#     try:
#         for filename in list_files(directory_path):
#             file_path = os.path.join(directory_path, filename)
#             print("File: ", file_path)
#             metadata = parse_file_with_tika(file_path)
#             print("File metadata: ", metadata)
#             if metadata is not None and isinstance(metadata, dict):
#                 file_cid = upload_file_to_ipfs(file_path)
#                 # print("file cid: ", file_cid)
#                 if file_cid is not None:
#                     metadata_cid = upload_json_to_ipfs(metadata)
#                     # print("file metadata cid: ", metadata_cid)
#                     yield file_cid, metadata_cid
#     except Exception as e:
#         logger.error(f"Error processing files in {directory_path}: {e}")


# Option 2
# Helper function to orchestrate the entire process
# def process_files(directory_path):
#     """Process files in the specified directory path."""
#     try:
#         cid_dict = {}
#         for filename in list_files(directory_path):
#             file_path = os.path.join(directory_path, filename)
#             print("file: ", file_path)
#             metadata = parse_file_with_tika(file_path)
#             print("file metadata: ", metadata)
#             if metadata is not None and isinstance(metadata, dict):
#                 file_cid = upload_file_to_ipfs(file_path)
#                 print("file cid: ", file_cid)
#                 if file_cid is not None:
#                     metadata_cid = upload_json_to_ipfs(metadata)
#                     print("file metadata cid: ", metadata_cid)
#                     cid_dict[filename] = (file_cid, metadata_cid)
#         return cid_dict
#     except Exception as e:
#         logger.error(f"Error processing files in {directory_path}: {e}")

# # Example usage
# if __name__ == "__main__":
#     directory_path = "/path/to/directory"
#     cid_dict = process_files(directory_path)
#     print("CID Dictionary:")
#     for filename, (file_cid, metadata_cid) in cid_dict.items():
#         print(f"File: {filename}, File CID: {file_cid}, Metadata CID: {metadata_cid}")

#Option 3
# def process_files(directory_path):
#     """Process files in the specified directory path."""
#     try:
#         cid_dict = {}
#         for filename in list_files(directory_path):
#             file_path = os.path.join(directory_path, filename)
#             print("file: ", file_path)
#             metadata = parse_file_with_tika(file_path)
#             print("file metadata: ", metadata)
#             if metadata is not None and isinstance(metadata, dict):
#                 file_cid = upload_file_to_ipfs(file_path)
#                 print("file cid: ", file_cid)
#                 if file_cid is not None:
#                     metadata_cid = upload_json_to_ipfs(metadata)
#                     print("file metadata cid: ", metadata_cid)
#                     cid_dict[filename] = (file_cid, metadata_cid)
#         return list(cid_dict.values())
#     except Exception as e:
#         logger.error(f"Error processing files in {directory_path}: {e}")

# def encoder(input_value):
#     """Encode the provided input values using argument encoding."""
#     encoded_value = ''.join(
#         integration_helpers.argument_encoding(v).decode('utf-8') 
#         for v in input_value
#      )
    
#     # Return the string value
#     return encoded_value

#Option 4
# def process_files(directory_path):
#     """Process files in the specified directory path."""
#     try:
#         cid_dict = {}
#         file_count = 0

#         for filename in list_files(directory_path):
#             file_path = os.path.join(directory_path, filename)
#             print("file: ", file_path)

#             metadata = parse_file_with_tika(file_path)
#             print("file metadata: ", metadata)

#             if metadata is not None and isinstance(metadata, dict):
#                 file_cid = upload_file_to_ipfs(file_path)
#                 print("file cid: ", file_cid)

#                 if file_cid is not None:
#                     metadata_cid = upload_json_to_ipfs(metadata)
#                     print("file metadata cid: ", metadata_cid)

#                     # Create a unique key for the file and update the CID dictionary
#                     file_key = f"file_{file_count + 1}"
#                     cid_dict[filename] = {file_key: [file_cid, metadata_cid]}
#                     print(cid_dict[filename])
#                     file_count += 1

#         return cid_dict
#     except Exception as e:
#         logger.error(f"Error processing files in {directory_path}: {e}")

#Option 5
# def process_files(directory_path):
#     """Process files in the specified directory path."""
#     try:
#         cids = []
#         file_count = 0

#         for filename in list_files(directory_path):
#             file_path = os.path.join(directory_path, filename)
#             print("file: ", file_path)

#             metadata = parse_file_with_tika(file_path)
#             print("file metadata: ", metadata)

#             if metadata is not None and isinstance(metadata, dict):
#                 file_cid = upload_file_to_ipfs(file_path)
#                 print("file cid: ", file_cid)

#                 if file_cid is not None:
#                     metadata_cid = upload_json_to_ipfs(metadata)
#                     print("file metadata cid: ", metadata_cid)

#                     # Create a unique key for the file and return its CIDs
#                     file_key = f"file_{file_count + 1}"
#                     cids.append((file_key, file_cid, metadata_cid))
#                     file_count += 1
                    

#         return cids
#     except Exception as e:
#         logger.error(f"Error processing files in {directory_path}: {e}")


#Option 6
# def process_files(directory_path):
#     """Process files in the specified directory path."""
#     try:
#         cids = []
#         file_count = 0

#         for filename in list_files(directory_path):
#             file_path = os.path.join(directory_path, filename)
#             print("file: ", file_path)

#             metadata = parse_file_with_tika(file_path)
#             print("file metadata: ", metadata)

#             if metadata is not None and isinstance(metadata, dict):
#                 file_cid = upload_file_to_ipfs(file_path)
#                 print("file cid: ", file_cid)

#                 if file_cid is not None:
#                     metadata_cid = upload_json_to_ipfs(metadata)
#                     print("file metadata cid: ", metadata_cid)

#                     # Create a unique key for the file and return its CIDs
#                     file_key = f"file_{file_count + 1}"
#                     cids.append((file_key, file_cid, metadata_cid))
#                     file_count += 1

#         return cids
#     except Exception as e:
#         logger.error(f"Error processing files in {directory_path}: {e}")


# def print_cids(cids):
#     for i, cid in enumerate(cids):
#         file_key, file_cid, metadata_cid = cid
#         print(f"File Key: {file_key}")
#         print(f"File CID: {file_cid}")
#         print(f"Metadata CID: {metadata_cid}")
#         print("------------------------")


#Option 7
# def process_files(directory_path):
#     """Process files in the specified directory path."""
#     try:
#         cids = []
#         file_count = 0

#         for filename in list_files(directory_path):
#             file_path = os.path.join(directory_path, filename)
#             print("file: ", file_path)

#             metadata = parse_file_with_tika(file_path)
#             print("file metadata: ", metadata)

#             if metadata is not None and isinstance(metadata, dict):
#                 file_cid = upload_file_to_ipfs(file_path)
#                 print("file cid: ", file_cid)

#                 if file_cid is not None:
#                     metadata_cid = upload_json_to_ipfs(metadata)
#                     print("file metadata cid: ", metadata_cid)

#                     # Create a unique key for the file and return its CIDs
#                     file_key = f"file_{file_count + 1}"
#                     cids.append((file_key, file_cid, metadata_cid))
#                     file_count += 1
                
            
#         return cids
#     except Exception as e:
#         logger.error(f"Error processing files in {directory_path}: {e}")


#Option 9
# def process_files(directory_path, id, DOMAIN):
#     """Process files in the specified directory path."""
#     try:
#         cids = []
#         file_count = 0

#         for filename in list_files(directory_path):
#             file_path = os.path.join(directory_path, filename)
#             # print("file: ", file_path)

#             metadata = parse_file_with_tika(file_path)
#             # print("file metadata: ", metadata)

#             if metadata is not None and isinstance(metadata, dict):
#                 file_cid = upload_file_to_ipfs(file_path)
#                 # print("file cid: ", file_cid)

#                 if file_cid is not None:
#                     metadata_cid = upload_json_to_ipfs(metadata)
#                     print("file metadata cid: ", metadata_cid)

#                     # Create a unique key for the file and return its CIDs
#                     file_key = f"file_{file_count + 1}"
#                     cids.append((file_key, file_cid, metadata_cid))
#                     file_count += 1

#                     # Assign cid_str here, so it gets updated for each file
#                     cid_str = (file_key, file_cid, metadata_cid)

#                     # Join file_cid and metadata_cid with a comma
#                     joined_cids = f"{file_cid}, {metadata_cid}"

#                     hash = create_contract()
#                     address = integration_helpers.get_engine_receipts_address(hash)

#                     hash = set_account_detail(
#                         address, 
#                         f"{id}@{DOMAIN}",  # Project ID as account
#                         f"{file_key}",    # The key we're setting
#                         joined_cids      # The value (CID from IPFS)
#                     )

#         return cids, cid_str, joined_cids if len(cids) > 0 else None
#     except Exception as e:
#         logger.error(f"Error processing files in {directory_path}: {e}")


#Option 10
def process_files(directory_path, project_id):
    """Process files in the specified directory path."""
    try:
        cids = []
        file_count = 0

        # Initialize address to None (will be set later)
        address = None

        for filename in list_files(directory_path):
            file_path = os.path.join(directory_path, filename)
            print("file: ", file_path)

            # metadata = parse_file_with_tika(file_path)
            # print("file metadata: ", metadata)

            metadata = extract_and_normalize_metadata(file_path)

            print(metadata)

            index_metadata(metadata)

            if metadata is not None and isinstance(metadata, dict):
                file_cid = upload_file_to_ipfs(file_path)
                print("file cid: ", file_cid)

                if file_cid is not None:
                    metadata_cid = upload_json_to_ipfs(metadata)
                    print("file metadata cid: ", metadata_cid)

                    # Create a unique key for the file and return its CIDs
                    file_key = f"file_{file_count + 1}"
                    cids.append((file_key, file_cid, metadata_cid))
                    file_count += 1

                    # Assign cid_str here, so it gets updated for each file
                    cid_str = (file_key, file_cid, metadata_cid)

                    # Join file_cid and metadata_cid with a comma
                    joined_cids = f"{file_cid}, {metadata_cid}"

                    if address is None:
                        hash = create_contract()
                        address = integration_helpers.get_engine_receipts_address(hash)

                    hash = set_account_detail(
                        address, 
                        project_id,  # Project ID as account
                        f"{file_key}",    # The key we're setting
                        joined_cids      # The value (CID from IPFS)
                    )

        return cids, cid_str, joined_cids if len(cids) > 0 else None
    except Exception as e:
        logger.error(f"Error processing files in {directory_path}: {e}")

def print_cids(cids):
    for i, cid in enumerate(cids):
        file_key, file_cid, metadata_cid = cid
        print(f"File Key: {file_key}")
        # cids_str = f"({'{0}'.format(file_cid)},{'{0}'.format(metadata_cid)})".format(file_cid, metadata_cid)
        cids_str = f"{file_cid}, {metadata_cid}"
        print(f"CIDs: {cids_str}")
        print("------------------------")



#Iroha functions


import os
import binascii
from iroha import IrohaCrypto
from iroha import Iroha, IrohaGrpc
import sys
from Crypto.Hash import keccak
import json

if sys.version_info[0] < 3:
    raise Exception("Python 3 or a more recent version is required.")

# Load configuration from config.json file
config_path = "config.json"  # Update this path as needed
with open(config_path, "r") as f:
    config = json.load(f)

IROHA_HOST_ADDR = config["IROHA_HOST_ADDR"]
IROHA_PORT = config["IROHA_PORT"]
ADMIN_ACCOUNT_ID = config["ADMIN_ACCOUNT_ID"]
ADMIN_PRIVATE_KEY = config["ADMIN_PRIVATE_KEY"]
iroha = Iroha(ADMIN_ACCOUNT_ID)
net = IrohaGrpc("{}:{}".format(IROHA_HOST_ADDR, IROHA_PORT))
iroha = Iroha(ADMIN_ACCOUNT_ID)
net = IrohaGrpc("{}:{}".format(IROHA_HOST_ADDR, IROHA_PORT))


def trace(func):
    """
    A decorator for tracing methods' begin/end execution points
    """

    def tracer(*args, **kwargs):
        name = func.__name__
        print('\tEntering "{}"'.format(name))
        result = func(*args, **kwargs)
        print('\tLeaving "{}"'.format(name))
        return result

    return tracer

#Deploys account detail setting contract
@trace
def create_contract():
    bytecode = "608060405234801561001057600080fd5b5073a6abc17819738299b3b2c1ce46d55c74f04e290c6000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550610b4c806100746000396000f3fe608060405234801561001057600080fd5b506004361061004c5760003560e01c80635bdb3a41146100515780637949a1b31461006f578063b7d66df71461009f578063d4e804ab146100cf575b600080fd5b6100596100ed565b6040516100669190610879565b60405180910390f35b61008960048036038101906100849190610627565b61024c565b6040516100969190610879565b60405180910390f35b6100b960048036038101906100b49190610693565b6103bb565b6040516100c69190610879565b60405180910390f35b6100d761059b565b6040516100e4919061085e565b60405180910390f35b606060006040516024016040516020818303038152906040527f5bdb3a41000000000000000000000000000000000000000000000000000000007bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19166020820180517bffffffffffffffffffffffffffffffffffffffffffffffffffffffff8381831617835250505050905060008060008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16836040516101be9190610830565b600060405180830381855af49150503d80600081146101f9576040519150601f19603f3d011682016040523d82523d6000602084013e6101fe565b606091505b509150915081610243576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161023a9061091e565b60405180910390fd5b80935050505090565b60606000838360405160240161026392919061089b565b6040516020818303038152906040527f7949a1b3000000000000000000000000000000000000000000000000000000007bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19166020820180517bffffffffffffffffffffffffffffffffffffffffffffffffffffffff8381831617835250505050905060008060008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168360405161032a9190610830565b600060405180830381855af49150503d8060008114610365576040519150601f19603f3d011682016040523d82523d6000602084013e61036a565b606091505b5091509150816103af576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016103a69061091e565b60405180910390fd5b80935050505092915050565b606060008484846040516024016103d4939291906108d2565b6040516020818303038152906040527fb7d66df7000000000000000000000000000000000000000000000000000000007bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19166020820180517bffffffffffffffffffffffffffffffffffffffffffffffffffffffff8381831617835250505050905060008060008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168360405161049b9190610830565b600060405180830381855af49150503d80600081146104d6576040519150601f19603f3d011682016040523d82523d6000602084013e6104db565b606091505b509150915081610520576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016105179061091e565b60405180910390fd5b8460405161052e9190610847565b6040518091039020866040516105449190610847565b60405180910390208860405161055a9190610847565b60405180910390207f5e1b38cd47cf21b75d5051af29fa321eedd94877db5ac62067a076770eddc9d060405160405180910390a48093505050509392505050565b60008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b60006105d26105cd84610963565b61093e565b9050828152602081018484840111156105ea57600080fd5b6105f5848285610a14565b509392505050565b600082601f83011261060e57600080fd5b813561061e8482602086016105bf565b91505092915050565b6000806040838503121561063a57600080fd5b600083013567ffffffffffffffff81111561065457600080fd5b610660858286016105fd565b925050602083013567ffffffffffffffff81111561067d57600080fd5b610689858286016105fd565b9150509250929050565b6000806000606084860312156106a857600080fd5b600084013567ffffffffffffffff8111156106c257600080fd5b6106ce868287016105fd565b935050602084013567ffffffffffffffff8111156106eb57600080fd5b6106f7868287016105fd565b925050604084013567ffffffffffffffff81111561071457600080fd5b610720868287016105fd565b9150509250925092565b610733816109e2565b82525050565b600061074482610994565b61074e81856109aa565b935061075e818560208601610a23565b61076781610ab6565b840191505092915050565b600061077d82610994565b61078781856109bb565b9350610797818560208601610a23565b80840191505092915050565b60006107ae8261099f565b6107b881856109c6565b93506107c8818560208601610a23565b6107d181610ab6565b840191505092915050565b60006107e78261099f565b6107f181856109d7565b9350610801818560208601610a23565b80840191505092915050565b600061081a6027836109c6565b915061082582610ac7565b604082019050919050565b600061083c8284610772565b915081905092915050565b600061085382846107dc565b915081905092915050565b6000602082019050610873600083018461072a565b92915050565b600060208201905081810360008301526108938184610739565b905092915050565b600060408201905081810360008301526108b581856107a3565b905081810360208301526108c981846107a3565b90509392505050565b600060608201905081810360008301526108ec81866107a3565b9050818103602083015261090081856107a3565b9050818103604083015261091481846107a3565b9050949350505050565b600060208201905081810360008301526109378161080d565b9050919050565b6000610948610959565b90506109548282610a56565b919050565b6000604051905090565b600067ffffffffffffffff82111561097e5761097d610a87565b5b61098782610ab6565b9050602081019050919050565b600081519050919050565b600081519050919050565b600082825260208201905092915050565b600081905092915050565b600082825260208201905092915050565b600081905092915050565b60006109ed826109f4565b9050919050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b82818337600083830152505050565b60005b83811015610a41578082015181840152602081019050610a26565b83811115610a50576000848401525b50505050565b610a5f82610ab6565b810181811067ffffffffffffffff82111715610a7e57610a7d610a87565b5b80604052505050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b6000601f19601f8301169050919050565b7f4572726f722063616c6c696e67207365727669636520636f6e7472616374206660008201527f756e6374696f6e0000000000000000000000000000000000000000000000000060208201525056fea26469706673582212206ad40afbd4cc9c87ae154542d003c9538e4b89473a13cadd3cbf618ea181206864736f6c63430008040033"
    """Bytecode was generated using remix editor  https://remix.ethereum.org/ from file detail.sol. """
    tx = iroha.transaction(
        [iroha.command("CallEngine", caller=ADMIN_ACCOUNT_ID, input=bytecode)]
    )
    IrohaCrypto.sign_transaction(tx, ADMIN_PRIVATE_KEY)
    net.send_tx(tx)
    hex_hash = binascii.hexlify(IrohaCrypto.hash(tx))
    for status in net.tx_status_stream(tx):
        print(status)
    return hex_hash

# Helper function to simulate setting account details with Iroha
@trace
def set_account_detail(address, account, key, value):
    # Generate the params for the "setAccountDetail" function
    params = integration_helpers.get_first_four_bytes_of_keccak(
        b"setAccountDetail(string,string,string)"
    )
    no_of_param = 3
    for x in range(no_of_param):
        params = params + integration_helpers.left_padded_address_of_param(
            x, no_of_param
        )
    params = params + integration_helpers.argument_encoding(account)  # source account id
    params = params + integration_helpers.argument_encoding(key)  # key
    params = params + integration_helpers.argument_encoding(value)  # value

    # Create a transaction to call the engine
    tx = iroha.transaction(
        [
            iroha.command(
                "CallEngine", caller=ADMIN_ACCOUNT_ID, callee=address, input=params
            )
        ]
    )
    
    # Sign and send the transaction
    IrohaCrypto.sign_transaction(tx, ADMIN_PRIVATE_KEY)
    response = net.send_tx(tx)

    # Log the response and statuses
    print(response)
    for status in net.tx_status_stream(tx):
        print(status)
    
    # Get the transaction hash in hex form
    hex_hash = binascii.hexlify(IrohaCrypto.hash(tx))
    return hex_hash
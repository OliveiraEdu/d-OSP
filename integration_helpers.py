from iroha import IrohaCrypto
from iroha import Iroha, IrohaGrpc
import sys
from Crypto.Hash import keccak
import json
from loguru import logger



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
        logger.debug('\tEntering "{}"'.format(name))
        result = func(*args, **kwargs)
        logger.debug('\tLeaving "{}"'.format(name))
        return result

    return tracer


def make_number_hex_left_padded(number: str, width: int = 64):
    number_hex = "{:x}".format(number)
    return str(number_hex).zfill(width)


def left_padded_address_of_param(
    param_index: int, number_of_params: int, width: int = 64
):
    """Specifies the position of each argument according to Contract ABI specifications."""
    bits_offset = 32 * number_of_params
    bits_per_param = 64
    bits_for_the_param = bits_offset + bits_per_param * param_index
    return make_number_hex_left_padded(bits_for_the_param, width)


def argument_encoding(arg):
    """Encodes the argument according to Contract ABI specifications."""
    encoded_argument = str(hex(len(arg)))[2:].zfill(64)
    encoded_argument = (
        encoded_argument + arg.encode("utf8").hex().ljust(64, "0").upper()
    )
    return encoded_argument


def get_first_four_bytes_of_keccak(function_signature: str):
    """Generates the first 4 bytes of the keccak256 hash of the function signature. """
    k = keccak.new(digest_bits=256)
    k.update(function_signature)
    return k.hexdigest()[:8]

@trace
def get_engine_receipts_address(tx_hash: str):
    """
    Retrieves and logs the contract address associated with a given transaction hash.

    Args:
        tx_hash (str): The hex-encoded hash of a transaction on the Iroha blockchain.
    """

    # Construct the query to retrieve engine receipts
    query = iroha.query("GetEngineReceipts", tx_hash=tx_hash)

    try:
        # Sign the query with the admin private key
        IrohaCrypto.sign_query(query, ADMIN_PRIVATE_KEY)

        # Send the signed query to the network and get the response
        response = net.send_query(query)
        
        # Extract the contract address from the first engine receipt in the response
        contract_add = response.engine_receipts_response.engine_receipts[0].contract_address

        # Log the transaction hash, success message, and contract address
        logger.info(f"Retrieved contract address for transaction hash: {tx_hash}")
        logger.debug(f"Contract address: {contract_add}")

    except iroha.error.IrohaError as e:
        # Log any Iroha errors that occur during execution
        logger.error(f"Iroha error occurred: {e}")
    except Exception as e:
        # Log any other exceptions that occur during execution
        logger.error(f"An unexpected error occurred: {e}")

    return contract_add



@trace
def get_engine_receipts_result(tx_hash: str):
    """
    Retrieves and logs the result of a GetEngineReceipts query on the Iroha blockchain.
    
    Args:
        tx_hash (str): The hash of the transaction for which the receipt is requested.
    """
    # Create the query to retrieve engine receipts
    query = iroha.query("GetEngineReceipts", tx_hash=tx_hash)
    
    # Sign the query with the admin private key
    IrohaCrypto.sign_query(query, ADMIN_PRIVATE_KEY)
    
    try:
        # Send the query and get the response
        response = net.send_query(query)
        
        # Extract the result from the response
        call_result = response.engine_receipts_response.engine_receipts[0].call_result
        result_data_hex = call_result.result_data
        
        # Convert the hex string to a byte array
        bytes_object = bytes.fromhex(result_data_hex)
        
        # Decode the byte array to an ASCII string, ignoring any non-ASCII characters
        ascii_string = bytes_object.decode('ASCII', 'ignore')
        
        # Log the result
        logger.info(f"Result data: {result_data_hex}")
        logger.debug(f"Result decoded string: {ascii_string}")
        return ascii_string
    except Exception as e:
        # Log any errors that occur during execution
        logger.error(f"An error occurred: {e}")


@trace
def get_blocks():
    """
    Subscribe to blocks stream from the network
    :return:
    """
    query = iroha.blocks_query()
    IrohaCrypto.sign_query(query, ADMIN_PRIVATE_KEY)
    for block in net.send_blocks_stream_query(query):
        logger.info('The next block arrived:', block)
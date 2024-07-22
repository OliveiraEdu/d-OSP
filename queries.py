import os
import sys
import binascii
from grpc import RpcError, StatusCode
import inspect
from iroha import Iroha, IrohaGrpc, IrohaCrypto
from iroha.primitive_pb2 import can_call_engine
from functools import wraps

IROHA_HOST_ADDR = os.getenv('IROHA_HOST_ADDR', '10.0.0.100')
IROHA_PORT = os.getenv('IROHA_PORT', '50051')
ADMIN_ACCOUNT_ID = os.getenv('ADMIN_ACCOUNT_ID', 'admin@test')
ADMIN_PRIVATE_KEY = os.getenv('ADMIN_PRIVATE_KEY', 'f101537e319568c765b2cc89698325604991dca57b9716b58016b253506cab70')

iroha = Iroha(ADMIN_ACCOUNT_ID)
net = IrohaGrpc(f'{IROHA_HOST_ADDR}:{IROHA_PORT}')

def trace(func):
    @wraps(func)
    def tracer(*args, **kwargs):
        name = func.__name__
        stack_size = int(len(inspect.stack(0)) / 2)
        indent = stack_size * '\t'
        print(f'{indent} > Entering "{name}": args: {args}')
        result = func(*args, **kwargs)
        print(f'{indent} < Leaving "{name}"')
        return result
    return tracer

@trace
def send_transaction_and_print_status(transaction):
    hex_hash = binascii.hexlify(IrohaCrypto.hash(transaction))
    creator_id = transaction.payload.reduced_payload.creator_account_id
    commands = get_commands_from_tx(transaction)
    print(f'Transaction "{commands}", hash = {hex_hash}, creator = {creator_id}')
    net.send_tx(transaction)
    handle_transaction_errors(transaction)

def handle_transaction_errors(transaction):
    for i, status in enumerate(net.tx_status_stream(transaction)):
        status_name, status_code, error_code = status
        print(f"{i}: status_name={status_name}, status_code={status_code}, error_code={error_code}")
        if status_name in ('STATEFUL_VALIDATION_FAILED', 'STATELESS_VALIDATION_FAILED', 'REJECTED'):
            handle_error(status_name, error_code, transaction)

def handle_error(status_name, error_code, transaction):
    error_messages = {
        'STATEFUL_VALIDATION_FAILED': 'Stateful validation failed',
        'STATELESS_VALIDATION_FAILED': 'Stateless validation failed',
        'REJECTED': 'Transaction rejected'
    }
    error_message = error_messages.get(status_name, 'Unknown error') + f': {error_code}'
    raise RuntimeError(f"{status_name} failed on tx: {transaction} due to reason {error_code}: {error_message}")

def get_commands_from_tx(transaction):
    commands_from_tx = []
    for command in transaction.payload.reduced_payload.__getattribute__("commands"):
        listed_fields = command.ListFields()
        commands_from_tx.append(listed_fields[0][0].name)
    return commands_from_tx


# #Query - GetAccountTransactions
# query = iroha.query('GetAccountTransactions', account_id=ADMIN_ACCOUNT_ID, page_size=3)
# IrohaCrypto.sign_query(query, ADMIN_PRIVATE_KEY)
# response = net.send_query(query)
# data = response
# print(data)

# #Query - GetRoles
# query = iroha.query('GetRoles')
# IrohaCrypto.sign_query(query, ADMIN_PRIVATE_KEY)
# response = net.send_query(query)
# data = response
# print(data)

# #Query - GetRolePermissions
# ROLE_ID="admin"
# query = iroha.query('GetRolePermissions',role_id=ROLE_ID)
# IrohaCrypto.sign_query(query, ADMIN_PRIVATE_KEY)
# response = net.send_query(query)
# data = response
# print(ROLE_ID, data)

# #Query - GetRolePermissions
# ROLE_ID="user"
# query = iroha.query('GetRolePermissions',role_id=ROLE_ID)
# IrohaCrypto.sign_query(query, ADMIN_PRIVATE_KEY)
# response = net.send_query(query)
# data = response
# print(ROLE_ID, data)

# #Query - GetRolePermissions
# ROLE_ID="money_creator"
# query = iroha.query('GetRolePermissions',role_id=ROLE_ID)
# IrohaCrypto.sign_query(query, ADMIN_PRIVATE_KEY)
# response = net.send_query(query)
# data = response
# print(ROLE_ID, data)

# #Query - GetRolePermissions
# ROLE_ID="first_role"
# query = iroha.query('GetRolePermissions',role_id=ROLE_ID)
# IrohaCrypto.sign_query(query, ADMIN_PRIVATE_KEY)
# response = net.send_query(query)
# data = response
# print(ROLE_ID, data)


# #Query - GetAccountDetail
user = 'admin@test'
query = iroha.query('GetAccountDetail',account_id=user)
IrohaCrypto.sign_query(query, ADMIN_PRIVATE_KEY)
response = net.send_query(query)
data = response.account_detail_response
print(f'Account id = {user}, details = {data.detail}')

#Query - GetAccountDetail
user = 'ecstatic_dubinsky@test'
query = iroha.query('GetAccountDetail',account_id=user)
IrohaCrypto.sign_query(query, ADMIN_PRIVATE_KEY)
response = net.send_query(query)
data = response.account_detail_response
print(f'Account id = {user}, details = {data.detail}')

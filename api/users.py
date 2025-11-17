from flask import Blueprint, request, jsonify
# from iroha_helper import *


DOMAIN = "test"

users_bp = Blueprint('users', __name__, url_prefix='/users')

@users_bp.route('/', methods=['GET'])
def list_users():
    users = user_service.get_all_users()
    return jsonify(users)

@users_bp.route('/<int:user_id>', methods=['GET'])
def get_user(user_id):
    get_account_hash = get_account(create_account_contract_address, user_account_short_id, DOMAIN)
    address = integration_helpers.get_engine_receipts_result(get_account_hash)
    if user:
        return jsonify(user)
    else:
        return jsonify({'message': 'User not found'}), 404

# ... other user related endpoints
from flask import Flask, request, jsonify
from flask_cors import CORS
import logging
# import random
# Assuming you have these imports and functions defined elsewhere
# from your_iroha_crypto_module import IrohaCrypto
# from your_helpers_module import print_random_from_second_column, generate_orcid, set_random_role
# from your_account_class import UserAccount
# from your_blockchain_interaction_module import create_user_account
# from your_constants import DOMAIN, create_account_contract_hash

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')


# # Dummy implementations for demonstration purposes.  Replace with your actual code.
# def IrohaCrypto_private_key():
#     return "dummy_private_key"

# def IrohaCrypto_derive_public_key(private_key):
#     return "dummy_public_key"

# def print_random_from_second_column(filename):
#     return "Random University"

# def generate_orcid():
#     return "0000-0000-0000-0000"

# def set_random_role():
#     roles = ["admin", "user", "editor"]
#     return random.choice(roles)

class UserAccount:
    def __init__(self, account_id, full_name, email, institution, orcid, role, public_key):
        self.account_id = account_id
        self.full_name = full_name
        self.email = email
        self.institution = institution
        self.orcid = orcid
        self.role = role
        self.public_key = public_key


def create_user_account(contract_address, short_id, domain, public_key, user_account):
    # Replace with your actual blockchain interaction code
    logging.info(f"Simulating account creation for {short_id} on blockchain")
    return {"status": "success", "message": f"Account {short_id} created on blockchain"}



app = Flask(__name__)
CORS(app)  # Enable CORS for all routes.  Consider tightening this up in production

@app.route('/create_user_account', methods=['POST'])
def create_account_api():
    """
    API endpoint to create a new user account.
    """
    try:
        # Generate the user account details
        user_private_key = IrohaCrypto_private_key()
        user_public_key = IrohaCrypto_derive_public_key(user_private_key).decode("utf-8")

        left = ["Alice", "Bob", "Charlie"] #example data
        right = ["Smith", "Jones", "Williams"]
        user_account_left = random.choice(left)
        user_account_right = random.choice(right)
        user_account_short_id = f"{user_account_left}_{user_account_right}"
        user_account_full_name = ((f"{user_account_left}").capitalize())+" "+((f"{user_account_right}").capitalize())
        user_account_email = f"{user_account_left}_{user_account_right}"+"@email.com"
        user_account_institution = print_random_from_second_column("datasets/world-universities.csv")
        user_account_orcid = generate_orcid()
        user_role = set_random_role()
        logger.info(f"User Role: {user_role}")
        user_account = UserAccount(
            account_id=f"{user_account_short_id}@{DOMAIN}",
            full_name=user_account_full_name,
            email=user_account_email,
            institution=user_account_institution,
            orcid=user_account_orcid,
            role=user_role,
            public_key=user_public_key,
        )
        logger.info(f"Creating account with name: {user_account_short_id}")

        # Call the blockchain interaction function
        create_account_contract_address = integration_helpers.get_engine_receipts_address(create_account_contract_hash)
        result = create_user_account(create_account_contract_address, user_account_short_id, DOMAIN, user_public_key, user_account)

        return jsonify({"status": "success", "message": result["message"]}), 201  # 201 Created status code
    except Exception as e:
        logging.error(f"Error creating user account: {e}")
        return jsonify({"status": "error", "message": str(e)}), 500  # 500 Internal Server Error



if __name__ == '__main__':
    # Replace with actual values
    DOMAIN = "example.com"
    create_account_contract_hash = "0x1234567890"

    # This line is crucial.  Don't run in production without proper security!
    app.run(debug=True)
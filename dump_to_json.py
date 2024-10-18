import json
import os

# Helper function to convert bytes to hex string
def bytes_to_hex_string(byte_value):
    if isinstance(byte_value, bytes):
        return byte_value.hex()
    return byte_value

def dump_to_json_ld(account_id, user_account_full_name, user_account_email, user_account_institution, user_account_orcid, user_role, user_public_key, filename="datasets/accounts.json"):
    
    try:
        # Ensure that the 'datasets' directory exists
        directory = os.path.dirname(filename)
        if directory and not os.path.exists(directory):
            os.makedirs(directory)  # Create directory if it does not exist

        # Check if the file exists and read existing data
        if os.path.exists(filename):
            with open(filename, mode='r', encoding='utf-8') as file:
                data = json.load(file)
        else:
            # If the file doesn't exist, initialize with a JSON-LD context
            data = {
                "@context": {
                    "schema": "http://schema.org/",
                    "foaf": "http://xmlns.com/foaf/0.1/"
                },
                "@graph": []  # Empty graph to store user entries
            }

        # Create a new user account entry
        new_entry = {
            "@type": "foaf:Person",
            "foaf:name": user_account_full_name,
            "foaf:mbox": user_account_email,
            "foaf:organization": {
                "@type": "foaf:Organization",
                "foaf:name": user_account_institution
            },
            "schema:identifier": {
                "@type": "PropertyValue",
                "propertyID": "ORCID",
                "value": user_account_orcid
            },
            "foaf:holdsAccount": {
                "schema:identifier": account_id,
                "schema:roleName": user_role,
                "schema:publicKey": user_public_key
                # Removed private key for now
            }
        }

        # Append new entry to the graph
        data["@graph"].append(new_entry)

        # Write back to the file
        with open(filename, mode='w', encoding='utf-8') as file:
            json.dump(data, file, indent=4)

        current_entry_number = len(data["@graph"])
        print(f"Appended new entry to file '{filename}', current total entries: {current_entry_number}")
        return current_entry_number

    except Exception as e:
        print(f"Error appending entry to JSON-LD: {str(e)}")
        return None  # Return None on error





def dump_project_to_json_ld(project_id, project_private_key, project_public_key, project_filename="datasets/projects.jsonld"):
    try:
        # Check if the file exists and read existing data
        if os.path.exists(project_filename):
            with open(project_filename, mode='r', encoding='utf-8') as file:
                data = json.load(file)
        else:
            data = {
                "@context": {
                    "schema": "http://schema.org/",
                    "dc": "http://purl.org/dc/terms/"
                },
                "@graph": []
            }  # Initialize as a JSON-LD structure with @context

        # Create a new project entry in JSON-LD format
        new_entry = {
            "@type": "schema:ResearchProject",
            "schema:identifier": project_id,
            "schema:privateKey": project_private_key,
            "schema:publicKey": project_public_key
        }

        # Append new entry to the @graph array
        data["@graph"].append(new_entry)

        # Write back to the JSON-LD file
        with open(project_filename, mode='w', encoding='utf-8') as file:
            json.dump(data, file, indent=4)

        current_entry_number = len(data["@graph"])
        print(f"Appended new entry to file '{project_filename}', current total entries: {current_entry_number}")
        return current_entry_number

    except Exception as e:
        print(f"Error appending entry to JSON-LD: {str(e)}")
        return None  # Return None on error

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



def dump_project_to_json_ld(project_id, project_public_key, project_filename="datasets/projects.json"):
    try:
        # Ensure that the 'datasets' directory exists
        directory = os.path.dirname(project_filename)
        if directory and not os.path.exists(directory):
            os.makedirs(directory)  # Create directory if it doesn't exist

        # Check if the file exists and read existing data
        if os.path.exists(project_filename):
            with open(project_filename, mode='r', encoding='utf-8') as file:
                data = json.load(file)
        else:
            # If the file doesn't exist, initialize with a JSON-LD context
            data = {
                "@context": {
                    "schema": "http://schema.org/",
                    "dc": "http://purl.org/dc/terms/"
                },
                "@graph": []  # Empty graph to store project entries
            }

        # Create a new project entry in JSON-LD format
        new_entry = {
            "@type": "schema:ResearchProject",
            "schema:identifier": project_id,
            "schema:publicKey": project_public_key  # Assuming publicKey is passed as a string
        }

        # Append new entry to the graph
        data["@graph"].append(new_entry)

        # Write back to the JSON-LD file
        with open(project_filename, mode='w', encoding='utf-8') as file:
            json.dump(data, file, indent=4)

        current_entry_number = len(data["@graph"])
        print(f"Appended new project entry to file '{project_filename}', current total entries: {current_entry_number}")
        return current_entry_number

    except Exception as e:
        print(f"Error appending entry to JSON-LD: {str(e)}")
        return None  # Return None on error




def append_project_metadata_to_json_ld(project_id, project_metadata_json, project_metadata_cid, project_filename="datasets/projects.json"):
    try:
        # Ensure that the 'datasets' directory exists
        directory = os.path.dirname(project_filename)
        if directory and not os.path.exists(directory):
            os.makedirs(directory)  # Create directory if it doesn't exist

        # Check if the file exists and read existing data
        if os.path.exists(project_filename):
            with open(project_filename, mode='r', encoding='utf-8') as file:
                data = json.load(file)
        else:
            print(f"File '{project_filename}' does not exist. No metadata appended.")
            return None

        # Find the project entry by project_id
        project_found = False
        for entry in data["@graph"]:
            if entry.get("schema:identifier") == project_id+'@test':
                # Append new fields for project_metadata_json and project_metadata_cid
                entry["schema:description"] = project_metadata_json  # Assuming this is the correct representation
                entry["schema:metadataCID"] = project_metadata_cid  # Using a new key for the CID
                project_found = True
                break

        if not project_found:
            print(f"Project with ID '{project_id}' not found in '{project_filename}'.")
            return None

        # Write back to the JSON-LD file
        with open(project_filename, mode='w', encoding='utf-8') as file:
            json.dump(data, file, indent=4)

        print(f"Appended metadata for project ID '{project_id}' to '{project_filename}'.")
        return True

    except Exception as e:
        print(f"Error appending entry to JSON-LD: {str(e)}")
        return None  # Return None on error


import json
import os

def update_or_append_project_metadata(project_id_base, project_metadata_json, project_metadata_cid, domain="test", project_filename="datasets/projects.json"):
    # Create the dynamic project_id
    project_id = f"{project_id_base}@{domain}"  # Format: project_id@test

    try:
        # Ensure that the 'datasets' directory exists
        directory = os.path.dirname(project_filename)
        if directory and not os.path.exists(directory):
            os.makedirs(directory)  # Create directory if it doesn't exist

        # Check if the file exists and read existing data
        if os.path.exists(project_filename):
            with open(project_filename, mode='r', encoding='utf-8') as file:
                data = json.load(file)
        else:
            # If the file doesn't exist, initialize with a JSON-LD context
            data = {
                "@context": {
                    "schema": "http://schema.org/",
                    "dc": "http://purl.org/dc/terms/"
                },
                "@graph": []  # Empty graph to store project entries
            }

        # Flag to check if project entry was found
        project_found = False
        
        # Look for the existing project entry by identifier
        for entry in data["@graph"]:
            if entry.get("schema:identifier") == project_id:
                # Update the existing project entry
                entry["schema:description"] = project_metadata_json
                entry["schema:metadataCID"] = project_metadata_cid
                project_found = True
                print(f"Updated existing project entry for project ID: {project_id}")
                break

        # If project entry was not found, create a new one
        if not project_found:
            new_entry = {
                "@type": "schema:ResearchProject",
                "schema:identifier": project_id,
                "schema:description": project_metadata_json,
                "schema:metadataCID": project_metadata_cid
            }
            data["@graph"].append(new_entry)
            print(f"Appended new project entry for project ID: {project_id}")

        # Write back to the JSON-LD file
        with open(project_filename, mode='w', encoding='utf-8') as file:
            json.dump(data, file, indent=4)

        current_entry_number = len(data["@graph"])
        print(f"Current total entries in '{project_filename}': {current_entry_number}")
        return current_entry_number

    except Exception as e:
        print(f"Error updating or appending entry in JSON-LD: {str(e)}")
        return None  # Return None on error


def update_project_entry_with_file_data(project_id, file_cid, metadata_cid, metadata):
    # Extract the account_id if the project_id is a dictionary
    if isinstance(project_id, dict):
        project_id = project_id.get('account_id', '').strip()  # Ensure project_id is correctly extracted as a string
    
    # Path to your projects.json file
    file_path = 'datasets/projects.json'

    # Open the JSON file
    try:
        with open(file_path, 'r') as file:
            project_data = json.load(file)
            print(f"Loaded project data successfully.")
    except FileNotFoundError:
        print(f"File {file_path} not found.")
        return
    except json.JSONDecodeError as e:
        print(f"Error decoding JSON: {e}")
        return

    # Print project data structure for better understanding
    print(f"Current project_data: {json.dumps(project_data, indent=4)}")

    # Search for the project in the @graph
    project_found = False
    for project in project_data.get('@graph', []):
        current_id = project.get('schema:identifier')
        print(f"Checking project with ID: '{current_id}' against '{project_id}'")  # Ensure no hidden spaces or format differences

        # Compare the current project's identifier with the target project_id
        if current_id.strip() == project_id.strip():  # Using .strip() to eliminate any trailing/leading whitespace issues
            project_found = True
            print(f"Match found for project ID: {project_id}")
            
            # Prepare new file entry data to be added
            # Retrieve the current file count (or set it to 0 if this is the first file)
            file_count = len(project.get('schema:files', [])) + 1  # Incremental file index
            
            file_entry = {
                "file_index": file_count,  # Automatically incremented file index
                "file_cid": file_cid,  # File CID from IPFS
                "metadata_cid": metadata_cid,  # Metadata CID from IPFS
                "metadata": metadata  # Actual extracted metadata content
            }

            # Check if "schema:files" key exists, if not, create it
            if 'schema:files' not in project:
                project['schema:files'] = []

            # Append the file entry to the project
            project['schema:files'].append(file_entry)

            print(f"Updated project {project_id} with new file entry: {file_entry}")
            break

    if not project_found:
        print(f"Project {project_id} not found in datasets/projects.json")
        return

    # Write the updated data back to the JSON file
    try:
        with open(file_path, 'w') as file:
            json.dump(project_data, file, indent=4)
            print(f"Successfully wrote updated data to {file_path}")
    except Exception as e:
        print(f"Error writing to file {file_path}: {e}")

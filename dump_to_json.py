import json
import os

def dump_to_json(account_id, user_account_full_name, user_account_email, user_account_institution, user_account_orcid, user_private_key, user_public_key, filename="datasets/accounts.json"):
    try:
        # Check if the file exists and read existing data
        if os.path.exists(filename):
            with open(filename, mode='r', encoding='utf-8') as file:
                data = json.load(file)
        else:
            data = []  # Start with an empty list if file doesn't exist

        # Create a new account entry
        new_entry = {
            "account_id": account_id,
            "user_account_full_name": user_account_full_name,
            "user_account_email": user_account_email,
            "user_account_institution": user_account_institution,
            "user_account_orcid": user_account_orcid,
            "user_private_key": user_private_key,
            "user_public_key": user_public_key
        }

        # Append new entry to the list
        data.append(new_entry)

        # Write back to the file
        with open(filename, mode='w', encoding='utf-8') as file:
            json.dump(data, file, indent=4)

        current_entry_number = len(data)
        print(f"Appended new entry to file '{filename}', current total entries: {current_entry_number}")
        return current_entry_number

    except Exception as e:
        print(f"Error appending entry to JSON: {str(e)}")
        return None  # Return None on error


def dump_project_to_json(project_id, project_private_key, project_public_key, project_filename="datasets/projects.json"):
    try:
        # Check if the file exists and read existing data
        if os.path.exists(project_filename):
            with open(project_filename, mode='r', encoding='utf-8') as file:
                data = json.load(file)
        else:
            data = []  # Start with an empty list if file doesn't exist

        # Create a new project entry
        new_entry = {
            "project_id": project_id,
            "project_private_key": project_private_key,
            "project_public_key": project_public_key
        }

        # Append new entry to the list
        data.append(new_entry)

        # Write back to the file
        with open(project_filename, mode='w', encoding='utf-8') as file:
            json.dump(data, file, indent=4)

        current_entry_number = len(data)
        print(f"Appended new entry to file '{project_filename}', current total entries: {current_entry_number}")
        return current_entry_number

    except Exception as e:
        print(f"Error appending entry to JSON: {str(e)}")
        return None  # Return None on error

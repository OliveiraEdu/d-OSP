from loguru import logger
from super_helper import with_logging_block, get_account_detail, fetch_project_details, download_file
import json
from ipfs_functions import download_json_from_ipfs


def processing_search_results_block(search_results):
    """
    Process search results by fetching and validating data, downloading metadata,
    and processing linked user and project information.

    Args:
        search_results (list): A list of dictionaries containing search result data.
                               Each dictionary must include 'project_id', 'file_cid',
                               and 'metadata_cid' keys.

    Returns:
        list: A list of tuples, where each tuple contains 
              (project_metadata_cid, linked_user, metadata_cid, project_id, file_cid)
    """
    results = []

    with with_logging_block("Processing Search Results", logger):
        for result_dict in search_results:
            project_id = result_dict.get('project_id')
            file_cid = result_dict.get('file_cid')
            metadata_cid = result_dict.get('metadata_cid')

            with with_logging_block(f"Processing Result for Project ID: {project_id or 'Unknown'}", logger):
                if not project_id or not file_cid or not metadata_cid:
                    logger.error(f"Missing required data in result: {result_dict}")
                    continue

                logger.info(f"File CID: {file_cid}")
                logger.info(f"Metadata CID: {metadata_cid}")

                # Fetch project details
                with with_logging_block("Fetching Project Details in the blockchain", logger):
                    project_details = get_account_detail(project_id)
                    blockchain_data = json.loads(project_details)
                    if not project_details:
                        logger.error(f"No project details found for Project ID: {project_id}.")
                        continue
                    logger.info(f"Fetched project details for {project_id}: {project_details}")

                # Validate file CID
                with with_logging_block("Validating File CID", logger):
                    validation_result = fetch_project_details(file_cid, blockchain_data)
                    
                    if not validation_result["is_valid"]:
                        logger.warning(f"Invalid File CID for Project ID: {project_id}. Skipping metadata processing.")
                        continue

                project_metadata_cid = validation_result.get("project_metadata_cid")
                linked_user = validation_result.get("linked_user")
                
                # Append the processed data to results
                results.append((project_metadata_cid, linked_user, metadata_cid, project_id, file_cid))

    return results


def metadata_block(processed_results, download_path):
    """
    Process the metadata for a list of processed results.

    Args:
        processed_results (list): A list of tuples containing 
                                  (project_metadata_cid, linked_user, metadata_cid, project_id, file_cid).
        download_path (str): The path where files will be downloaded.
    """
    with with_logging_block("Processing Metadata Block", logger):
        for project_metadata_cid, linked_user, metadata_cid, project_id, file_cid in processed_results:
            # Process project metadata
            if project_metadata_cid:
                with with_logging_block("Processing Project Metadata", logger):
                    try:
                        project_metadata = download_json_from_ipfs(project_metadata_cid)
                        logger.info(f"Downloaded project metadata: {project_metadata}")
                    except Exception as e:
                        logger.error(f"Error processing project metadata CID {project_metadata_cid}: {e}")

            # Process linked user details
            if linked_user:
                with with_logging_block(f"Processing Linked User: {linked_user}", logger):
                    try:
                        user_details = get_account_detail(linked_user)
                        user_details = json.loads(user_details)
                        
                        account_metadata_cid = user_details.get("admin@test", {}).get("account_metadata_cid")
                        if account_metadata_cid:
                            try:
                                user_metadata = download_json_from_ipfs(account_metadata_cid)
                                logger.info(f"Downloaded user metadata: {user_metadata}")
                            except Exception as e:
                                logger.error(f"Error downloading user metadata for CID {account_metadata_cid}: {e}")
                        else:
                            logger.warning(f"User JSON-LD CID not found for linked user {linked_user}.")
                    except json.JSONDecodeError as e:
                        logger.error(f"Error decoding user details JSON for {linked_user}: {e}")
                    except Exception as e:
                        logger.error(f"Error processing linked user {linked_user}: {e}")

            # Process metadata CID
            if metadata_cid:
                with with_logging_block("Processing Metadata CID", logger):
                    try:
                        file_metadata = download_json_from_ipfs(metadata_cid)
                        file_metadata_json = download_file(file_metadata, download_path, project_id, file_cid)
                        logger.info(f"Downloaded file metadata for {file_cid} in project {project_id}.")
                    except Exception as e:
                        logger.error(f"Error processing metadata CID {metadata_cid} for file {file_cid}: {e}")




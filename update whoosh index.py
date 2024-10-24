from whoosh.index import create_in, open_dir, EmptyIndexError  # Import EmptyIndexError
from metadata_helper import *
import os
import logging
import mimetypes
from tika import parser  # Import Apache Tika

print(project_account['account_id'])

# Function to extract only Dublin Core related metadata
def extract_dublin_core(metadata):
    """Extracts only Dublin Core related metadata."""
    return {k: v for k, v in metadata.items() if k.startswith('dc:') or k.startswith('dcterms:')}


# Function to parse and index documents from a directory
def parse_documents_in_directory(directory_path, schema, linked_project, project_id, recreate=False):
    """Parses documents in a directory and indexes them."""
    ix = recreate_index(schema) if recreate else create_in("indexdir", schema)
    writer = get_writer_with_retry(ix)
    index = 1

    for filename in os.listdir(directory_path):
        logging.info(f"Processing file: {filename}")

        if not os.path.basename(filename).startswith('.'):
            file_path = os.path.join(directory_path, filename)

            try:
                # Upload the file to IPFS and get its CID
                file_cid = upload_file_to_ipfs(file_path)
                logging.info(f"File {filename} uploaded to IPFS with CID: {file_cid}")

                # Update the project details in the Iroha 1 blockchain
                hash = set_account_detail(address, project_account['account_id'], f"file_{index}_CID", file_cid)

                # Parse the document using Apache Tika
                parsed_document = parser.from_file(file_path)

                if parsed_document:
                    metadata = parsed_document.get('metadata', {})
                    full_text = parsed_document.get("content", "").strip() or "No content extracted"

                    # Extract Dublin Core related metadata
                    dublin_core_metadata = extract_dublin_core(metadata)
                    
                    # Normalize and upload JSON metadata to IPFS
                    normalized_metadata = {
                        'cid': upload_json_to_ipfs(metadata),  # Upload the full metadata
                        'name': filename,
                        'size': os.path.getsize(file_path),
                        'filetype': mimetypes.guess_type(filename)[0] or "unknown",
                        'title': normalize_metadata_value(metadata.get("dc:title", f"Document {index}")),
                        'creator': normalize_metadata_value(metadata.get("dc:creator", "Unknown")),
                        'language': normalize_metadata_value(metadata.get("dc:language", "en")),
                        'subject': normalize_metadata_value(metadata.get("dc:subject", "")),
                        'description': normalize_metadata_value(metadata.get("dc:description", "")),
                        'publisher': normalize_metadata_value(metadata.get("dc:publisher", "Unknown")),
                        'date': normalize_metadata_value(metadata.get("dc:date", "")),
                        'abstract': normalize_metadata_value(metadata.get("dc:abstract", "")),
                        'format': normalize_metadata_value(metadata.get("dc:format", "")),
                        'created': normalize_metadata_value(metadata.get("dcterms:created", "")),
                        'modified': normalize_metadata_value(metadata.get("dcterms:modified", ""))
                    }

                    logging.info(f"Indexed {filename} with CID: {normalized_metadata['cid']}")

                    # Add document to the Whoosh index, including project_id and account_id
                    add_document(writer, {
                        **normalized_metadata,
                        'full_text': full_text,
                        'project_id': project_id,
                        'account_id': project_account['account_id']
                    })

                    # Print extracted Dublin Core metadata
                    print("Dublin Core Metadata:")
                    print(json.dumps(dublin_core_metadata, indent=4))

                    # Update project entry with file data and Dublin Core metadata
                    update_project_entry_with_file_data(
                        linked_project, file_cid, normalized_metadata['cid'], dublin_core_metadata
                    )

                    # Upload the metadata to IPFS and get its CID
                    metadata_cid = upload_json_to_ipfs(metadata)
                    logging.info(f"File {filename} uploaded to IPFS with CID: {metadata_cid}")

                    # Sets the project account detail with the file metadata
                    hash = set_account_detail(
                        address, project_account['account_id'], f"file_{index}_metadata_CID", metadata_cid
                    )

                else:
                    logging.error(f"Parsing failed for '{filename}'.")

            except Exception as e:
                logging.error(f"Error processing file '{filename}': {e}")
                continue

        logging.info("-" * 40)
        index += 1

    writer.commit()  # Commit changes once all files are processed
    logging.info("All documents processed and index committed.")


# Function to set up the Whoosh index directory
def setup_index(schema):
    """Sets up the Whoosh index directory and returns the index object."""
    index_dir = "indexdir"
    if not os.path.exists(index_dir):
        os.mkdir(index_dir)
        logging.info("Index directory created.")
        ix = create_in(index_dir, schema)
    else:
        try:
            ix = open_dir(index_dir)
            logging.info("Opened existing index.")
        except EmptyIndexError:
            logging.warning("Index is empty. Creating a new index.")
            ix = create_in(index_dir, schema)
    return ix


# Define the schema (including Dublin Core fields, project_id, and account_id)
schema = Schema(
    cid=ID(stored=True),
    name=TEXT(stored=True),
    size=NUMERIC(stored=True),
    filetype=TEXT(stored=True),
    title=TEXT(stored=True),
    creator=TEXT(stored=True),
    language=TEXT(stored=True),
    subject=TEXT(stored=True),
    description=TEXT(stored=True),
    publisher=TEXT(stored=True),
    date=TEXT(stored=True),
    abstract=TEXT(stored=True),
    format=TEXT(stored=True),
    created=TEXT(stored=True),  # Store as string (e.g., ISO format 'YYYY-MM-DD')
    modified=TEXT(stored=True),  # Store as string (e.g., ISO format 'YYYY-MM-DD')
    full_text=TEXT(stored=False),
    project_id=ID(stored=True),  # Adding project_id to the schema
    account_id=ID(stored=True)  # Adding account_id to the schema
)

# Setup index directory
ix = setup_index(schema)

# Example document parsing and indexing execution
directory_path = "upload"
linked_project = project_account['account_id']  # Example placeholder, adjust as needed
project_id = "example_project_id"  # Example project ID placeholder

# Parse documents in the specified directory
parse_documents_in_directory(directory_path, schema, linked_project, project_id, recreate=True)

from tika import parser
import json

# Function to extract only Dublin Core related metadata
def extract_dublin_core(metadata):
    return {k: v for k, v in metadata.items() if k.startswith('dc:') or k.startswith('dcterms:')}

# Function to parse a file and extract Dublin Core metadata
def extract_metadata_from_file(file_path):
    # Parse the file with Tika
    parsed = parser.from_file(file_path)
    
    # Get the full metadata from the parsed content
    metadata = parsed.get("metadata", {})
    
    # Extract only Dublin Core related metadata
    dublin_core_metadata = extract_dublin_core(metadata)
    
    return dublin_core_metadata

def process_file(file_path):
    parsed = parser.from_file(file_path)
    metadata = parsed.get("metadata", {})
    
    # Print all metadata to inspect what's being extracted
    # print("Full Metadata Extracted:")
    # print(json.dumps(metadata, indent=4))
    
    # Extract only Dublin Core metadata
    dublin_core_metadata = extract_dublin_core(metadata)
    
    if dublin_core_metadata:
        print("\nDublin Core Metadata Extracted:")
        print(json.dumps(dublin_core_metadata, indent=4))
    else:
        print("No Dublin Core metadata found.")


# Example usage
file_path = 'upload.old/Random-feature-selection-using-random-subspace-l_2023_Expert-Systems-with-Ap.pdf'  # Replace this with the path to your file
process_file(file_path)

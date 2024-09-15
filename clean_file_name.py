import chardet  # For detecting the encoding of the bytes object

# Assuming raw_original_file_name is a string like "b'bitcoin.pdf'"
def clean_file_name(raw_original_file_name):
    """
    Clean and decode the original file name from bytes to string.
    
    Parameters:
    raw_original_file_name (str): The original file name as a string enclosed in quotes.

    Returns:
    str: The decoded and cleaned file name as a string.
    """

    # Remove the enclosing quotes
    raw_bytes = eval(raw_original_file_name)  # This is a safe way to convert from string to bytes

    # Detect the encoding of the bytes object using chardet (but in this case, we can assume it's UTF-8)
    clean_original_file_name = raw_bytes.decode('utf-8')

    return clean_original_file_name.strip('"')  # Remove any remaining quotes

# Example usage:
# raw_original_file_name = ("b'Munaf\\xc3\\xb2 et al. - 2022 - The reproducibility debate is an "
#                              "opportunity, not .pdf'")
# clean_filename = clean_filename(raw_original_file_name)
# print(f"clean_original_file_name: '{clean_filename}'")
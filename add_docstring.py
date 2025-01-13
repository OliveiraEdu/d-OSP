import inspect
import os
import tempfile

def generate_docstrings_for_directory(directory_path):
    """
    Reads all Python files in the specified directory, adds docstrings to their functions, 
    and writes the updated files to a temporary directory for review.

    Args:
        directory_path (str): Path to the directory containing Python files.

    Returns:
        str: Path to the temporary directory where the updated files are saved.
    """
    # Create a temporary directory to save the updated files
    temp_dir = tempfile.mkdtemp()

    # Loop through all files in the directory
    for file_name in os.listdir(directory_path):
        # Process only Python files
        if file_name.endswith(".py"):
            file_path = os.path.join(directory_path, file_name)
            # Process each file and update docstrings
            update_file_with_docstrings(file_path, temp_dir)

    return temp_dir


def update_file_with_docstrings(file_path, temp_dir):
    """
    Updates the Python file with docstrings for its functions.

    Args:
        file_path (str): Path to the Python file to process.
        temp_dir (str): Path to the directory to save the updated file.
    """
    # Read the original file
    with open(file_path, "r") as f:
        lines = f.readlines()

    updated_lines = []

    for line in lines:
        # Check if the line defines a function
        if line.strip().startswith("def "):
            # Get the function name and arguments using inspect
            func_name = line.strip().split(" ")[1].split("(")[0]
            signature = inspect.signature(eval(func_name))
            params = signature.parameters
            
            # Create the function docstring
            docstring = f'    """\n    {func_name}: Brief description of the function.\n\n'
            docstring += "    Args:\n"
            
            # Add arguments to the docstring
            for param, details in params.items():
                param_type = details.annotation if details.annotation != inspect.Parameter.empty else "type"
                docstring += f"        {param} ({param_type}): Description of {param}.\n"
            
            docstring += "\n    Returns:\n        return_type: Description of the return value.\n"
            docstring += '    """\n'

            # Append the function line and the docstring
            updated_lines.append(line)
            updated_lines.append(docstring)
        else:
            updated_lines.append(line)

    # Write the updated content to a new file in the temp directory
    temp_file_path = os.path.join(temp_dir, os.path.basename(file_path))
    with open(temp_file_path, "w") as f:
        f.writelines(updated_lines)

    print(f"Updated file saved in: {temp_file_path}")


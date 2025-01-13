import os
import json
import ast
from nbformat import read


class FunctionExtractor(ast.NodeVisitor):
    def __init__(self):
        self.functions = {}
        self.current_function = None

    def visit_FunctionDef(self, node):
        self.current_function = node.name
        self.functions[self.current_function] = {"calls": set()}
        self.generic_visit(node)
        self.current_function = None

    def visit_Call(self, node):
        if self.current_function:
            if isinstance(node.func, ast.Name):
                self.functions[self.current_function]["calls"].add(node.func.id)
        self.generic_visit(node)


def extract_functions_from_code(code):
    try:
        tree = ast.parse(code)
    except SyntaxError as e:
        print(f"Syntax error while parsing code: {e}")
        return {}

    extractor = FunctionExtractor()
    extractor.visit(tree)
    return {func: {"calls": list(details["calls"])} for func, details in extractor.functions.items()}


def process_notebook(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as nb_file:
            notebook = read(nb_file, as_version=4)
    except Exception as e:
        print(f"Error reading notebook {file_path}: {e}")
        return {}

    functions_report = {}
    global_context = {}

    for cell in notebook.get("cells", []):
        if cell.get("cell_type") == "code":
            code = cell.get("source", "").strip()
            if code:
                try:
                    cell_functions = extract_functions_from_code(code)
                    global_context.update(cell_functions)  # Update the global context
                    functions_report.update(cell_functions)
                except Exception as e:
                    print(f"Error processing code in notebook {file_path}: {e}")

    return functions_report


def crawl_directory(directory):
    report = {}

    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(".ipynb"):
                notebook_path = os.path.join(root, file)
                notebook_name = os.path.relpath(notebook_path, directory)
                print(f"Processing: {notebook_name}")
                try:
                    functions_report = process_notebook(notebook_path)
                    report[notebook_name] = functions_report
                except Exception as e:
                    print(f"Error processing notebook {notebook_name}: {e}")

    return report


def generate_report(directory, output_file):
    report = crawl_directory(directory)

    try:
        with open(output_file, "w", encoding="utf-8") as json_file:
            json.dump(report, json_file, indent=4)
        print(f"Report generated: {output_file}")
    except Exception as e:
        print(f"Error writing report to {output_file}: {e}")


if __name__ == "__main__":
    target_directory = input("Enter the target directory (leave blank for current directory): ").strip()

    if not target_directory:
        target_directory = os.getcwd()
    else:
        target_directory = os.path.abspath(target_directory)

    output_file = input("Enter the output JSON file: ").strip()
    generate_report(target_directory, output_file)

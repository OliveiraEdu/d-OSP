#!/bin/bash

# Create the virtual environment
python3 -m venv venv
source venv/bin/activate  # Activate the virtual environment

# Check if we're actually inside a virtual environment
if [[ "$VIRTUAL_ENV" == "" ]]; then
  echo "Error: Virtual environment not activated correctly."
  exit 1
fi

# Check that pip is executing within the virtual environment
pip --version | grep -q "^venv/" && echo "Virtual environment detected." || (echo "Error: Pip does not seem to be executing within a virtual environment."; exit 1)

# Install packages from requirements.txt
pip install -r requirements.txt

# Install the ipython kernel (assuming you want to use it)
ipython kernel install --user --name=venv

# Optionally, you can also install the bash_kernel with pip instead of using python3 -m
# pip install bash_kernel
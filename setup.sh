You can add a check to ensure that the virtual environment has been activated correctly before attempting to install packages using `pip`. Here's an updated script:

```bash
#!/bin/bash

# Create the virtual environment
python3 -m venv venv
source venv/bin/activate  # Activate the virtual environment

# Check if we're actually inside a virtual environment
if [[ "$VIRTUAL_ENV" == "" ]]; then
  echo "Error: Virtual environment not activated correctly."
  exit 1
fi

# Install packages from requirements.txt
pip install -r requirements.txt

# Install the ipython kernel (assuming you want to use it)
ipython kernel install --user --name=venv

# Optionally, you can also install the bash_kernel with pip instead of using python3 -m
# pip install bash_kernel
```

In this updated script, we're checking if the `$VIRTUAL_ENV` environment variable is set. This variable is automatically set when a virtual environment is activated using `source venv/bin/activate`. If it's not set, we print an error message and exit with a non-zero status code.

However, you might want to take this one step further by adding another check to ensure that the `pip` command is correctly executing within the virtual environment. Here's how you can do it:

```bash
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
```

In this updated script, we're checking that the `--version` output from `pip` contains a path within the virtual environment (`^venv/`). If it doesn't, we print an error message and exit.
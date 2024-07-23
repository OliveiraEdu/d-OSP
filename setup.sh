#!/bin/bash

python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
ipython kernel install --user --name=venv
python -m bash_kernel.install

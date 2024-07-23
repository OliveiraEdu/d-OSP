#!/bin/bash
cd OpenScience/
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt 
python -m ipykernel install --user --name=venv
python -m bash_kernel.install
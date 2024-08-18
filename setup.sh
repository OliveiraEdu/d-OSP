#!/bin/bash

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
ipython kernel install --user --name=venv
jupyter lab --ip=0.0.0.0 --port=8888

#!/bin/bash

conda create -n venv
conda activate venv
conda install --yes --file requirements.txt
ipython kernel install --user --name=venv
python -m bash_kernel.install

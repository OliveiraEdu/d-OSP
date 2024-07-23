#!/bin/bash
git clone https://github.com/OliveiraEdu/OpenScience
cd OpenScience/
conda create -n venv
conda activate venv
conda install --file requirements.txt
ipython kernel install --user --name=venv
python -m bash_kernel.install

#!/bin/bash
git clone https://github.com/OliveiraEdu/OpenScience
cd OpenScience/
conda create -n venv
conda activate venv
pip install ipykernel
ipython kernel install --user --name=venv
pip install bash_kernel
python -m bash_kernel.install

curl -sL https://github.com/lsisan1212/test/raw/master/pyenv.sh | bash

curl -sL https://github.com/lsisan1212/test/raw/master/pyenv.sh -o 1.sh && chmod 777 1.sh && ./1.sh

wget -qO- https://github.com/lsisan1212/test/raw/master/pyenv.sh | bash


zip data
tar -cf data.tar data && bzip2 -9 data.tar

Install uv and python
curl -LsSf https://astral.sh/uv/install.sh | sh
uv self update
uv venv --python=3.11.12 alpha
source alpha/bin/activate
uv pip install --force-reinstall xbx-py11

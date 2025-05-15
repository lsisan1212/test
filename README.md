curl -sL https://github.com/lsisan1212/test/raw/master/pyenv.sh | bash

curl -sL https://github.com/lsisan1212/test/raw/master/pyenv.sh -o pyenv.sh && chmod 777 pyenv.sh && ./pyenv.sh

curl -sL https://github.com/lsisan1212/test/raw/master/uv.sh -o uv.sh && chmod 777 uv.sh && ./uv.sh

curl -sL https://github.com/lsisan1212/test/raw/master/uv2.sh -o uv2.sh && chmod 777 uv2.sh && ./uv2.sh


curl -sL https://github.com/lsisan1212/test/raw/master/uv4.sh -o uv4.sh && chmod 777 uv4.sh && source /uv4.sh

wget -qO- https://github.com/lsisan1212/test/raw/master/pyenv.sh | bash


zip data
tar -cf data.tar data && bzip2 -9 data.tar

Install uv and python
curl -LsSf https://astral.sh/uv/install.sh | sh
uv self update
uv venv --python=3.11.12 alpha
source alpha/bin/activate
uv pip install --force-reinstall xbx-py11

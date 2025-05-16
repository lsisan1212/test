curl -sL https://github.com/lsisan1212/test/raw/master/uv.sh -o uv.sh && chmod 777 uv.sh && source uv.sh

curl -sL https://github.com/lsisan1212/test/raw/master/uv4.sh -o uv4.sh && chmod 777 uv4.sh && source uv4.sh

zip data
tar -cf data.tar data && bzip2 -9 data.tar

Install uv and python
curl -LsSf https://astral.sh/uv/install.sh | sh
uv self update
uv venv --python=3.11.12 alpha
source alpha/bin/activate
uv pip install --force-reinstall xbx-py11

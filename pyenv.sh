#!/bin/bash

# 下载和安装 Google Chrome
echo "======================================="
echo "1.开始安装 Google Chrome"
echo "======================================="

# 检查系统包管理工具
if command -v apt >/dev/null 2>&1; then
  # 对于 Ubuntu/Debian 系统
  wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome.deb
  sudo dpkg -i /tmp/google-chrome.deb
  sudo apt-get install -f -y

elif command -v dnf >/dev/null 2>&1; then
  # 对于 CentOS 8 及以上版本使用 dnf
  wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm -O /tmp/google-chrome.rpm
  sudo dnf localinstall -y /tmp/google-chrome.rpm

else
  echo "无法识别的操作系统或包管理工具，无法安装 Google Chrome。"
  exit 1
fi

# 验证 Google Chrome 是否安装成功
if command -v google-chrome >/dev/null 2>&1; then
  echo "Google Chrome 安装成功！"
  google-chrome --version
else
  echo "Google Chrome 安装失败，请检查错误日志。"
  exit 1
fi

# 清理临时文件
echo "清理临时文件..."
rm -f /tmp/google-chrome.*

echo "完成！您可以使用 'google-chrome' 运行 Google Chrome。"

# Install dependencies
echo "Installing dependencies..."
sudo apt update || handle_error "Failed to update package lists"
sudo apt install -y git curl build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python3-openssl || handle_error "Failed to install dependencies"

# Install pyenv
echo "======================================="
echo "2.Installing pyenv and python and xbx-py11"
echo "======================================="
curl https://pyenv.run | bash || handle_error "Failed to install pyenv"

# Add pyenv to zshrc
echo "Configuring pyenv in ~/.zshrc..."
{
    echo 'export PATH="$HOME/.pyenv/bin:$PATH"'
    echo 'eval "$(pyenv init --path)"'
    echo 'eval "$(pyenv init -)"'
    echo 'eval "$(pyenv virtualenv-init -)"'
} >> ~/.zshrc || handle_error "Failed to update ~/.zshrc"

# Source zshrc
echo "Sourcing ~/.zshrc..."
source ~/.zshrc || handle_error "Failed to source ~/.zshrc"

# Install and set Python version
echo "Installing Python 3.11.12..."
pyenv install 3.11.12 || handle_error "Failed to install Python 3.11.12"
pyenv global 3.11.12 || handle_error "Failed to set Python 3.11.12 as global"

# Source zshrc again
echo "Sourcing ~/.zshrc again..."
source ~/.zshrc || handle_error "Failed to source ~/.zshrc"

# Install xbx-py11
echo "Installing xbx-py11..."
pip install xbx-py11 || handle_error "Failed to install xbx-py11"

# 安装 PM2
echo "======================================="
echo "3.开始安装 PM2..."
echo "======================================="
# 安装 Node.js（PM2 依赖 Node.js）
sudo apt update
sudo apt install -y nodejs npm
# 安装 PM2
sudo npm install -g pm2
# 验证 PM2 安装
pm2 --version

# 启动新的交互式 shell，保持在虚拟环境中
#exec $SHELL

#echo "Sourcing ~/.zshrc..."
#source ~/.zshrc || handle_error "Failed to source ~/.zshrc"

# Display disk usage
echo "Displaying disk usage..."
df -h || handle_error "Failed to run df -h"

# Display system info
echo "Displaying system info..."
neofetch || handle_error "Failed to run neofetch"

pyenv --version
python --version
google-chrome --version
pm2 --version
echo "Script completed successfully!"
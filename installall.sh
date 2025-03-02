#!/bin/bash

# 下载和安装 Google Chrome
echo "开始安装 Google Chrome..."

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


# 安装 Anaconda
echo "开始安装 Anaconda..."
# 下载 Anaconda 安装脚本
wget https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh -O ~/anaconda_installer.sh
# 运行安装脚本
bash ~/anaconda_installer.sh -b -p $HOME/anaconda3
# 将 Anaconda 添加到 PATH
echo 'export PATH="$HOME/anaconda3/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
# 验证 Anaconda 安装
conda --version

# 安装 PM2
echo "开始安装 PM2..."
# 安装 Node.js（PM2 依赖 Node.js）
sudo apt update
sudo apt install -y nodejs npm
# 安装 PM2
sudo npm install -g pm2
# 验证 PM2 安装
pm2 --version

# 创建 Python 3.11 的 Alpha 环境
echo "创建 Python 3.11 的 Alpha 环境..."
# 切换进Anaconda3的目录中
cd anaconda3
# 激活base环境
source bin/activate
# 创建新的环境
conda create -n Alpha python=3.11 -y
# 激活环境
conda activate Alpha
# 验证 Python 版本
python --version

# 安装 xbx-py11 库
echo "安装 xbx-py11 库..."
pip install xbx-py11

# 完成
echo "Anaconda、PM2 和 Python 环境安装完成，且安装了 xbx-py11 库。"

# 启动新的交互式 shell，保持在虚拟环境中
exec $SHELL
exit

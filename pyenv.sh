#!/bin/bash

start_time=$(date +%s)

handle_error() {
  echo "错误 / Error: $1"
  exit 1
}

while read -t 0.1 -r; do :; done

echo "您想安装哪些部分？（输入以空格分隔的数字） / Which parts do you want to install? (Enter numbers separated by spaces)"
echo "1. Google Chrome"
echo "2. Pyenv, Python, and xbx-py11"
echo "3. PM2"
echo "输入您的选择（例如，1 2 3）或按回车安装全部。10秒后超时... / Enter your choice (e.g., 1 2 3) or press Enter to install all. Timeout in 10 seconds..."

if [ -t 0 ]; then
  echo "Waiting for input..."
  read -t 10 choice < /dev/tty
  read_status=$?
  echo "Read returned: choice='$choice', status=$read_status"
else
  echo "Non-interactive environment detected. Defaulting to all components..."
  choice="1 2 3"
fi

if [ -z "$choice" ]; then
  choice="1 2 3"
  echo "未收到响应。将安装所有组件... / No response received. Installing all components..."
fi

choices=($choice)

contains() {
  local value=$1
  for item in "${choices[@]}"; do
    if [ "$item" == "$value" ]; then
      return 0
    fi
  done
  return 1
}

if contains 1; then
  echo "======================================="
  echo "1. 开始安装 Google Chrome / 1. Installing Google Chrome"
  echo "======================================="
  if command -v apt >/dev/null 2>&1; then
    echo "正在为 Ubuntu/Debian 下载 Google Chrome... / Downloading Google Chrome for Ubuntu/Debian..."
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome.deb
    sudo dpkg -i /tmp/google-chrome.deb
    sudo apt-get install -f -y
  elif command -v dnf >/dev/null 2>&1; then
    echo "正在为 CentOS 下载 Google Chrome... / Downloading Google Chrome for CentOS..."
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm -O /tmp/google-chrome.rpm
    sudo dnf localinstall -y /tmp/google-chrome.rpm
  else
    echo "无法识别的操作系统或包管理工具。无法安装 Google Chrome。 / Unrecognized operating system or package manager. Cannot install Google Chrome."
    exit 1
  fi

  if command -v google-chrome >/dev/null 2>&1; then
    echo "Google Chrome 安装成功！ / Google Chrome installed successfully!"
    google-chrome --version
  else
    echo "Google Chrome 安装失败。请检查错误日志。 / Google Chrome installation failed. Please check error logs."
    exit 1
  fi

  echo "清理临时文件... / Cleaning up temporary files..."
  rm -f /tmp/google-chrome.*
  echo "完成！您可以使用 'google-chrome' 运行 Google Chrome。 / Done! You can run Google Chrome with 'google-chrome'."
fi

if contains 2; then
  echo "======================================="
  echo "2. 安装 pyenv、Python 和 xbx-py11 / 2. Installing pyenv, Python, and xbx-py11"
  echo "======================================="
  echo "安装依赖项... / Installing dependencies..."
  sudo apt update || handle_error "更新软件包列表失败 / Failed to update package lists"
  sudo apt install -y git curl build-essential libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev wget llvm libncurses5-dev libncursesw5-dev \
  xz-utils tk-dev libffi-dev liblzma-dev python3-openssl || handle_error "安装依赖项失败 / Failed to install dependencies"

  echo "安装 pyenv... / Installing pyenv..."
  curl https://pyenv.run | bash || handle_error "安装 pyenv 失败 / Failed to install pyenv"

  echo "检测用户 shell... / Detecting user shell..."
  if [[ "$SHELL" == */zsh ]]; then
    config_file="$HOME/.zshrc"
    echo "检测到 Zsh，将配置 pyenv 到 ~/.zshrc / Detected Zsh, configuring pyenv in ~/.zshrc"
  elif [[ "$SHELL" == */bash ]]; then
    config_file="$HOME/.bashrc"
    echo "检测到 Bash，将配置 pyenv 到 ~/.bashrc / Detected Bash, configuring pyenv in ~/.bashrc"
  else
    echo "警告：未检测到 Zsh 或 Bash ($SHELL)。将默认使用 ~/.bashrc，但您可能需要手动配置 pyenv。 / Warning: Neither Zsh nor Bash detected ($SHELL). Defaulting to ~/.bashrc, but you may need to configure pyenv manually."
    config_file="$HOME/.bashrc"
  fi

  echo "在 $config_file 中配置 pyenv... / Configuring pyenv in $config_file..."
  {
      echo 'export PATH="$HOME/.pyenv/bin:$PATH"'
      echo 'eval "$(pyenv init --path)"'
      echo 'eval "$(pyenv init -)"'
      echo 'eval "$(pyenv virtualenv-init -)"'
  } >> "$config_file" || handle_error "更新 $config_file 失败 / Failed to update $config_file"

  echo "加载 $config_file... / Sourcing $config_file..."
  source "$config_file" || handle_error "加载 $config_file 失败 / Failed to source $config_file"

  echo "安装 Python 3.11.12... / Installing Python 3.11.12..."
  pyenv install 3.11.12 || handle_error "安装 Python 3.11.12 失败 / Failed to install Python 3.11.12"
  pyenv global 3.11.12 || handle_error "设置 Python 3.11.12 为全局版本失败 / Failed to set Python 3.11.12 as global"

  echo "再次加载 $config_file... / Sourcing $config_file again..."
  source "$config_file" || handle_error "加载 $config_file 失败 / Failed to source $config_file"

  echo "安装 xbx-py11... / Installing xbx-py11..."
  pip install xbx-py11 || handle_error "安装 xbx-py11 失败 / Failed to install xbx-py11"
fi

if contains 3; then
  echo "======================================="
  echo "3. 开始安装 PM2... / 3. Installing PM2..."
  echo "======================================="
  echo "安装 Node.js 和 npm... / Installing Node.js and npm..."
  sudo apt update
  sudo apt install -y nodejs npm
  echo "安装 PM2... / Installing PM2..."
  sudo npm install -g pm2
  echo "PM2 版本： / PM2 version:"
  pm2 --version
fi

echo "显示磁盘使用情况... / Displaying disk usage..."
df -h || handle_error "运行 df -h 失败 / Failed to run df -h"

echo "显示系统信息... / Displaying system info..."
neofetch || handle_error "运行 neofetch 失败 / Failed to run neofetch"

if contains 1; then
  echo "Google Chrome 版本： / Google Chrome version:"
  google-chrome --version
fi
if contains 2; then
  echo "Pyenv 版本： / Pyenv version:"
  pyenv --version
  echo "Python 版本： / Python version:"
  python --version
fi
if contains 3; then
  echo "PM2 版本： / PM2 version:"
  pm2 --version
fi

end_time=$(date +%s)
execution_time=$((end_time - start_time))
minutes=$((execution_time / 60))
seconds=$((execution_time % 60))
echo "脚本成功完成！ / Script completed successfully!"
echo "总执行时间：$minutes 分钟 $seconds 秒 / Total execution time: $minutes minutes and $seconds seconds"

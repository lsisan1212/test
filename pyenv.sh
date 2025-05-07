#!/bin/bash

start_time=$(date +%s)

current_time=$(date "+%Y-%m-%d %H:%M:%S")
echo "Current time: $current_time"

handle_error() {
  echo "错误 / Error: $1" | tee -a /tmp/pyenv_install.log
  exit 1
}

echo "Logging to /tmp/pyenv_install.log"
exec > >(tee -a /tmp/pyenv_install.log) 2>&1

if ! command -v sudo >/dev/null 2>&1; then
  echo "警告：sudo 未安装或不可用。某些安装步骤可能失败。 / Warning: sudo not installed or unavailable. Some installation steps may fail."
fi

while read -t 0.1 -r _; do :; done

echo "您想安装哪些部分？（输入以空格分隔的数字） / Which parts do you want to install? (Enter numbers separated by spaces)"
echo "1. 全部 (Google Chrome, Pyenv, PM2) / All (Google Chrome, Pyenv, PM2)"
echo "2. Google Chrome"
echo "3. Pyenv, Python, and xbx-py11"
echo "4. PM2"
echo "输入您的选择（例如，1 2 3）或按回车安装全部... / Enter your choice (e.g., 1 2 3) or press Enter to install all..."

if [ -t 0 ]; then
  echo "Waiting for input..."
  read choice < /dev/tty
  read_status=$?
  echo "Read returned: choice='$choice', status=$read_status"
else
  echo "Non-interactive environment detected. Defaulting to all components..."
  choice="1"
fi

if [ -z "$choice" ]; then
  choice="1"
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

# Function to install Google Chrome
install_chrome() {
  echo "======================================="
  echo "安装 Google Chrome / Installing Google Chrome"
  echo "======================================="
  if command -v apt >/dev/null 2>&1; then
    echo "正在为 Ubuntu/Debian 下载 Google Chrome... / Downloading Google Chrome for Ubuntu/Debian..."
    wget -q -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb || {
      echo "下载 Google Chrome 失败。 / Failed to download Google Chrome."
      exit 1
    }
    sudo dpkg -i /tmp/google-chrome.deb || echo "dpkg 安装失败，将尝试修复... / dpkg installation failed, attempting to fix..."
    sudo apt-get install -f -y || echo "修复依赖失败。 / Failed to fix dependencies."
  elif command -v dnf >/dev/null 2>&1; then
    echo "正在为 CentOS 下载 Google Chrome... / Downloading Google Chrome for CentOS..."
    wget -q -O /tmp/google-chrome.rpm https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm || {
      echo "下载 Google Chrome 失败。 / Failed to download Google Chrome."
      exit 1
    }
    sudo dnf localinstall -y /tmp/google-chrome.rpm || echo "dnf 安装失败。 / dnf installation failed."
  else
    echo "无法识别的操作系统或包管理工具。跳过 Google Chrome 安装。 / Unrecognized operating system or package manager. Skipping Google Chrome installation."
  fi

  if command -v google-chrome >/dev/null 2>&1; then
    echo "Google Chrome 安装成功！ / Google Chrome installed successfully!"
    google-chrome --version
  else
    echo "Google Chrome 安装失败。请检查日志 /tmp/pyenv_install.log。 / Google Chrome installation failed. Please check logs in /tmp/pyenv_install.log."
  fi

  echo "清理临时文件... / Cleaning up temporary files..."
  rm -f /tmp/google-chrome.* || echo "清理临时文件失败。 / Failed to clean up temporary files."
  echo "---------------------------------------"
  echo "完成！您可以使用 'google-chrome' 运行 Google Chrome。 / Done! You can run Google Chrome with 'google-chrome'."
  echo "---------------------------------------"
}

# Function to install Pyenv, Python, and xbx-py11
install_pyenv() {
  echo "======================================="
  echo "安装 pyenv、Python 和 xbx-py11 / Installing pyenv, Python, and xbx-py11"
  echo "======================================="
  echo "安装依赖项... / Installing dependencies..."
  sudo apt update
  sudo apt install -y git curl build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python3-openssl

  echo "安装 pyenv... / Installing pyenv..."
  curl -s https://pyenv.run | bash

  echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
  echo 'eval "$(pyenv init -)"' >> ~/.zshrc
  echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc

  source ~/.zshrc
  pyenv install 3.11.12
  pyenv global 3.11.12

  source ~/.zshrc
  echo "---------------------------------------"
  echo "完成！您可以使用 'python' 运行 python。 / Done! You can run python."
  echo "---------------------------------------"
}

# Function to install PM2
install_pm2() {
  echo "======================================="
  echo "开始安装 PM2... / Installing PM2..."
  echo "======================================="
  echo "安装 Node.js 和 npm... / Installing Node.js and npm..."
  sudo apt update || echo "更新软件包列表失败，继续尝试安装... / Failed to update package lists, continuing..."
  sudo apt install -y nodejs npm || echo "安装 Node.js 和 npm 失败。 / Failed to install Node.js and npm."
  echo "安装 PM2... / Installing PM2..."
  sudo npm install -g pm2 || echo "安装 PM2 失败。 / Failed to install PM2."
  if command -v pm2 >/dev/null 2>&1; then
    echo "PM2 版本： / PM2 version:"
    pm2 --version
  else
    echo "PM2 安装失败。 / PM2 installation failed."
  fi
}

# Process choices
if contains 1; then
  install_chrome
  install_pyenv
  install_pm2
fi
if contains 2; then
  install_chrome
fi
if contains 3; then
  install_pyenv
fi
if contains 4; then
  install_pm2
fi

echo "显示磁盘使用情况... / Displaying disk usage..."
df -h || echo "运行 df -h 失败 / Failed to run df -h"

echo "显示系统信息... / Displaying system info..."
neofetch || echo "运行 neofetch 失败，可能未安装。 / Failed to run neofetch, may not be installed."

if contains 1 || contains 2; then
  echo "Google Chrome 版本： / Google Chrome version:"
  google-chrome --version || echo "无法显示 Google Chrome 版本。 / Failed to display Google Chrome version."
fi
if contains 1 || contains 3; then
  echo "Pyenv 版本： / Pyenv version:"
  pyenv --version || echo "无法显示 Pyenv 版本。 / Failed to display Pyenv version."
  echo "Python 版本： / Python version:"
  python --version || echo "无法显示 Python 版本。 / Failed to display Python version."
fi
if contains 1 || contains 4; then
  echo "PM2 版本： / PM2 version:"
  pm2 --version || echo "无法显示 PM2 版本。 / Failed to display PM2 version."
fi

end_time=$(date +%s)
execution_time=$((end_time - start_time))
minutes=$((execution_time / 60))
seconds=$((execution_time % 60))
echo "脚本成功完成！ / Script completed successfully!"
echo "总执行时间：$minutes 分钟 $seconds 秒 / Total execution time: $minutes minutes and $seconds seconds"
echo "请检查 /tmp/pyenv_install.log 以获取详细信息。 / Please check /tmp/pyenv_install.log for details."

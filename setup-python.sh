#!/bin/bash
# =============================================================
# Python Development Environment Setup (Aliyun PyPI Mirror)
# Usage: ./setup-python.sh
# =============================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

echo "=========================================="
echo " Python Setup (Aliyun PyPI Mirror)"
echo "=========================================="

# 1. 自动安装 Python 和 pip
log_info "检查 Python 和 pip..."

if ! command -v python3 &> /dev/null; then
    log_warn "未找到 python3，正在通过 pacman 安装..."
    sudo pacman -S --noconfirm python
else
    log_info "python3 已安装。"
fi

if ! command -v pip &> /dev/null; then
    log_warn "未找到 pip，正在通过 pacman 安装..."
    sudo pacman -S --noconfirm python-pip
else
    log_info "pip 已安装。"
fi

# 2. 配置 pip 镜像源 (阿里云)
log_info "配置 pip 镜像源..."
mkdir -p "$HOME/.config/pip"
cat > "$HOME/.config/pip/pip.conf" << 'PIP_EOF'
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/
trusted-host = mirrors.aliyun.com
default-timeout = 60
PIP_EOF
log_info "pip 镜像配置完成。"

# 3. 设置 ~/.bashrc 环境变量
log_info "配置 bashrc 环境变量..."
if ! grep -q "PYTHONPATH" "$HOME/.bashrc"; then
    echo "" >> "$HOME/.bashrc"
    echo "# Python Path" >> "$HOME/.bashrc"
    echo 'export PYTHONPATH="$PYTHONPATH:$HOME/.local/python/site-packages"' >> "$HOME/.bashrc"
    log_info "✅ PYTHONPATH 已添加到 .bashrc"
else
    log_info "PYTHON PATH 已存在于 .bashrc 中，跳过添加。"
fi

log_info "Python 环境配置完成！"

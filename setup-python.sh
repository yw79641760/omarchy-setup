#!/bin/bash
# =============================================================================
# Python Development Environment Setup (Aliyun PyPI Mirror)
# Usage: ./setup-python.sh
# =============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

echo "=========================================="
echo " Python Setup (Aliyun PyPI Mirror)"
echo "=========================================="

# ------------------------------------------
# pip configuration
# ------------------------------------------
mkdir -p "$HOME/.config/pip"

cat > "$HOME/.config/pip/pip.conf" << 'PIP_EOF'
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/
trusted-host = mirrors.aliyun.com
default-timeout = 60

[install]
trusted-host = mirrors.aliyun.com

[download]
trusted-host = mirrors.aliyun.com
PIP_EOF
log_info "PyPI mirror configured ( ~/.config/pip/pip.conf )"

# ------------------------------------------
# Python detection
# ------------------------------------------
if command -v python3 &> /dev/null; then
    log_info "Python version: $(python3 --version)"
else
    log_warn "Python not found. Install with: sudo pacman -S python python-pip"
fi

# ------------------------------------------
# Update ~/.bashrc
# ------------------------------------------
if ! grep -q "PYTHONPATH" "$HOME/.bashrc"; then
    echo "" >> "$HOME/.bashrc"
    echo "# Python Configuration" >> "$HOME/.bashrc"
    echo "export PYTHONPATH=\"\${PYTHONPATH:-\$HOME/.local/lib/python3/site-packages}\"" >> "$HOME/.bashrc"
    log_info "Added Python environment variables to ~/.bashrc"
fi

log_info "Python setup complete."

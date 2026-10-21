#!/bin/bash
# =============================================================================
# Herdr Prefix Setup
# Configures the Herdr prefix to Ctrl + B
# =============================================================================

GREEN='\033[0;32m'
NC='\033[0m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }

echo "=========================================="
echo " Herdr Prefix Setup"
echo "=========================================="

CONFIG_FILE="$HOME/.config/herdr/config.toml"

if [ -f "$CONFIG_FILE" ]; then
    # 修改 TOML 中的 prefix 设置
    sed -i 's/^prefix = .*/prefix = "ctrl+b"/' "$CONFIG_FILE"
    log_info "Herdr prefix set to 'ctrl+b' in $CONFIG_FILE"
    
    # 重新加载配置
    if command -v herdr &> /dev/null; then
        herdr server reload-config
        log_info "Herdr configuration reloaded."
    fi
else
    log_info "Herdr config file not found at $CONFIG_FILE"
fi

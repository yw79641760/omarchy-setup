#!/bin/bash
# =============================================================================
# Omarchy System Settings Setup
# Configures Herdr prefix and native Omarchy power management
# =============================================================================

GREEN='\033[0;32m'
NC='\033[0m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }

echo "=========================================="
echo " Omarchy System Settings Setup"
echo "=========================================="

# 1. Herdr Prefix Setup
CONFIG_FILE="$HOME/.config/herdr/config.toml"
if [ -f "$CONFIG_FILE" ]; then
    sed -i 's/^prefix = .*/prefix = "ctrl+b"/' "$CONFIG_FILE"
    [ -n "$(command -v herdr)" ] && herdr server reload-config
    log_info "Herdr prefix set to 'ctrl+b'"
fi

# 2. Native Omarchy Power Management (1 Hour Screensaver)
log_info "Configuring Omarchy native idle/screensaver settings..."

SHELL_JSON="$HOME/.config/omarchy/shell.json"
if [ -f "$SHELL_JSON" ]; then
    # 修改 screensaver 时间为 3600 秒
    sed -i 's/"screensaver": [0-9]*/"screensaver": 3600/' "$SHELL_JSON"
    log_info "Screensaver timeout set to 3600s (1 hour) in $SHELL_JSON"
else
    log_warn "Omarchy shell.json not found, skipping screensaver config."
fi

log_info "Omarchy system settings (Herdr + Power) updated."

#!/bin/bash
# =============================================================================
# Omarchy System Settings Setup
# 1. Herdr Prefix to Ctrl+B
# 2. Stay Awake (Native Omarchy method)
# 3. Screensaver timeout to 1h
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

log_info "Omarchy system settings setup complete."
if command -v omarchy &> /dev/null; then
    omarchy toggle idle stay-awake
    log_info "Omarchy set to 'stay-awake' mode."
fi

# 4. Screensaver timeout to 3600s
log_info "Configuring 1-hour screensaver timeout..."
SHELL_JSON="$HOME/.config/omarchy/shell.json"
if [ -f "$SHELL_JSON" ]; then
    sed -i 's/"screensaver": [0-9]*/"screensaver": 3600/' "$SHELL_JSON"
    log_info "Screensaver timeout set to 3600s (1 hour) in $SHELL_JSON"
fi

log_info "Omarchy system settings setup complete."

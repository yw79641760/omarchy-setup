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

# 2. Native Omarchy Power Management
log_info "Configuring Omarchy native idle/screensaver settings..."

# 确保 idle 行为受 Omarchy 控制
if command -v omarchy &> /dev/null; then
    omarchy toggle idle allow-idle
    log_info "Idle behavior set to allow-idle."
else
    log_warn "omarchy command not found, skipping power settings."
fi

log_info "Omarchy system settings (Herdr + Power) updated."

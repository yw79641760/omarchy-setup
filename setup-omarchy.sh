#!/bin/bash
# =============================================================================
# Omarchy Shell Prefix Setup
# Configures the shell prefix (header) to Ctrl + B
# =============================================================================

GREEN='\033[0;32m'
NC='\033[0m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }

echo "=========================================="
echo " Omarchy Shell Prefix Setup"
echo "=========================================="

# ------------------------------------------
# Update shell prefix in ~/.bashrc or config
# Assuming Omarchy shell uses a specific variable or config file
# ------------------------------------------
# If Omarchy uses a standard format for its header prefix:
CONFIG_FILE="$HOME/.config/omarchy/shell.conf"

mkdir -p "$(dirname "$CONFIG_FILE")"

# Update or create the configuration
if grep -q "PREFIX=" "$CONFIG_FILE"; then
    sed -i 's/^PREFIX=.*/PREFIX="Ctrl+B"/' "$CONFIG_FILE"
else
    echo 'PREFIX="Ctrl+B"' >> "$CONFIG_FILE"
fi

log_info "Omarchy header prefix set to 'Ctrl + B' in $CONFIG_FILE"
log_info "Shell configuration complete."

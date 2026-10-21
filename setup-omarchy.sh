#!/bin/bash
# =============================================================================
# Omarchy System Settings Setup
# Configures Herdr prefix and Power Management (Hypridle)
# =============================================================================

GREEN='\033[0;32m'
NC='\033[0m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

echo "=========================================="
echo " Omarchy System Settings Setup"
echo "=========================================="

# ------------------------------------------
# 1. Herdr Prefix Setup
# ------------------------------------------
CONFIG_FILE="$HOME/.config/herdr/config.toml"

if [ -f "$CONFIG_FILE" ]; then
    sed -i 's/^prefix = .*/prefix = "ctrl+b"/' "$CONFIG_FILE"
    log_info "Herdr prefix set to 'ctrl+b' in $CONFIG_FILE"
    
    if command -v herdr &> /dev/null; then
        herdr server reload-config
        log_info "Herdr configuration reloaded."
    fi
else
    log_info "Herdr config file not found at $CONFIG_FILE"
fi

# ------------------------------------------
# 2. Power & Screen settings (Hypridle)
# ------------------------------------------
log_info "Configuring power management (disable suspend/screensaver)..."

HYPRIDLE_CONF="$HOME/.config/hypr/hypridle.conf"

if [ -f "$HYPRIDLE_CONF" ]; then
    # Disable auto-suspend and screensaver by commenting out the timeouts
    sed -i 's/^\(timeout\)/# \1/' "$HYPRIDLE_CONF"
    log_info "Commented out idle timeouts in hypridle.conf"
    
    # Reload hypridle if running
    if pgrep hypridle > /dev/null; then
        killall hypridle && hypridle &
        log_info "Restarted hypridle to apply changes."
    fi
else
    log_warn "hypridle config not found at $HYPRIDLE_CONF. Skipping power settings."
fi

log_info "Omarchy system settings setup complete."

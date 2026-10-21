#!/bin/bash
# =============================================================================
# Omarchy System Settings Setup
# 1. Herdr Prefix to Ctrl+B
# 2. Workspace switching: FIFO (cycling)
# 3. Stay Awake (Native Omarchy method)
# 4. Screensaver timeout to 1h
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

# 2. Workspace switching: FIFO (cycling) instead of FILO
log_info "Configuring workspace switching to FIFO order..."
BINDINGS="$HOME/.config/hypr/bindings.lua"
if [ -f "$BINDINGS" ]; then
    if ! grep -q "wrap = true" "$BINDINGS"; then
        cat >> "$BINDINGS" << 'EOF'

-- Override workspace switching to be FIFO (cycling) instead of FILO
hl.unbind("SUPER + TAB")
hl.unbind("SUPER + SHIFT + TAB")

o.bind("SUPER + TAB", "Next workspace (cycling)", hl.dsp.focus({ workspace = "e+1", wrap = true }))
o.bind("SUPER + SHIFT + TAB", "Previous workspace (cycling)", hl.dsp.focus({ workspace = "e-1", wrap = true }))
EOF
        log_info "Added FIFO workspace switching to bindings.lua"
        hyprctl reload > /dev/null 2>&1 || true
    else
        log_info "FIFO workspace switching already configured"
    fi
else
    log_warn "bindings.lua not found, skipping workspace config."
fi

# 3. Power Management (Stay Awake)
log_info "Configuring native Omarchy power management..."
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

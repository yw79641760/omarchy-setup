#!/bin/bash
# =============================================================================
# Omarchy System Settings Setup
# 1. Herdr Prefix to Ctrl+B
# 2. Stay Awake (Native Omarchy method)
# 3. Screensaver timeout to 1h (Native Omarchy method)
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
    # Check if the FIFO override is already present
    if ! grep -q "wrap = true" "$BINDINGS"; then
        cat >> "$BINDINGS" << 'EOF'

-- Override workspace switching to be FIFO (cycling) instead of FILO
hl.unbind("SUPER + TAB")
hl.unbind("SUPER + SHIFT + TAB")

o.bind("SUPER + TAB", "Next workspace (cycling)", hl.dsp.focus({ workspace = "e+1", wrap = true }))
o.bind("SUPER + SHIFT + TAB", "Previous workspace (cycling)", hl.dsp.focus({ workspace = "e-1", wrap = true }))
EOF
        log_info "Added FIFO workspace switching to bindings.lua"
        # Reload Hyprland to apply
        hyprctl reload > /dev/null 2>&1 || true
    else
        log_info "FIFO workspace switching already configured"
    fi
else
    log_warn "bindings.lua not found, skipping workspace config."
fi

# 2. Power Management (Use Omarchy native commands)
log_info "Configuring native Omarchy power management..."

# 需求：插电状态下永不休眠
# 符合 Omarchy Skill 的最佳实践是使用 omarchy toggle
if command -v omarchy &> /dev/null; then
    omarchy toggle idle stay-awake
    log_info "Omarchy set to 'stay-awake' mode."
fi

# 3. Workspace switching: FIFO order (wrap_windows)
log_info "Configuring workspace switching to FIFO order..."
LOOKNFEEL="$HOME/.config/hypr/looknfeel.lua"
if [ -f "$LOOKNFEEL" ]; then
    # Check if wrap_windows is already configured
    if ! grep -q "wrap_windows" "$LOOKNFEEL"; then
        # Add wrap_windows config at the beginning of the file (after comments)
        sed -i '1,/^$/ { /^-- Change the default/a\
-- Enable FIFO workspace switching\
hl.config({\
  general = {\
    wrap_windows = true,\
  },\
})\
' "$LOOKNFEEL"
        log_info "Added wrap_windows = true to looknfeel.lua"
    else
        log_info "wrap_windows already configured in looknfeel.lua"
    fi
    # Reload Hyprland to apply
    hyprctl reload > /dev/null 2>&1 || true
else
    log_warn "looknfeel.lua not found, skipping workspace config."
fi

# 4. Screensaver timeout to 3600s
SHELL_JSON="$HOME/.config/omarchy/shell.json"
if [ -f "$SHELL_JSON" ]; then
    sed -i 's/"screensaver": [0-9]*/"screensaver": 3600/' "$SHELL_JSON"
    log_info "Screensaver timeout set to 3600s (1 hour) in $SHELL_JSON"
fi

log_info "Omarchy system settings setup complete."

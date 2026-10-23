#!/bin/bash
# =============================================================================
# Omarchy System Settings Setup
# 1. Herdr Prefix to Ctrl+B
# 2. Stay Awake (Native Omarchy method)
# 3. Screensaver timeout to 1h
# 4. MacBook Trackpad: Three-finger drag (drag_3fg)
# =============================================================================

GREEN='\033[0;32m'
NC='\033[0m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "\033[1;33m[WARN]${NC} $1"; }

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

# 5. MacBook Trackpad: Enable three-finger drag
echo ""
log_info "Configuring MacBook trackpad three-finger drag..."
INPUT_LUA="$HOME/.config/hypr/input.lua"

# Backup existing input.lua
if [ -f "$INPUT_LUA" ]; then
    cp "$INPUT_LUA" "$INPUT_LUA.bak.$(date +%s)"
    log_info "Backed up existing input.lua"
fi

cat > "$INPUT_LUA" << 'LUA_EOF'
-- Keep only your personal input overrides here. Uncommented settings below
-- replace Omarchy's defaults.

-- Keyboard layout and options.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
  input = {
    -- Use multiple keyboard layouts and switch between them with Left Alt + Right Alt.
    kb_layout = "us",

    -- Increase sensitivity for mouse/trackpad (default: 0).
    sensitivity = 0.35,

    -- Turn off mouse acceleration (default: adaptive).
    accel_profile = "flat",

    touchpad = {
      -- Use natural (inverse) scrolling.
      natural_scroll = true,

      -- Use two-finger clicks for right-click instead of lower-right corner.
      clickfinger_behavior = true,

      -- Control the speed of your scrolling.
      scroll_factor = 0.4,

      -- Enable the touchpad while typing.
      disable_while_typing = false,

      -- Left-click-and-drag with three fingers (macOS-style three-finger drag).
      drag_3fg = 1,
    },
  },
})

-- App-specific touchpad scroll speeds.
-- o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
-- o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })

-- Enable touchpad gestures for changing workspaces.
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
-- hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Enable touchpad gestures for moving focus (helpful on scrolling layout).
-- hl.gesture({ fingers = 3, direction = "left", action = function() hl.dispatch(hl.dsp.focus({ direction = "l" })) end })
-- hl.gesture({ fingers = 3, direction = "right", action = function() hl.dispatch(hl.dsp.focus({ direction = "r" })) end })
LUA_EOF

log_info "Trackpad config written to $INPUT_LUA"

# Reload Hyprland configuration
if command -v hyprctl &> /dev/null; then
    hyprctl reload
    if hyprctl configerrors 2>&1 | grep -q "error"; then
        log_warn "Hyprland config has errors. Please check $INPUT_LUA"
    else
        log_info "Hyprland config reloaded successfully. No errors."
    fi
else
    log_warn "hyprctl not found. Skipping Hyprland reload."
fi

log_info "Three-finger drag configured. Three fingers on trackpad = drag."

log_info "Omarchy system settings setup complete."

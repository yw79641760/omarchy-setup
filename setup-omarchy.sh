#!/bin/bash
# =============================================================================
# Omarchy System Settings Setup
# Configures Herdr prefix and Idle timeouts
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

# 2. Idle Timeout Configuration (1 Hour Screensaver)
log_info "Configuring 1-hour screensaver timeout..."

# 确保 hypridle 存在
if ! command -v hypridle &> /dev/null; then
    sudo pacman -S --needed --noconfirm hypridle
fi

mkdir -p "$HOME/.config/hypr/"
cat > "$HOME/.config/hypr/hypridle.conf" << EOF
general {
    lock_cmd = pidof hyprlock || hyprlock
    before_sleep_cmd = loginctl lock-session
    after_sleep_cmd = hyprctl dispatch dpms on
}

listener {
    timeout = 3600 # 1 hour
    on-timeout = loginctl lock-session
}
EOF

# 确保 hypridle 随 Hyprland 启动
# 在 Omarchy 中，通常通过 hyprland.lua 或 autostart.lua 处理
if [ -f "$HOME/.config/hypr/autostart.lua" ]; then
    if ! grep -q "hypridle" "$HOME/.config/hypr/autostart.lua"; then
        echo 'os.execute("hypridle &")' >> "$HOME/.config/hypr/autostart.lua"
        log_info "Added hypridle to autostart.lua"
    fi
fi

# 立即启动以生效
pgrep hypridle && killall hypridle
hypridle &

log_info "Screensaver timeout set to 1 hour."
log_info "Omarchy system settings setup complete."

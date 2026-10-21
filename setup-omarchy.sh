#!/bin/bash
# =============================================================================
# Omarchy System Settings Setup
# 1. Herdr Prefix to Ctrl+B
# 2. Prevent sleep/suspend while plugged in (systemd-inhibit)
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

# 2. Native Omarchy Power Management (1 Hour Screensaver)
log_info "Configuring 1-hour screensaver timeout..."
SHELL_JSON="$HOME/.config/omarchy/shell.json"
if [ -f "$SHELL_JSON" ]; then
    sed -i 's/"screensaver": [0-9]*/"screensaver": 3600/' "$SHELL_JSON"
    log_info "Screensaver timeout set to 3600s (1 hour)."
fi

# 3. Persistent Inhibit (Never suspend/sleep)
log_info "Enabling persistent sleep inhibition..."
INHIBIT_SERVICE="$HOME/.config/systemd/user/omarchy-inhibit-sleep.service"
mkdir -p "$(dirname "$INHIBIT_SERVICE")"

cat > "$INHIBIT_SERVICE" << EOF
[Unit]
Description=Inhibit sleep while plugged in
After=graphical-session.target

[Service]
Type=simple
ExecStart=systemd-inhibit --what=sleep --who="Omarchy Setup" --why="Prevent sleep while plugged in" sleep infinity
Restart=always

[Install]
WantedBy=graphical-session.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now omarchy-inhibit-sleep.service

log_info "System will now prevent sleep but trigger screensaver after 1 hour."
log_info "Omarchy system settings complete."

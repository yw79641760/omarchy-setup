#!/bin/bash
# =============================================================================
# Application Setup Script
# Installs common applications and configures services/plugins
# =============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0;m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

echo "=========================================="
echo " Applications Setup"
echo "=========================================="

# ==========================================
# Install System Packages (pacman)
# ==========================================
log_info "Installing system packages via pacman..."

SYSTEM_PKGS="google-chrome feishu tailscale blueman visual-studio-code-bin"

# Check each package
for pkg in $SYSTEM_PKGS; do
    if pacman -Si "$pkg" &>/dev/null; then
        log_info "Installing $pkg from pacman..."
        sudo pacman -S --needed --noconfirm "$pkg" || log_warn "$pkg may already be installed or unavailable"
    else
        log_warn "Package $pkg may be AUR-only"
    fi
done

# ==========================================
# Install AUR Packages (yay)
# ==========================================
log_info "Installing AUR packages via yay..."

AUR_PKGS="clash-verge-rev-bin oh-my-pi-bin wakatime bitwarden dropbox-cli"

for pkg in $AUR_PKGS; do
    log_info "Attempting to install $pkg..."
    yay -S --noconfirm "$pkg" || log_warn "$pkg may already be installed or unavailable"
done

# ==========================================
# Enable Plugins
# ==========================================
log_info "Enabling Omarchy plugins..."

omarchy plugin enable dropbox 2>/dev/null || log_warn "Could not enable dropbox plugin"
omarchy plugin enable tailscale 2>/dev/null || log_warn "Could not enable tailscale plugin"

# Check plugin status
omarchy plugin list 2>/dev/null | grep -E "dropbox|tailscale" || log_info "Plugin status check complete"

# ==========================================
# Initialize Services
# ==========================================
log_info "Initializing services..."

# Initialize Dropbox
if command -v dropbox-cli &> /dev/null; then
    log_info "Initializing Dropbox..."
    dropbox-cli autostart y
    dropbox-cli start
    if dropbox-cli running; then
        log_info "Dropbox is running: $(dropbox-cli status)"
    else
        log_warn "Dropbox failed to start. Please authenticate via web."
    fi
else
    log_warn "dropbox-cli not found, skipping initialization."
fi

# Initialize Tailscale
if command -v tailscale &> /dev/null; then
    log_info "Initializing Tailscale..."
    tailscale whoami
    log_info "Bringing up Tailscale (this may prompt for login)..."
    sudo tailscale up || log_warn "Tailscale up failed, please run manually."
    tailscale status
else
    log_warn "tailscale not found, skipping initialization."
fi

# ==========================================
# Summary
# ==========================================
echo ""
echo "=========================================="
echo " Application Setup Complete!"
echo "=========================================="
echo ""
echo "Installed Applications:"
echo "  - Google Chrome"
echo "  - Feishu"
echo "  - Visual Studio Code"
echo "  - Dropbox + CLI"
echo "  - Tailscale"
echo "  - Blueman (Bluetooth Manager)"
echo "  - Clash Verge Rev (AUR)"
echo "  - Oh My Pi (AUR)"
echo "  - WakaTime (AUR)"
echo ""
echo "Services Enabled:"
echo "  - dropbox"
echo "  - tailscale"
echo "  - bitwarden"
echo ""
echo "Plugins Enabled:"
echo "  - dropbox"
echo "  - tailscale"
echo ""
log_info "Run 'reboot' to complete setup if prompted."
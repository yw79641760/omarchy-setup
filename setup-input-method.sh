#!/bin/bash
# =============================================================================
# Input Method Setup (Fcitx5 + Rime Ice)
# =============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

echo "=========================================="
echo " Input Method Setup (Fcitx5 + Rime Ice)"
echo "=========================================="

# 1. Install core Fcitx5 packages
log_info "Installing Fcitx5 core packages..."
sudo pacman -S --noconfirm fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-rime
log_info "✅ Fcitx5 core packages installed."

# 2. Install rime-ice via yay
log_info "Installing rime-ice-git via yay..."
yay -S --noconfirm rime-ice-git
log_info "✅ rime-ice-git installed."

# 3. Omarchy package additions
# Using a fallback if 'omarchy pkg add' is not the exact command, 
# but following the user's provided command.
log_info "Adding Omarchy packages..."
omarchy pkg add fcitx5-chinese-addons || log_warn "omarchy pkg add fcitx5-chinese-addons failed"
omarchy pkg add fcitx5-configtool || log_warn "omarchy pkg add fcitx5-configtool failed"
log_info "✅ Omarchy packages processed."

# 4. Launch configuration tool
echo ""
echo "-------------------------------------------------------------------"
echo "FINAL STEP: MANUAL CONFIGURATION"
echo "-------------------------------------------------------------------"
echo "The Fcitx5 Configuration Tool will now open."
echo "Please add 'Pinyin' (or 'Rime') manually into your current input methods."
echo ""

# Launch the tool. Using '&' to let the script finish, 
# or just running it and waiting for user to close it.
fcitx5-configtool

echo ""
log_info "Input method setup procedure complete."
echo "Please restart your session or run 'fcitx5 -d' to start the daemon."
echo "=========================================="

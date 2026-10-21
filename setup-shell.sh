#!/bin/bash
# =============================================================================
# Shell Configuration Script
# Configures shell-specific tools like 'mise' for toolchain management
# =============================================================================

GREEN='\033[0;32m'
NC='\033[0m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }

echo "=========================================="
echo " Shell Configuration"
echo "=========================================="

# ------------------------------------------
# Add mise integration to ~/.bashrc
# ------------------------------------------
if ! grep -q "mise activate bash" "$HOME/.bashrc"; then
    cat >> "$HOME/.bashrc" << 'MISE_EOF'

# Enable mise for development tool management
if command -v mise &> /dev/null; then
    eval "$(mise activate bash)"
fi
MISE_EOF
    log_info "Added 'mise' shell integration to ~/.bashrc"
else
    log_info "'mise' shell integration already present in ~/.bashrc"
fi

log_info "Shell configuration complete."

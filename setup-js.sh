#!/bin/bash
# =============================================================================
# Node.js Development Environment Setup (Aliyun NPM/PNPM Registry)
# Usage: ./setup-js.sh
# =============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

echo "=========================================="
echo " Node.js/JS Setup (Aliyun NPM Registry)"
echo "=========================================="

# ------------------------------------------
# Update ~/.bashrc
# ------------------------------------------
if ! grep -q "NPM_CONFIG_REGISTRY" "$HOME/.bashrc"; then
    echo "" >> "$HOME/.bashrc"
    echo "# Node.js/NPM Configuration" >> "$HOME/.bashrc"
    echo "export NPM_CONFIG_REGISTRY=\"https://registry.npmmirror.com/\"" >> "$HOME/.bashrc"
    log_info "Added Node.js/NPM environment variables to ~/.bashrc"
fi

# ------------------------------------------
# npm configuration
# ------------------------------------------
log_info "Configuring npm registry to Aliyun mirror..."

npm config set registry https://registry.npmmirror.com/
log_info "npm registry set to registry.npmmirror.com"

# Verify
NPM_REG=$(npm config get registry)
log_info "Current npm registry: $NPM_REG"

# ------------------------------------------
# pnpm configuration
# ------------------------------------------
log_info "Configuring pnpm..."

mkdir -p "$HOME/.config"
cat > "$HOME/.config/pnpmrc" << 'PNPM_EOF'
registry = https://registry.npmmirror.com/
store-dir = ~/.local/share/pnpm/store
shamefully-installable = false
child-pipelines = false
PNPM_EOF
log_info "pnpm config written to ~/.config/pnpmrc"

# ------------------------------------------
# Node detection
# ------------------------------------------
if command -v node &> /dev/null; then
    log_info "Node version: $(node --version)"
    log_info "npm version: $(npm --version)"
else
    log_warn "Node.js not found. Install with: sudo pacman -S nodejs npm"
fi

if command -v pnpm &> /dev/null; then
    log_info "pnpm version: $(pnpm --version)"
else
    log_warn "pnpm not found. Install with: npm install -g pnpm"
fi

# ------------------------------------------
# yarn support (optional)
# ------------------------------------------
if command -v yarn &> /dev/null; then
    yarn config set registry https://registry.npmmirror.com/
    log_info "yarn registry set to npmmirror.com"
fi

log_info "Node.js/JS setup complete."

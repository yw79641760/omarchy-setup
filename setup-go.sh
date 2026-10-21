#!/bin/bash
# =============================================================================
# Go Development Environment Setup (Aliyun Go Proxy)
# Usage: ./setup-go.sh
# =============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
log_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }

echo "=========================================="
echo " Go Setup (Go Proxy + Aliyun)"
echo "=========================================="

# ------------------------------------------
# Go module proxy configuration
# ------------------------------------------
export GOPROXY="https://goproxy.cn,direct"
export GOSUMDB="sum.golang.org"

# Prompt for update .bashrc
read -p "Add GOPROXY to ~/.bashrc? [y/N]: " add_bash
if [[ "$add_bash" =~ ^[Yy]$ ]]; then
    grep -q 'export GOPROXY="https://goproxy.cn' "$HOME/.bashrc" 2>/dev/null || \
        echo 'export GOPROXY="https://goproxy.cn,direct"' >> "$HOME/.bashrc"
    grep -q 'export GOSUMDB="sum.golang.org"' "$HOME/.bashrc" 2>/dev/null || \
        echo 'export GOSUMDB="sum.golang.org"' >> "$HOME/.bashrc"
    log_info "GOPROXY variables added to ~/.bashrc"
fi

# Create Go environment helper file
mkdir -p "$HOME/.config"
cat > "$HOME/.config/goenv" << 'GO_EOF'
export GOPROXY=https://goproxy.cn,direct
export GOSUMDB=sum.golang.org
export GONOSUMDB=github.com/xxx/*
GO_EOF

log_info "Config written to ~/.config/goenv"

# ------------------------------------------
# Go detection
# ------------------------------------------
if command -v go &> /dev/null; then
    log_info "Go version: $(go version)"
    log_info "GOPATH: $(go env GOPATH)"
else
    log_warn "Go not found. Install with: sudo pacman -S go"
fi

log_info "Go setup complete."

#!/bin/bash
# =============================================================================
# Rust Development Environment Setup (Aliyun Crates Mirror)
# Usage: ./setup-rust.sh
# =============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
log_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }

echo "=========================================="
echo " Rust Setup (Cargo + Aliyun Crates)"
echo "=========================================="

# ------------------------------------------
# Cargo mirror: ~/.cargo/config.toml
# ------------------------------------------
mkdir -p "$HOME/.cargo"

# Preserve existing aliases if config already exists
if [ -f "$HOME/.cargo/config.toml" ]; then
    cp "$HOME/.cargo/config.toml" "$HOME/.cargo/config.toml.bak.$(date +%s)"
    log_warn "Existing ~/.cargo/config.toml backed up"
fi

cat > "$HOME/.cargo/config.toml" << 'CARGO_EOF'
[net]
git-fetch-with-cli = true

[registry]
default = "crates-io"

# Route crates.io through the Aliyun sparse mirror
[source.crates-io]
replace-with = "aliyun"

[source.aliyun]
registry = "sparse+https://mirrors.aliyun.com/crates.io-index/"

[alias]
r = "run"
b = "build"
t = "test"
c = "check"
CARGO_EOF
log_info "Cargo mirror configured ( ~/.cargo/config.toml )"

# ------------------------------------------
# Update ~/.bashrc
# ------------------------------------------
if ! grep -q "RUSTUP_DIST_SERVER" "$HOME/.bashrc"; then
    echo "" >> "$HOME/.bashrc"
    echo "# Rust Configuration" >> "$HOME/.bashrc"
    echo "export RUSTUP_DIST_SERVER=\"https://mirrors.ustc.edu.cn/rust-static\"" >> "$HOME/.bashrc"
    echo "export RUSTUP_UPDATE_ROOT=\"https://mirrors.ustc.edu.cn/rust-static/rustup\"" >> "$HOME/.bashrc"
    log_info "Added Rust environment variables to ~/.bashrc"
fi

log_info "Rust setup complete."

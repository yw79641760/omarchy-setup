#!/bin/bash
# =============================================================================
# Main Setup Orchestration Script
# Runs all setup scripts in sequence
# =============================================================================

set -e

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo "=========================================="
echo " Omni Setup Orchestrator"
echo "=========================================="
echo ""

run_script() {
    local name=$1
    local script="$SCRIPTS_DIR/$name.sh"
    echo ""
    log_info "Running: $name"
    echo "----------------------------------------"
    if [ -x "$script" ]; then
        bash "$script"
    else
        log_error "Script not found or not executable: $script"
        return 1
    fi
}

# ==========================================
# 1. Pi Agent Bootstrap
# ==========================================
run_script "setup-agent"

# ==========================================
# 2. Application Setup
# ==========================================
run_script "setup-apps"

# ==========================================
# 3. Input Method Setup
# ==========================================
run_script "setup-input-method"

# ==========================================
# 4. Shell Configuration
# ==========================================
run_script "setup-shell"

# ==========================================
# 5. SSH Key Setup
# ==========================================
run_script "setup-ssh-keygen"

# ==========================================
# 5. Git Setup
# ==========================================
run_script "setup-git"

# ==========================================
# 6. Cloudflare Setup
# ==========================================
run_script "setup-cloudflare"

# ==========================================
# 7. Development Language Choice
# ==========================================
# Note: setup-dev-lang.sh is interactive and prompts user for language selection
run_script "setup-dev-lang"

# ==========================================
# Summary
# ==========================================
echo ""
echo "=========================================="
echo "         ALL SETUPS COMPLETE!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.bashrc"
echo "  2. Verify installations: python3 --version, node -v, etc."
echo "  3. For Pi agent: ~/dev/omarchy_setup/setup-agent.sh"
echo ""
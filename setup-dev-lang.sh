#!/bin/bash
# =============================================================================
# Interactive Development Environment Setup Orchestrator
# Allows user to choose which language environments to configure
# =============================================================================
set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ------------------------------------------------------------------
# Helper: show menu and get user choices
# ------------------------------------------------------------------
echo "=========================================="
echo "Development Environment Setup"
echo "Platform: $(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d'"' -f2 || echo 'Unknown')"
echo "=========================================="
echo ""
echo "Which language environments would you like to set up?"
echo "You can select multiple by entering numbers separated by spaces (e.g., '1 3 5')"
echo "Or type 'all' to set up everything."
echo ""
echo "  [1] Java         - Maven/Gradle mirrors (aliyun)"
echo "  [2] Rust         - Cargo crates mirror (aliyun)"
echo "  [3] Go           - Go module proxy (goproxy.cn)"
echo "  [4] Python       - PyPI mirror (aliyun)"
echo "  [5] JavaScript   - npm/pnpm registry (npmmirror)"
echo "  [6] All of the above"
echo ""

read -p "Selection (1-6 or 'all'): " choice

# ------------------------------------------------------------------
# Normalize selection
# ------------------------------------------------------------------
cases () {
    case "$1" in
        1) $SCRIPT_DIR/setup-java.sh ;;
        2) $SCRIPT_DIR/setup-rust.sh ;;
        3) $SCRIPT_DIR/setup-go.sh ;;
        4) $SCRIPT_DIR/setup-python.sh ;;
        5) $SCRIPT_DIR/setup-js.sh ;;
        *) echo "${RED}[ERROR]${NC} Invalid choice: $1"; return 1 ;;
    esac
}

# Execute based on choice
if [ "$choice" = "all" ]; then
    echo "${GREEN}[INFO]${NC} Setting up all environments..."
    $SCRIPT_DIR/setup-java.sh
    $SCRIPT_DIR/setup-rust.sh
    $SCRIPT_DIR/setup-go.sh
    $SCRIPT_DIR/setup-python.sh
    $SCRIPT_DIR/setup-js.sh
else
    IFS=' ' read -ra selections <<< "$choice"
    for sel in "${selections[@]}"; do
        cases "$sel"
    done
fi

echo ""
echo "${GREEN}==========================================${NC}"
echo " ${GREEN}Bootstrap Complete!${NC}"
echo " ${GREEN}==========================================${NC}"
echo ""
echo "Next steps:"
echo "  1. Run: source ~/.bashrc"
echo "  2. Source your terminal or run: $PATH to ./setup-dev-environment.sh"
echo "  3. Tools are ready for use!"
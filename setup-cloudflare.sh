#!/bin/bash
# =============================================================================
# Cloudflare Development Setup
# Interactive configuration for Wrangler CLI and Cloudflare auth
# =============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0;33m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

echo "=========================================="
echo "Cloudflare Development Setup"
echo "=========================================="

# ------------------------------------------
# Check for npm (required for wrangler)
# ------------------------------------------
if ! command -v npm &> /dev/null; then
    log_warn "npm not found. Install Node.js first!"
    exit 1
fi

log_info "npm found: $(npm --version)"

# ------------------------------------------
# Install Wrangler CLI
# ------------------------------------------
read -p "Install Wrangler CLI via npm? [y/N]: " install_wrapper

if [[ "$install_wrapper" =~ ^[Yy]$ ]]; then
    npm install -g wrangler
    log_info "Wrangler CLI installed"
else
    log_warn "Skipping Wrangler CLI installation"
fi

# Verify installation
if command -v wrangler &> /dev/null; then
    log_info "Wrangler version: $(wrangler --version)"
else
    log_warn "Wrangler not found in PATH. Try: npm install -g wrangler"
fi

# ------------------------------------------
# Cloudflare Account Name
# ------------------------------------------
echo ""
echo "----------------------------------------"
echo " Wrangler Authentication Setup"
echo "----------------------------------------"

read -p "Enter your Cloudflare account name (API token will be created): " cf_account_name

if [ -n "$cf_account_name" ]; then
    echo ""
    echo "Opening browser for Cloudflare API token creation..."
    echo "Please create a token with the following permissions:"
    echo "  - Account: Cloudflare Workers:Edit"
    echo "  - Zone: Workers Routes:Edit"
    echo ""

    read -p "Press Enter to continue with Wrangler login..."

    # wrangler login is the standard way to authenticate in Wrangler v3+
    log_info "Launching Wrangler login..."
    wrangler login

    log_info "Wrangler authentication configured."
    fi
else
    log_warn "Skipping Cloudflare authentication. Run 'wrangler login' manually."
fi

# ------------------------------------------
# Optional: Verify setup
log_info "Verifying Wrangler setup..."
wrangler whoami 2>/dev/null || log_warn "Run 'wrangler login' to authenticate"

echo ""
log_info "Cloudflare setup complete!"
echo "Useful commands:"
echo "  wrangler dev        - Local development server"
echo "  wrangler deploy     - Deploy the worker"
echo "  wrangler tail       - Follow logs"
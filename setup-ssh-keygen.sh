#!/bin/bash
# =============================================================================
# SSH Key Setup Script
# Interactive setup for generating SSH keys
# =============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

echo "=========================================="
echo "SSH Key Setup"
echo "=========================================="

# ------------------------------------------
# Check if SSH key already exists
# ------------------------------------------
if [ -f "$HOME/.ssh/id_rsa.pub" ]; then
    echo ""
    echo "SSH public key already exists at ~/.ssh/id_rsa.pub"
    echo "Fingerprint: $(ssh-keygen -l -f "$HOME/.ssh/id_rsa.pub" 2>/dev/null || echo 'N/A')"
    read -p "Generate new key? (this will overwrite existing) [y/N]: " overwrite
    if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
        log_info "SSH key setup skipped. Existing key will be used."
        cat "$HOME/.ssh/id_rsa.pub"
        exit 0
    fi
fi

# ------------------------------------------
# Interactive SSH key generation
# ------------------------------------------
echo ""
echo "Generating SSH key pair..."
echo "You will be prompted for:"
echo "  - File name (press Enter for default 'id_rsa')"
echo "  - Passphrase (optional, but recommended for security)"
echo ""

# Run ssh-keygen with rsa
ssh-keygen -t rsa -b 4096

# ------------------------------------------
# Show the public key
# ------------------------------------------
if [ -f "$HOME/.ssh/id_rsa.pub" ]; then
    echo ""
    echo "=========================================="
    echo "Your SSH Public Key:"
    echo "=========================================="
    cat "$HOME/.ssh/id_rsa.pub"
    echo ""
    log_info "SSH key pair generated successfully!"
    log_info "Public key location: ~/.ssh/id_rsa.pub"
    log_info "Private key location: ~/.ssh/id_rsa"
    echo ""
    echo "Copy the public key above to your GitHub/GitLab/etc. account:"
    echo "  GitHub:  https://github.com/settings/keys"
    echo "  GitLab:  https://gitlab.com/-/profile/keys"
else
    log_warn "SSH key generation failed."
fi
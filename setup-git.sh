#!/bin/bash
# =============================================================================
# Git Development Setup
# Interactive configuration for Git username/email and GitHub CLI setup
# =============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

echo "=========================================="
echo " Git Development Setup"
echo "=========================================="

# ------------------------------------------
# Interactive Git config
# ------------------------------------------
echo ""
echo "Configuring Git identity..."

read -p "Enter your Git username: " git_username
read -p "Enter your Git email: " git_email

if [ -n "$git_username" ] && [ -n "$git_email" ]; then
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
    log_info "Git identity configured:"
    log_info "  Username: $(git config --global user.name)"
    log_info "  Email:    $(git config --global user.email)"
else
    log_warn "Skipping Git config (empty values)"
fi

# ------------------------------------------
# Install GitHub CLI
# ------------------------------------------
echo ""
read -p "Install GitHub CLI (gh)? [y/N]: " install_gh

if [[ "$install_gh" =~ ^[Yy]$ ]]; then
    if command -v yay &> /dev/null; then
        yay -S --noconfirm github-cli || log_warn "GitHub CLI installation failed or already installed"
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm github-cli || log_warn "GitHub CLI installation failed or already installed"
    else
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update && sudo apt install gh || log_warn "GitHub CLI installation failed"
    fi

    if command -v gh &> /dev/null; then
        log_info "GitHub CLI installed: $(gh --version | head -1)"

        echo ""
        echo "============================================================"
        echo " GitHub Authentication Setup"
        echo "============================================================"
        echo ""
        echo "The 'gh auth login' command will open a browser for authentication."
        echo ""

        read -p "Start GitHub authentication now? [Y/n]: " auth_now
        if [[ ! "$auth_now" =~ ^[Nn]$ ]]; then
            gh auth login
            log_info "GitHub authentication complete!"
        else
            log_warn "Skipping GitHub authentication. Run 'gh auth login' later manually."
        fi
    else
        log_warn "GitHub CLI not found. Manual install may be required."
    fi
else
    log_info "Skipping GitHub CLI installation."
fi

# ------------------------------------------
# Summary
# ------------------------------------------
log_info "Git setup complete!"
echo ""
echo "Configured values:"
echo "  user.name  = $(git config --global user.name || echo 'not set')"
echo "  user.email = $(git config --global user.email || echo 'not set')"
echo ""
if command -v gh &> /dev/null; then
    echo "  GitHub CLI: $(gh --version 2>/dev/null | head -1)"
fi
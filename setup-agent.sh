#!/bin/bash
# =============================================================================
# Pi Agent Bootstrap Script
# Interactive setup for pi agent with LiteLLM provider configuration
# =============================================================================

GREEN='\033[0;32m'
NC='\033[0m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

if ! command -v yay &> /dev/null; then
    echo "Error: yay not installed. Please install yay first."
    exit 1
fi

set -e

echo "========================================="
echo "Pi Agent Bootstrap Setup"
echo "========================================="
echo ""

# -----------------------------------------------------------------------------
# Step 1: Install pi agent
# -----------------------------------------------------------------------------
log_info "Step 1: Installing pi agent..."
yay -S pi --noconfirm
log_info "✅ pi agent installed."
echo ""

# -----------------------------------------------------------------------------
# Step 2: Install pi-provider-litellm plugin
# -----------------------------------------------------------------------------
log_info "Step 2: Installing pi-provider-litellm plugin..."
pi install npm:pi-provider-litellm
log_info "✅ pi-provider-litellm plugin installed."
echo ""

# -----------------------------------------------------------------------------
# Step 3: Create ~/.pi/agent/models.json
# -----------------------------------------------------------------------------
log_info "Step 3: Creating models.json template..."
mkdir -p "$HOME/.pi/agent"

cat > "$HOME/.pi/agent/models.json" << 'EOF'
{
  "providers": {
    "litellm": {
      "baseUrl": "$LITELLM_BASE_URL",
      "api": "openai-completions",
      "apiKey": "$LITELLM_API_KEY",
      "headers": {
        "CF-Access-Client-Id": "$LITELLM_CF_CLIENT_ID",
        "CF-Access-Client-Secret": "$LITELLM_CF_CLIENT_SECRET"
      }
    }
  }
}
EOF
log_info "✅ models.json created with placeholder values."
echo ""

# -----------------------------------------------------------------------------
# Step 4: Interactive configuration - fill in LiteLLM values
# -----------------------------------------------------------------------------
log_info "Step 4: Configuring LiteLLM credentials..."
echo "Please provide the following LiteLLM configuration values:"
echo "(You can press Enter to accept the defaults shown in brackets)"
echo ""

read -p "LITELLM_BASE_URL [https://ai-api.example.com]: " LITELLM_BASE_URL
LITELLM_BASE_URL="${LITELLM_BASE_URL:-https://ai-api.example.com}"

read -p "LITELLM_API_KEY [sk-xxxx]: " LITELLM_API_KEY
LITELLM_API_KEY="${LITELLM_API_KEY:-sk-xxxx}"

read -p "LITELLM_CF_CLIENT_ID [xxxx.access]: " LITELLM_CF_CLIENT_ID
LITELLM_CF_CLIENT_ID="${LITELLM_CF_CLIENT_ID:-xxxx.access}"

read -p "LITELLM_CF_CLIENT_SECRET [cfast_xxxx]: " LITELLM_CF_CLIENT_SECRET
LITELLM_CF_CLIENT_SECRET="${LITELLM_CF_CLIENT_SECRET:-cfast_xxxx}"

BASHRC="$HOME/.bashrc"

# Append export lines to ~/.bashrc only if they are not already present
echo "Checking ~/.bashrc for existing LiteLLM configuration..."

if ! grep -q "^export LITELLM_BASE_URL" "$BASHRC" 2>/dev/null; then
    {
        echo ""
        echo "# LiteLLM Configuration (added by pi bootstrap)"
        echo "export LITELLM_BASE_URL=\"$LITELLM_BASE_URL\""
        echo "export LITELLM_API_KEY=\"$LITELLM_API_KEY\""
        echo "export LITELLM_CF_CLIENT_ID=\"$LITELLM_CF_CLIENT_ID\""
        echo "export LITELLM_CF_CLIENT_SECRET=\"$LITELLM_CF_CLIENT_SECRET\""
    } >> "$BASHRC"
    log_info "✅ LiteLLM configuration appended to $BASHRC"
else
    log_warn "⚠️ LiteLLM configuration already present in $BASHRC. Skipping append."
fi
echo ""

# -----------------------------------------------------------------------------
# Step 5: Source ~/.bashrc
# -----------------------------------------------------------------------------
log_info "Step 5: Sourcing ~/.bashrc..."
source "$BASHRC"
log_info "✅ ~/.bashrc sourced successfully."
echo ""

# -----------------------------------------------------------------------------
# Step 6: Update models.json with actual values
# -----------------------------------------------------------------------------
log_info "Step 6: Updating models.json with real values..."
cat > "$HOME/.pi/agent/models.json" << EOF
{
  "providers": {
    "litellm": {
      "baseUrl": "$LITELLM_BASE_URL",
      "api": "openai-completions",
      "apiKey": "\\$LITELLM_API_KEY",
      "headers": {
        "CF-Access-Client-Id": "\\$LITELLM_CF_CLIENT_ID",
        "CF-Access-Client-Secret": "\\$LITELLM_CF_CLIENT_SECRET"
      }
    }
  }
}
EOF
log_info "✅ models.json updated with real values."
echo ""

# -----------------------------------------------------------------------------
# Step 7: Start pi in non-interactive mode
# -----------------------------------------------------------------------------
log_info "Step 7: Starting pi in non-interactive mode..."
pi -p "hello world"
log_info "✅ Pi agent started."
echo ""

# -----------------------------------------------------------------------------
# Step 8: Install AI skills for enhanced capabilities
# -----------------------------------------------------------------------------
log_info "Step 8: Installing AI skills..."

log_info "Installing find-skills from Vercel Labs..."
npx skills add https://github.com/vercel-labs/skills --skill find-skills
log_info "✅ find-skills installed."

log_info "Installing agent-browser from Vercel Labs..."
npx skills add https://github.com/vercel-labs/agent-browser --skill agent-browser
log_info "✅ agent-browser installed."
echo ""

echo "========================================="
echo "Bootstrap complete! Pi agent is ready."
echo "========================================="

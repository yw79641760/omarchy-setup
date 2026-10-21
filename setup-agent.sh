#!/bin/bash

if ! command -v yay #!/bin/bash> /dev/null; then echo "Error: yay not installed"; exit 1; fi
# =============================================================================
# Pi Agent Bootstrap Script
# Interactive setup for pi agent with LiteLLM provider configuration
# =============================================================================

set -e

echo "========================================="
echo "Pi Agent Bootstrap Setup"
echo "========================================="
echo ""

# -----------------------------------------------------------------------------
# Step 1: Interactive configuration - fill in LiteLLM values
# -----------------------------------------------------------------------------
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
    echo "✅ LiteLLM configuration appended to $BASHRC"
else
    echo "⚠️ LiteLLM configuration already present in $BASHRC. Skipping append."
fi

# -----------------------------------------------------------------------------
# Step 2: Source ~/.bashrc
# -----------------------------------------------------------------------------
echo ""
echo "Sourcing ~/.bashrc to apply changes..."
source "$BASHRC"
echo "✅ ~/.bashrc sourced successfully."
echo ""

# -----------------------------------------------------------------------------
# Step 3: Install pi agent
# -----------------------------------------------------------------------------
echo "Installing pi agent via yay..."
yay -S pi
echo "✅ pi agent installed."
echo ""

# -----------------------------------------------------------------------------
# Step 4: Install pi-provider-litellm plugin
# -----------------------------------------------------------------------------
echo "Installing pi-provider-litellm plugin..."
pi install npm:pi-provider-litellm
echo "✅ pi-provider-litellm plugin installed."
echo ""

# -----------------------------------------------------------------------------
# Step 5: Create ~/.pi/agent/models.json
# -----------------------------------------------------------------------------
echo "Creating ~/.pi/agent/models.json configuration file..."
mkdir -p "$HOME/.pi/agent"

# Note: $LITELLM_BASE_URL is expanded to the real value here because pi
# cannot render it from env vars. apiKey/headers are kept as literal $VAR
# references — pi renders those from the environment at runtime.
cat > "$HOME/.pi/agent/models.json" <<EOF
{
  "providers": {
    "litellm": {
      "baseUrl": "$LITELLM_BASE_URL",
      "api": "openai-completions",
      "apiKey": "\$LITELLM_API_KEY",
      "headers": {
        "CF-Access-Client-Id": "\$LITELLM_CF_CLIENT_ID",
        "CF-Access-Client-Secret": "\$LITELLM_CF_CLIENT_SECRET"
      }
    }
  }
}
EOF

echo "✅ ~/.pi/agent/models.json created."
echo ""

# -----------------------------------------------------------------------------
# Step 6: Start pi with "hello world" greetings
# -----------------------------------------------------------------------------
echo "Starting pi with hello world greetings..."
pi "hello world"
echo ""

# -----------------------------------------------------------------------------
# Step 7: Install AI skills for enhanced capabilities
# -----------------------------------------------------------------------------
echo "Installing AI skills for enhanced capabilities..."

echo "Installing find-skills from Vercel Labs..."
npx skills add https://github.com/vercel-labs/skills --skill find-skills
echo "✅ find-skills installed."

echo "Installing agent-browser from Vercel Labs..."
npx skills add https://github.com/vercel-labs/agent-browser --skill agent-browser
echo "✅ agent-browser installed."

echo ""
echo "========================================="
echo "Bootstrap complete! Pi agent is ready."
echo "========================================="
# Dev Setup Scripts for Omarchy

A collection of automated setup scripts for development environments on Omarchy (Arch-based Linux).

## 📁 Directory Structure

```
~/dev/omarchy-setup/
├── setup.sh                  🏁 Main orchestrator (runs all in order)
├── setup-agent.sh            🤖 Pi agent bootstrap (LiteLLM + skills)
├── setup-apps.sh             📦 Applications (Chrome, Feishu, Dropbox, Tailscale, Clash, WakaTime)
├── setup-cloudflare.sh       ☁️ Cloudflare (Wrangler CLI + auth)
├── setup-dev-lang.sh          🌐 Interactive language dev env selector (Java/Rust/Go/Python/JS)
├── setup-git.sh              📝 Git identity + GitHub CLI
├── setup-shell.sh            🐚 Shell configuration (mise integration)
├── setup-input-method.sh     ⌨️ Fcitx5 + Rime Ice input methods
├── setup-ssh-keygen.sh       🔑 SSH RSA key generation
├── setup-java.sh             ☕ Java + Maven/Gradle Aliyun mirrors
├── setup-rust.sh             🦀 Rust + Aliyun Cargo mirrors
├── setup-go.sh               🐹 Go + goproxy.cn
├── setup-python.sh           🐍 Python + PyPI Aliyun mirror
└── setup-js.sh               📦 Node.js + npmregistry
```

## 🚀 Usage

### Full Setup (Recommended)
```bash
# Run the orchestrator - executes all scripts in order
~/dev/omarchy-setup/setup.sh
```

### Selective Setup
```bash
# Language environments (interactive selector)
~/dev/omarchy-setup/setup-dev-lang.sh

# Pi agent only
~/dev/omarchy-setup/setup-agent.sh

# Git + SSH keys
~/dev/omarchy-setup/setup-git.sh
~/dev/omarchy-setup/setup-ssh-keygen.sh

# Input methods
~/dev/omarchy-setup/setup-input-method.sh

# Applications
~/dev/omarchy-setup/setup-apps.sh

# Cloudflare
~/dev/omarchy-setup/setup-cloudflare.sh
```

## 🌐 Language Environments

Each language script configures:

| Language | Script | Mirrors |
|----------|--------|---------|
| **Java** | `setup-java.sh` | Maven Central, Spring, Google via Aliyun |
| **Rust** | `setup-rust.sh` | Crates.io via Aliyun sparse registry |
| **Go** | `setup-go.sh` | goproxy.cn mirror |
| **Python** | `setup-python.sh` | PyPI via Aliyun |
| **JavaScript** | `setup-js.sh` | npmregistry (Taobao) |

### Developer Setup Flow

1. **Dev Environment Selector** (`setup-dev-lang.sh`)
   - Prompts: "Which language environments would you like to set up?"
   - Select from: Java, Rust, Go, Python, Node.js, or All
   - Sets up appropriate mirrors and environment variables

2. **Migrates Projects** (from original setup script)
   - Creates `~/projects/` with organized subdirectories for each language
   - Includes README with mirror documentation

## 🔧 Configuration Files

Scripts create configuration files in standard locations:

| Service | Config File |
|---------|-------------|
| Maven | `~/.m2/settings.xml` |
| Gradle | `~/.gradle/init.gradle` |
| Cargo | `~/.cargo/config.toml` |
| pip | `~/.config/pip/pip.conf` |
| pnpm | `~/.config/pnpmrc` |
| Go | Environment variables in shell |

## 🤖 Pi Agent Setup (`setup-agent.sh`)

Configures the Pi coding agent with:

1. **Interactive Credentials**: Prompts for:
   - `LITELLM_BASE_URL`: LiteLLM server URL
   - `LITELLM_API_KEY`: API key for authentication
   - `LITELLM_CF_CLIENT_ID`: Cloudflare Access client ID
   - `LITELLM_CF_CLIENT_SECRET`: Cloudflare Access client secret

2. **Environment Variables**: Appends exports to `~/.bashrc`

3. **Pi Agent Installation**: Installs via `yay -S pi`

4. **Provider Plugin**: Installs `pi-provider-litellm`

5. **Models Configuration**: Creates `~/.pi/agent/models.json` with LiteLLM provider settings

6. **AI Skills**: Installs Vercel Labs skills:
   - `find-skills` - Skill discovery tool
   - `agent-browser` - Browser automation for agents

7. **Greeting**: Starts Pi in non-interactive mode:
   ```bash
   pi -p "hello world"
   ```

## 💻 Prerequisites

- **Arch Linux** or Omarchy
- **yay** (AUR helper) optionally installed
- **sudo** access for package installation

## ✨ Qiita

This setup environment uses all mirrors from https://developer.aliyun.com/mirror/ for faster dependency downloads in regions where direct access is slow.

## 📚 License

MIT License - Feel free to modify and redistribute.

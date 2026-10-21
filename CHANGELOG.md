# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2024-10-21
### Added
- Initial release of the Omarchy Development Setup Toolkit.
- Modularized setup scripts for language-specific environments (Java, Rust, Go, Python, Node.js).
- Interactive orchestration via `setup.sh`.
- Automated configuration of Aliyun/Taobao mirrors for all package managers.
- Pi agent bootstrap and skill installation.
- System application bundle (Chrome, Tailscale, Dropbox, etc.).
- Shell-level integration for toolchain management (`mise`).
- Open Source Audit documentation.

### System Requirements
- **OS**: Omarchy (Arch-based Linux)
- **Arch Kernel**: Tested on 6.x kernels
- **Package Manager**: `pacman` (system), `yay` (AUR)

### Dependency Versions (Recommended)
- **Shell**: Bash 5.x+
- **Toolchain Manager**: `mise` 2024.x+
- **Pi Agent**: 0.1.0+ (via `yay`)
- **Node.js/npm**: LTS versions via `mise`
- **Go**: 1.21+
- **Rust/Cargo**: 1.75+
- **Java**: Temurin JDK 21 (via `mise`)

---
*Maintained by Omarchy User Setup Tooling*

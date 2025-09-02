# Technology Stack

## Infrastructure as Code

### Core Automation Platform
- **Ansible** `11.9.0`
  - **ansible-core** `2.18.8` - Core automation engine
  - **ansible-lint** `25.8.2` - Playbook linting and best practices
  - **ansible-compat** `25.8.1` - Compatibility layer for different Ansible versions
  - YAML-based declarative configuration
  - Idempotent operations ensuring consistent state
  - Local execution model (localhost connection)

### Quality Assurance & Security
- **Pre-commit** `1.37.1` - Git hook framework for code quality
- **yamllint** `1.37.1` - YAML syntax and style validation
- **Safety** `3.6.0` - Python dependency security scanning
- **GitLeaks** - Secret and credential detection in code
- **Bandit** - Python security linting (via CI/CD)
- **ShellCheck** - Shell script static analysis (via CI/CD)

## Target Operating Systems

### Primary Support
- **Ubuntu** `20.04+` (LTS recommended)
- **Debian** `11+` (Bullseye and newer)
- Architecture: x86_64 (AMD64)

### Package Management
- **APT** - Primary package manager for system packages
- **Snap** - Modern package system for applications
- **Manual Installation** - For specialized tools and fonts

## Development Environment

### Version Control & Collaboration
- **Git** `2.48.1`
  - **diff-so-fancy** - Enhanced git diff output
  - Automated user configuration and credential setup
- **GitHub Actions** - CI/CD pipeline automation
- **GitHub CLI** `gh` - Command-line GitHub integration

### Code Editors & IDEs
- **Neovim** - Modern Vim-based editor
- **Visual Studio Code** (via Snap) - Cross-platform code editor
- **Claude Code CLI** - AI-powered development assistant

### Programming Languages & Runtimes
- **Python** `3.13.3`
  - **pip** - Python package manager
  - **venv** - Virtual environment management
- **Rust** - Systems programming language with Cargo
- **Node.js** (via Snap) - JavaScript runtime
- **npm** - Node.js package manager

### Development Tools
- **build-essential** - GCC compiler collection and build tools
- **docker-compose** - Container orchestration
- **podman** & **podman-compose** - Rootless container runtime
- **just** (via Snap) - Command runner and build tool
- **SQLite3** - Lightweight database engine

## Desktop Environment

### Window Management
- **i3** - Tiling window manager
  - **i3-volume** - Audio volume control integration
  - Keyboard-driven workflow optimization
- **xinit** - X11 session initialization

### Applications
- **Firefox** - Web browser with extension management
- **Thunderbird** - Email client with configuration automation
- **Chromium** - Open-source web browser
- **Alacritty** - GPU-accelerated terminal emulator

### Media & Graphics
- **VLC** - Multimedia player
- **GIMP** - Image editing software
- **feh** - Lightweight image viewer
- **gnome-screenshot** - Screen capture utility

### Productivity
- **LibreOffice** - Office suite
  - **libreoffice-gtk3** - GTK3 integration
- **Obsidian** (via Snap) - Knowledge management
- **Zathura** - Document viewer
- **Spotify** (via Snap) - Music streaming

## Shell Environment

### Shell Configuration
- **Zsh** - Extended Bourne shell
- **Oh My Zsh** - Zsh configuration framework
- **Numlockx** - Numlock state management

### Command Line Utilities
- **bat** - Enhanced cat with syntax highlighting
- **eza** - Modern ls replacement  
- **fzf** - Fuzzy finder for files and commands
- **fd-find** - Fast and user-friendly alternative to find
- **ripgrep** - Ultra-fast text search tool
- **btop** - Resource monitor (top replacement)
- **tree** - Directory structure visualization
- **curl** - HTTP client and data transfer tool
- **unzip** - Archive extraction utility

## System Utilities & Services

### System Management
- **systemd** - System and service manager (Ubuntu default)
- **sudo** - Privilege escalation
- **brightnessctl** - Screen brightness control
- **unclutter** - Hide mouse cursor when idle
- **bluetooth** support - Wireless connectivity
- **syncthing** - File synchronization

### Virtualization & Containers
- **VirtualBox** - Desktop virtualization platform
- **Docker** ecosystem - Container platform
- **wmdocker** - Docker containers in window manager

### Document Processing
- **Pandoc** - Universal document converter
- **TeXLive Full** - Complete LaTeX distribution
- **bibtool** - Bibliography management
- **paperkey** - OpenPGP key backup utility

## Fonts & Typography

### System Fonts
- **fonts-dejavu-core** - DejaVu font family
- **fonts-comic-neue** - Comic Neue font
- **fonts-noto-color-emoji** - Google Noto emoji fonts

### Development Fonts
- **JetBrains Mono** (Nerd Font) - Monospace font optimized for coding
- Automatic Nerd Fonts patching for icon support

## Database & Development Tools
- **SQLite Browser** (via Snap) - Database management GUI
- **SQLite3** - Command-line database interface
- **Pre-commit** - Git hooks for code quality

## Security & Encryption

### Credential Management
- **Ansible Vault** - Built-in encryption for sensitive data
- **GPG** integration - Public key cryptography
- Secure handling of:
  - SSH keys and configurations
  - Email credentials
  - API tokens and secrets
  - Personal identification information

### Access Control
- **become** password handling - Secure privilege escalation
- **vault-password-file** support - Automated vault unlocking
- No plain-text credentials in repository

## CI/CD & DevOps

### GitHub Actions Workflows
- **Security Analysis**: Multi-tool security scanning
- **Code Quality**: YAML, shell, and Ansible linting
- **Commit Validation**: Conventional commit enforcement  
- **Release Management**: Semantic versioning and automated releases
- **Dependabot**: Automated dependency updates

### Supported Platforms
- **Ubuntu Latest** - Primary CI/CD environment
- **Multi-architecture** - x86_64 support
- **Container-ready** - Docker and Podman support

## Network & Communication
- **curl** - HTTP/HTTPS client
- **Networking tools** - Built into target OS
- **SSH client** - Secure remote access (system provided)

## AI & Modern Tools

### AI Integration
- **Claude Code CLI** - AI-powered code assistant
- **Agent-OS** - AI agent operating system
- Integration with modern AI development workflows

### Modern Development Stack
- **Snap packages** - Modern application distribution
- **Container support** - Docker and Podman ecosystems  
- **Cloud-native tools** - kubectl, terraform (planned)
- **Modern CLI tools** - bat, eza, fd, ripgrep, fzf

## Version Management

### Dependency Versions
- **Fixed versions** where stability is critical
- **Latest stable** for development tools
- **LTS support** for operating systems
- **Semantic versioning** for releases

### Update Strategy
- **Automated dependency updates** via Dependabot
- **Security patches** prioritized
- **Backwards compatibility** maintained
- **Testing before deployment** via CI/CD

## Architecture Decisions

### Local-First Approach
- **localhost execution** - No remote dependencies
- **Self-contained** - All tools included
- **Offline capable** - Works without internet after download

### Modular Design
- **Component-based** - Enable/disable features independently
- **Role separation** - Clear boundaries between concerns
- **Configuration-driven** - YAML-based customization
- **Extensible** - Easy to add new components

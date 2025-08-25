# Technical Stack

> Last Updated: 2025-08-25
> Version: 1.3.2

## Application Framework

- **Framework:** Ansible
- **Version:** Latest (managed via pip)

## Configuration Management

- **Primary Tool:** Ansible Playbooks
- **Template Engine:** Jinja2
- **Configuration Format:** YAML
- **Variable Management:** Ansible host_vars and group_vars

## Programming Languages

- **Primary:** Python 3
- **Scripting:** Bash
- **Configuration:** YAML, JSON

## Package Management

- **System Packages:** apt (Ubuntu/Debian)
- **Snap Packages:** snapd
- **Python Packages:** pip
- **Development Tools:** Various package managers (npm, cargo, etc.)

## Development Environment

- **Version Control:** git
- **Editor:** neovim with custom configurations
- **Containers:** docker, podman
- **Build Tool:** just (command runner)
- **Terminal:** alacritty

## Desktop Environment

- **Window Manager:** i3wm
- **Status Bar:** polybar
- **Application Launcher:** rofi
- **Notifications:** dunst
- **Shell:** zsh with oh-my-zsh

## Applications Stack

- **Browser:** firefox
- **Email:** thunderbird
- **System Monitor:** btop
- **Font System:** nerdfonts

## CI/CD Pipeline

- **Current:** GitLab CI (legacy)
- **Target:** GitHub Actions
- **Release Management:** semantic-release
- **Commit Standards:** commitlint

## Infrastructure

- **Target OS:** Ubuntu/Debian-based Linux distributions
- **Architecture:** x86_64
- **Deployment:** Local Ansible execution
- **Configuration Sync:** Git-based version control

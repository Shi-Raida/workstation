# Technical Specification

This is the technical specification for the spec detailed in @.agent-os/specs/2025-09-04-ssh-key-management/spec.md

## Technical Requirements

- **Bitwarden CLI Integration**: Install and configure Bitwarden CLI for Vaultwarden authentication using password file stored in secure location (similar to existing vault/become password handling)
- **Session Management**: Cache Bitwarden CLI session token for the duration of playbook execution to avoid repeated authentication
- **SSH Key Retrieval**: Query Vaultwarden "SSH Keys" collection/folder and download all available SSH keys with proper error handling
- **Key Deployment**: Deploy SSH keys to ~/.ssh/ with secure permissions (600 for keys, 700 for .ssh directory) and proper ownership
- **Config Generation**: Generate ~/.ssh/config with security hardening options including StrictHostKeyChecking, ServerAliveInterval, and compression settings
- **Selective Deployment**: Read vars/vault.yml configuration to determine which keys to deploy (all by default, with override capability)
- **Key Rotation Workflow**: Support annual key rotation with automated server updates via Ansible before removing old keys
- **Server Inventory Management**: Maintain list of servers requiring key updates during rotation process
- **Backup and Recovery**: Create backups of existing SSH configurations before making changes
- **Idempotency**: Ensure all operations are idempotent and can be run multiple times safely
- **Error Handling**: Comprehensive error handling for network failures, authentication issues, and file system operations
- **Logging**: Detailed logging of all SSH key operations for audit and troubleshooting purposes

## External Dependencies

- **Bitwarden CLI** - Command-line interface for Vaultwarden interaction
  - **Justification:** Required for secure authentication and key retrieval from self-hosted Vaultwarden instance

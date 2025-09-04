# Spec Requirements Document

> Spec: SSH Key Management
> Created: 2025-09-04

## Overview

Implement secure SSH key management with Vaultwarden integration to automate SSH key retrieval, configuration generation, and annual key rotation. This feature will eliminate manual SSH setup processes and ensure consistent, secure key management across workstations.

## User Stories

### SSH Key Retrieval and Setup

As a workstation user, I want to automatically retrieve my SSH keys from Vaultwarden during system provisioning, so that I can immediately access remote servers without manual key setup.

The system authenticates to the self-hosted Vaultwarden instance at vw.raida.fr using a secure password file, retrieves all SSH keys from the "SSH Keys" collection, and configures them with appropriate permissions in ~/.ssh/. Keys are organized by hostname or purpose for easy identification.

### SSH Configuration Automation

As a developer, I want SSH configurations to be automatically generated with security best practices, so that I have secure and optimized SSH connections without manual configuration.

The system generates ~/.ssh/config with hardened settings including proper host configurations, security options like StrictHostKeyChecking, and connection optimizations like ServerAliveInterval.

### Annual Key Rotation

As a security-conscious user, I want to rotate SSH keys annually with automated server updates, so that I maintain strong security posture without manual intervention on multiple servers.

Every January, the system supports manual approval of key rotation, generates new SSH keys, updates them on all configured servers via Ansible automation, and removes old keys only after successful deployment.

## Spec Scope

1. **Vaultwarden Integration** - Authenticate and retrieve SSH keys from self-hosted Vaultwarden instance using secure password files
2. **SSH Key Management** - Deploy, configure, and set proper permissions for all retrieved SSH keys
3. **Config Generation** - Create ~/.ssh/config with security hardening and host configurations
4. **Key Rotation Workflow** - Annual manual rotation process with automated server key updates
5. **Selective Deployment** - Variable-driven control over which keys to deploy via vars/vault.yml configuration

## Out of Scope

- Vaultwarden server installation or maintenance
- Real-time key synchronization (only during playbook execution)
- Multi-user SSH key management
- Key rotation scheduling automation (manual approval required)

## Expected Deliverable

1. SSH keys are automatically retrieved from Vaultwarden and properly configured with secure permissions
2. ~/.ssh/config is generated with security best practices and host configurations
3. Annual key rotation workflow updates all configured servers before removing old keys

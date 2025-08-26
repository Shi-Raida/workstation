# Security Documentation

This directory contains security documentation for the workstation provisioning system.

## Overview

The workstation provisioning system implements multiple layers of security to protect against credential exposure, ensure secure deployments, and maintain security best practices throughout the development lifecycle.

## Security Features

### 🔍 Secrets Detection
- **gitleaks** - Scans for hardcoded secrets and credentials
- **Pre-commit hooks** - Prevents secrets from being committed
- **CI/CD integration** - Blocks deployments with exposed secrets

### 🛡️ Code Security Analysis
- **bandit** - Python security static analysis
- **shellcheck** - Shell script security validation
- **ansible-lint** - Ansible playbook security rules

### 🔒 Dependency Management
- **safety** - Python dependency vulnerability scanning
- **Automated updates** - CI/CD checks for vulnerable dependencies

### 📝 Configuration Validation
- **yamllint** - YAML file validation and security rules
- **ansible-vault** - Encrypted secrets management

## Security Workflows

### Local Development
1. Install pre-commit hooks: `pre-commit install`
2. Run security scan: `./scripts/scan-secrets.sh`
3. Review security reports before committing

### CI/CD Pipeline
1. **Security Scan Job** - First step in CI pipeline
2. **Multi-tool validation** - gitleaks, bandit, safety, yamllint, shellcheck
3. **Fail fast** - Blocks pipeline on security issues
4. **Detailed reporting** - Security scan summaries in GitHub Actions

## Quick Start

### Initial Setup
```bash
# Install pre-commit hooks
source .venv/bin/activate
pre-commit install --install-hooks

# Run first security scan
./scripts/scan-secrets.sh

# Test pre-commit hooks
pre-commit run --all-files
```

### Regular Usage
```bash
# Before committing changes
./scripts/scan-secrets.sh

# Check specific files
gitleaks detect --source . --config .gitleaks.toml

# Validate YAML files
yamllint -c .yamllint.yml .

# Check shell scripts
find . -name "*.sh" -exec shellcheck {} \;
```

## Configuration Files

| File | Purpose |
|------|---------|
| `.gitleaks.toml` | Secrets detection rules and patterns |
| `.pre-commit-config.yaml` | Pre-commit hooks configuration |
| `.yamllint.yml` | YAML validation rules |
| `.ansible-lint` | Ansible playbook security rules |

## Security Reports

Reports are generated in `.security-reports/` directory:
- `gitleaks_*.json` - Secrets detection results
- `bandit_*.json` - Python security analysis
- `safety_*.json` - Dependency vulnerabilities
- `yamllint_*.txt` - YAML validation issues
- `shellcheck_*.json` - Shell script security issues
- `security_summary_*.txt` - Consolidated summary

## Related Documentation

- [Secrets Management](secrets-management.md) - Handling credentials securely
- [Security Checklist](security-checklist.md) - Pre-deployment security validation

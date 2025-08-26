# Secrets Management Guide

This guide covers how to securely handle credentials, API keys, passwords, and other sensitive data in the workstation provisioning system.

## Overview

The workstation provisioning system uses a multi-layered approach to secrets management:
- **Detection**: Prevent secrets from being committed
- **Storage**: Use ansible-vault for encrypted storage
- **Access**: Environment-based secret injection
- **Rotation**: Regular credential updates

## Secrets Detection

### gitleaks Configuration

The `.gitleaks.toml` file defines patterns for detecting various types of secrets:

```toml
[[rules]]
id = "ansible-vault-password"
description = "Ansible Vault Password"
regex = '''(?i)(vault[_-]?pass|vault[_-]?password)['"]*\s*[:=]\s*['"][^'"]{8,}['"]'''
```

### Supported Secret Types

- **Ansible Vault Passwords** - `vault_password`, `vault-password`
- **Become Passwords** - `become_password`, `ansible_become_pass`
- **SSH Private Keys** - RSA, ECDSA, Ed25519 keys
- **API Keys** - Generic API key patterns
- **Database Credentials** - MySQL, PostgreSQL connection strings
- **Docker Registry Auth** - Registry authentication tokens

## Ansible Vault Usage

### Encrypting Variables

```bash
# Encrypt a string
ansible-vault encrypt_string 'secret_password' --name 'database_password'

# Encrypt an entire file
ansible-vault encrypt vars/secrets.yml

# Encrypt with specific vault ID
ansible-vault encrypt_string --vault-id prod@prompt 'production_secret'
```

### Using Encrypted Variables

```yaml
# In your playbook
- name: Configure application
  template:
    src: app.conf.j2
    dest: /etc/app/config.conf
  vars:
    database_password: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          66386439653562656236663166376265623831346362653...
```

### Vault Password Management

**Option 1: Environment Variable**
```bash
export ANSIBLE_VAULT_PASSWORD_FILE=~/.vault_pass
```

**Option 2: Prompt for Password**
```bash
ansible-playbook --ask-vault-pass play.yml
```

**Option 3: Multiple Vault IDs**
```bash
# ansible.cfg
[defaults]
vault_identity_list = dev@~/.vault_pass_dev, prod@~/.vault_pass_prod
```

## Safe Patterns

### ✅ Correct Approaches

```yaml
# Use vault-encrypted variables
database_password: "{{ vault_database_password }}"

# Environment variable injection
api_key: "{{ lookup('env', 'API_KEY') }}"

# Prompt for sensitive data
- name: Get database password
  pause:
    prompt: "Enter database password"
    echo: no
  register: db_pass

# Use ansible-vault for secrets files
- name: Load secrets
  include_vars: "{{ item }}"
  with_items:
    - secrets/{{ env }}.yml
```

### Template Examples

```yaml
# vars/secrets.yml (encrypted with ansible-vault)
vault_database_password: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          66386439653562656236663166376265623831346362653...

vault_api_key: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          33653538316238323566316530613764393...

# In your playbook
- name: Configure database connection
  template:
    src: database.conf.j2
    dest: /etc/app/database.conf
  vars:
    db_password: "{{ vault_database_password }}"
    api_secret: "{{ vault_api_key }}"
```

## Unsafe Patterns to Avoid

### ❌ Never Do This

```yaml
# Hardcoded passwords in plain text
database_password: "mysecretpassword123"

# API keys in variables
api_key: "sk-1234567890abcdef"

# Secrets in task parameters
- name: Connect to API
  uri:
    url: "https://api.example.com"
    headers:
      Authorization: "Bearer sk-1234567890abcdef"

# Passwords in debug statements
- name: Show password
  debug:
    var: database_password

# Secrets in git commit messages or comments
# TODO: Remember to change password from 'temp123' later
```

## Environment Setup

### Development Environment
```bash
# Create vault password file (not committed to git)
echo 'dev-vault-password-123' > ~/.vault_pass_dev
chmod 600 ~/.vault_pass_dev

# Set environment variable
export ANSIBLE_VAULT_PASSWORD_FILE=~/.vault_pass_dev
```

### Production Environment
```bash
# Use secure password management
# Option 1: HashiCorp Vault
vault kv get -field=password secret/ansible/prod

# Option 2: AWS Secrets Manager
aws secretsmanager get-secret-value --secret-id prod/ansible/vault

# Option 3: Azure Key Vault
az keyvault secret show --vault-name MyKeyVault --name ansible-vault-pass
```

## Secret Rotation

### Regular Rotation Process

1. **Generate New Secrets**
   ```bash
   # Generate strong passwords
   openssl rand -base64 32

   # Generate API keys (service-specific)
   curl -X POST https://api.service.com/keys
   ```

2. **Update Encrypted Variables**
   ```bash
   # Rekey existing vault files with new password
   ansible-vault rekey vars/secrets.yml

   # Update individual secrets
   ansible-vault encrypt_string 'new_password' --name 'database_password'
   ```

3. **Deploy Changes**
   ```bash
   # Test with new secrets
   ansible-playbook --check play.yml

   # Deploy to environments
   ansible-playbook -i inventory/staging play.yml
   ansible-playbook -i inventory/production play.yml
   ```

4. **Verify and Clean Up**
   ```bash
   # Test applications work with new secrets
   ./scripts/health-check.sh

   # Remove old secrets from external systems
   # Revoke old API keys, disable old database users, etc.
   ```

## Emergency Procedures

### Compromised Secrets

1. **Immediate Actions**
   - Rotate compromised credentials immediately
   - Revoke API keys and tokens
   - Change database passwords
   - Review access logs

2. **Assessment**
   ```bash
   # Check git history for exposed secrets
   gitleaks detect --source . --verbose

   # Review recent commits
   git log --oneline -10

   # Check for secrets in logs
   grep -r "password\|secret\|key" /var/log/
   ```

3. **Remediation**
   ```bash
   # Remove secrets from git history (if necessary)
   git filter-branch --force --index-filter \
     'git rm --cached --ignore-unmatch path/to/secret/file' \
     --prune-empty --tag-name-filter cat -- --all

   # Update all environments with new secrets
   ansible-playbook -i inventory/all emergency-rotate.yml
   ```

## Security Checklist

- [ ] No plaintext secrets in version control
- [ ] All sensitive variables use ansible-vault
- [ ] Vault password files are not committed
- [ ] Pre-commit hooks are installed and working
- [ ] Regular secret rotation schedule in place
- [ ] Emergency response procedures documented
- [ ] Team members trained on secret handling

## Tools Integration

### CI/CD Pipeline
```yaml
# GitHub Actions example
- name: Setup vault password
  env:
    VAULT_PASSWORD: ${{ secrets.ANSIBLE_VAULT_PASSWORD }}
  run: echo "$VAULT_PASSWORD" > .vault_pass

- name: Run playbook with secrets
  run: ansible-playbook --vault-password-file .vault_pass play.yml
```

### Local Development
```bash
# Add to your shell profile
export ANSIBLE_VAULT_PASSWORD_FILE=~/.config/ansible/vault_pass
export ANSIBLE_HOST_KEY_CHECKING=False

# Create development secrets template
cp vars/secrets.yml.example vars/secrets.yml
ansible-vault encrypt vars/secrets.yml
```

## Best Practices Summary

1. **Always encrypt secrets** - Use ansible-vault for all sensitive data
2. **Use descriptive vault IDs** - Separate dev/staging/prod vaults
3. **Rotate regularly** - Implement automated rotation where possible
4. **Monitor for leaks** - Use gitleaks and pre-commit hooks
5. **Train your team** - Ensure everyone knows secure practices
6. **Have emergency plans** - Document incident response procedures
7. **Audit access** - Regular reviews of who has access to secrets

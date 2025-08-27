# Variables Documentation

This directory contains all configuration variables for the Stable-Bot workstation setup, organized into logical files for better maintainability and user experience.

## File Structure

### Core Variable Files

| File | Purpose | Description |
|------|---------|-------------|
| `components.yml` | Feature toggles | Controls which components are enabled/disabled |
| `directories.yml` | Path configuration | XDG directories and custom paths |
| `packages.yml` | Package definitions | APT, Snap packages, and fonts |
| `applications.yml` | App configurations | Browser extensions, shell plugins, etc. |
| `vault.yml` | Sensitive data | Encrypted credentials and personal info |

### Support Files

| File | Purpose |
|------|---------|
| `vault.yml.example` | Template for creating your vault |
| `README.md` | This documentation file |

## Loading Order

Variables are loaded in the following order (defined in `play.yml`):

1. **components.yml** - Defines what gets installed
2. **directories.yml** - Sets up directory structure
3. **packages.yml** - Defines packages to install
4. **applications.yml** - Configures applications
5. **vault.yml** - Overrides with encrypted sensitive data

## Working with Encrypted Variables (Vault)

### Initial Setup

1. Copy the example vault file:
   ```bash
   cp vars/vault.yml.example vars/vault.yml
   ```

2. Edit the vault file with your information:
   ```bash
   # Edit in plain text first
   nano vars/vault.yml
   ```

3. Encrypt the file:
   ```bash
   ansible-vault encrypt vars/vault.yml
   ```

### Managing the Vault

| Action | Command |
|--------|---------|
| View encrypted content | `ansible-vault view vars/vault.yml` |
| Edit encrypted content | `ansible-vault edit vars/vault.yml` |
| Change vault password | `ansible-vault rekey vars/vault.yml` |
| Decrypt file (be careful!) | `ansible-vault decrypt vars/vault.yml` |

### Vault Password File

The vault password is stored in `.vault_pass` (gitignored for security).

**IMPORTANT**:
- Never commit `.vault_pass` to git
- Use a strong, unique password
- Consider using a password manager
- The encrypted `vault.yml` is safe to commit

## Customization Guide

### Adding New Packages

Edit `vars/packages.yml`:

```yaml
# Add to existing categories
apt_packages:
  - your-new-package

# Or create new categories
custom_packages:
  - special-tool
```

### Disabling Components

Edit `vars/components.yml`:

```yaml
components:
  firefox:
    enabled: false  # Skip Firefox setup
```

### Adding Personal Information

Add sensitive data to `vars/vault.yml`:

```bash
ansible-vault edit vars/vault.yml
```

### Custom Directories

Modify paths in `vars/directories.yml`:

```yaml
custom_project_dir: "{{ ansible_user_dir }}/my-projects"
```

## Variable Categories

### Required Variables

These variables must be defined (defaults provided):

- `ansible_user_dir` - User home directory
- `ansible_user_id` - Username
- `xdg_config_home` - Configuration directory
- `git_name` - Your name for git commits (in vault)
- `git_email` - Your email for git commits (in vault)

### Optional Variables

Variables with sensible defaults:

- Package lists (can be empty)
- Component flags (default to true)
- Directory paths (follow XDG standards)

### Override Methods

1. **Edit variable files directly** (recommended)
2. **Command line override**:
   ```bash
   ansible-playbook play.yml -e "git_name='Custom Name'"
   ```
3. **Additional variable files** in `play.yml`

## Security Best Practices

### ✅ Safe to Commit

- All `.yml` files except plain text `vault.yml`
- Encrypted `vault.yml`
- `.vault_pass.example`

### ❌ Never Commit

- `.vault_pass` (vault password)
- Unencrypted `vault.yml`
- Any files with actual credentials

### 🔒 Sensitive Data Guidelines

Always encrypt in vault:
- Email addresses
- Real names (if privacy concern)
- API keys and tokens
- Passwords and credentials
- Personal identifiers

## Troubleshooting

### Common Issues

1. **Vault password errors**:
   - Check `.vault_pass` exists and has correct password
   - Verify `ansible.cfg` points to correct password file

2. **Missing variables**:
   - Check file exists and variable is defined
   - Verify loading order in `play.yml`

3. **Permission errors**:
   - Ensure `.vault_pass` is readable
   - Check file permissions on variable files

### Testing Variables

```bash
# Test vault decryption
ansible-vault view vars/vault.yml

# Check loaded variables
ansible-playbook play.yml --list-tasks

# Dry run to test configuration
ansible-playbook play.yml --check
```

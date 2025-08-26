# Security Checklist

Use this checklist to ensure your workstation provisioning system follows security best practices.

## Pre-Commit Security Checklist

### 🔍 Before Every Commit

- [ ] **Run local security scan**
  ```bash
  ./scripts/scan-secrets.sh
  ```

- [ ] **Check for hardcoded secrets**
  ```bash
  gitleaks detect --source . --config .gitleaks.toml --verbose
  ```

- [ ] **Validate pre-commit hooks are working**
  ```bash
  pre-commit run --all-files
  ```

- [ ] **Review staged changes for sensitive data**
  ```bash
  git diff --staged
  ```

## Development Environment Security

### 🛠️ Initial Setup

- [ ] **Pre-commit hooks installed**
  ```bash
  source .venv/bin/activate
  pre-commit install --install-hooks
  ```

- [ ] **Security tools available**
  - [ ] gitleaks installed and configured
  - [ ] yamllint configured for security rules
  - [ ] shellcheck available for shell scripts
  - [ ] bandit available for Python analysis
  - [ ] ansible-lint configured with security rules

- [ ] **Vault password management**
  - [ ] Vault password file created (not in git)
  - [ ] ANSIBLE_VAULT_PASSWORD_FILE environment variable set
  - [ ] Vault password file has restricted permissions (600)

### 📁 File System Security

- [ ] **Sensitive files properly protected**
  - [ ] Private keys have 600 permissions
  - [ ] Vault files are encrypted
  - [ ] No backup files with secrets (*.bak, *~)
  - [ ] Temporary files cleaned up

- [ ] **Git configuration**
  - [ ] .gitignore includes sensitive file patterns
  - [ ] No sensitive files tracked by git
  - [ ] Git hooks functioning properly

## Code Security Review

### 🔒 Secrets Management

- [ ] **No hardcoded credentials**
  - [ ] No passwords in plain text
  - [ ] No API keys in variables
  - [ ] No database connection strings with credentials
  - [ ] No SSH keys in repository

- [ ] **Proper ansible-vault usage**
  - [ ] All secrets encrypted with ansible-vault
  - [ ] Vault IDs used appropriately
  - [ ] No vault passwords in playbooks or variables

- [ ] **Environment variable usage**
  - [ ] Sensitive data loaded from environment variables
  - [ ] No secrets in default values
  - [ ] Proper lookup syntax used

### 📝 Configuration Security

- [ ] **YAML files secure**
  - [ ] No embedded secrets
  - [ ] Proper quoting and escaping
  - [ ] Valid YAML syntax
  - [ ] Security-focused yamllint rules passing

- [ ] **Ansible playbooks secure**
  - [ ] No `no_log: false` on sensitive tasks
  - [ ] Vault variables properly referenced
  - [ ] No secrets in task names or debug output
  - [ ] ansible-lint security rules passing

- [ ] **Shell scripts secure**
  - [ ] No hardcoded passwords
  - [ ] Proper variable quoting
  - [ ] No command injection vulnerabilities
  - [ ] shellcheck security warnings addressed

## Deployment Security

### 🚀 Pre-Deployment

- [ ] **CI/CD pipeline security**
  - [ ] Security scan job passes
  - [ ] All security tools run successfully
  - [ ] No secrets in CI logs
  - [ ] Proper secret injection from CI/CD system

- [ ] **Dependency security**
  - [ ] Python packages scanned for vulnerabilities
  - [ ] Ansible collections from trusted sources
  - [ ] No known vulnerable dependencies

- [ ] **Infrastructure security**
  - [ ] Target systems properly secured
  - [ ] Network access controlled
  - [ ] SSH keys properly managed
  - [ ] Firewall rules appropriate

### 🎯 Target System Security

- [ ] **Access controls**
  - [ ] Principle of least privilege applied
  - [ ] User accounts properly configured
  - [ ] sudo access restricted
  - [ ] SSH configuration hardened

- [ ] **File permissions**
  - [ ] Sensitive files have appropriate permissions
  - [ ] Service files owned by correct users
  - [ ] Configuration files not world-readable

- [ ] **Service security**
  - [ ] Services run as non-root users
  - [ ] Unnecessary services disabled
  - [ ] Security updates applied
  - [ ] Logging configured properly

## Incident Response Checklist

### 🚨 Secret Exposure Response

If secrets are accidentally exposed:

1. **Immediate Actions** (within 1 hour)
   - [ ] Identify scope of exposure
   - [ ] Rotate compromised credentials immediately
   - [ ] Revoke API keys and tokens
   - [ ] Document incident timeline

2. **Assessment** (within 4 hours)
   - [ ] Review git history for secrets
   - [ ] Check logs for unauthorized access
   - [ ] Identify affected systems and data
   - [ ] Assess potential impact

3. **Remediation** (within 24 hours)
   - [ ] Remove secrets from git history if necessary
   - [ ] Update all affected systems with new credentials
   - [ ] Verify new credentials work properly
   - [ ] Monitor for suspicious activity

4. **Recovery** (ongoing)
   - [ ] Implement additional monitoring
   - [ ] Review and improve security procedures
   - [ ] Train team on lessons learned
   - [ ] Update security documentation

## Compliance and Auditing

### 📊 Regular Security Reviews

- [ ] **Weekly**
  - [ ] Review security scan reports
  - [ ] Check for failed pre-commit hooks
  - [ ] Monitor dependency vulnerabilities

- [ ] **Monthly**
  - [ ] Rotate development secrets
  - [ ] Review access logs
  - [ ] Update security tools

- [ ] **Quarterly**
  - [ ] Comprehensive security audit
  - [ ] Penetration testing if applicable
  - [ ] Team security training refresh

### 📋 Documentation Review

- [ ] **Security documentation up to date**
  - [ ] Procedures reflect current practices
  - [ ] Contact information current
  - [ ] Tool versions and configurations documented

- [ ] **Team knowledge**
  - [ ] All team members trained on security practices
  - [ ] Emergency contacts known
  - [ ] Escalation procedures understood

## Security Tool Configuration

### ⚙️ Tool Maintenance

- [ ] **gitleaks**
  - [ ] Configuration file up to date
  - [ ] Custom rules for project-specific secrets
  - [ ] Regular pattern updates
  - [ ] Version updated regularly

- [ ] **Pre-commit hooks**
  - [ ] All security hooks enabled
  - [ ] Hook versions kept current
  - [ ] Local custom rules working
  - [ ] Performance acceptable

- [ ] **CI/CD security job**
  - [ ] All security tools included
  - [ ] Proper failure handling
  - [ ] Report generation working
  - [ ] Integration with other jobs correct

## Security Metrics

### 📈 Key Performance Indicators

Track these security metrics:

- [ ] **Detection effectiveness**
  - Number of secrets caught by pre-commit hooks
  - Time between secret introduction and detection
  - False positive rate

- [ ] **Response times**
  - Time to rotate compromised credentials
  - Time to deploy security fixes
  - Incident response time

- [ ] **Coverage**
  - Percentage of files scanned
  - Number of security tools active
  - Team training completion rate

## Emergency Contacts

### 📞 Security Incident Contacts

Maintain current contact information for:

- [ ] **Primary security contact**
- [ ] **System administrators**
- [ ] **Cloud provider support**
- [ ] **External security consultant** (if applicable)

---

## Quick Commands Reference

```bash
# Daily security check
./scripts/scan-secrets.sh

# Pre-commit validation
pre-commit run --all-files

# Manual secrets scan
gitleaks detect --source . --config .gitleaks.toml

# Encrypt new secret
ansible-vault encrypt_string 'secret_value' --name 'variable_name'

# Check file for secrets
gitleaks detect --source path/to/file --config .gitleaks.toml

# Generate secure password
openssl rand -base64 32

# Check ansible-vault encryption
ansible-vault view vars/secrets.yml

# Validate YAML security
yamllint -c .yamllint.yml path/to/file.yml

# Shell script security check
shellcheck path/to/script.sh
```

# Spec Tasks

## Tasks

- [ ] 1. Bitwarden CLI Setup and Authentication
  - [ ] 1.1 Write tests for Bitwarden CLI installation and configuration
  - [ ] 1.2 Install Bitwarden CLI package
  - [ ] 1.3 Configure server URL for Vaultwarden instance (vw.raida.fr)
  - [ ] 1.4 Implement password file handling for authentication
  - [ ] 1.5 Create session management for CLI operations
  - [ ] 1.6 Add error handling for authentication failures
  - [ ] 1.7 Verify all tests pass

- [ ] 2. SSH Key Retrieval System  
  - [ ] 2.1 Write tests for Vaultwarden connection and key retrieval
  - [ ] 2.2 Implement collection discovery for "SSH Keys" folder
  - [ ] 2.3 Create key enumeration and download functionality
  - [ ] 2.4 Add support for both private and public key retrieval
  - [ ] 2.5 Implement selective key deployment via vars/vault.yml
  - [ ] 2.6 Add comprehensive error handling for network/API failures
  - [ ] 2.7 Verify all tests pass

- [ ] 3. SSH Configuration Management
  - [ ] 3.1 Write tests for SSH config generation
  - [ ] 3.2 Create backup functionality for existing SSH configs
  - [ ] 3.3 Implement secure SSH config template generation
  - [ ] 3.4 Add security hardening options (StrictHostKeyChecking, ServerAliveInterval)
  - [ ] 3.5 Create host-specific configuration support
  - [ ] 3.6 Implement idempotent config updates
  - [ ] 3.7 Verify all tests pass

- [ ] 4. Key Deployment and Permissions
  - [ ] 4.1 Write tests for SSH key deployment and permissions
  - [ ] 4.2 Create secure key file deployment (600 permissions)
  - [ ] 4.3 Ensure proper .ssh directory permissions (700)
  - [ ] 4.4 Implement key ownership validation
  - [ ] 4.5 Add key format validation and error handling
  - [ ] 4.6 Create deployment rollback functionality
  - [ ] 4.7 Verify all tests pass

- [ ] 5. Key Rotation Workflow
  - [ ] 5.1 Write tests for key rotation and server updates
  - [ ] 5.2 Create new SSH key generation functionality
  - [ ] 5.3 Implement server inventory management for key updates
  - [ ] 5.4 Add automated server key deployment via Ansible
  - [ ] 5.5 Create old key removal after successful deployment
  - [ ] 5.6 Implement rotation logging and audit trail
  - [ ] 5.7 Add manual approval workflow for January rotation
  - [ ] 5.8 Verify all tests pass

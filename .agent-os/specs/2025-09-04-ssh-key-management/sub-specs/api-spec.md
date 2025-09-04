# API Specification

This is the API specification for the spec detailed in @.agent-os/specs/2025-09-04-ssh-key-management/spec.md

## Endpoints

### POST /identity/accounts/prelogin

**Purpose:** Retrieve server configuration before authentication
**Parameters:** email (Vaultwarden account email)
**Response:** Server configuration including KDF iterations
**Errors:** Invalid email, server unavailable

### POST /identity/connect/token

**Purpose:** Authenticate with Vaultwarden and obtain access token
**Parameters:** username, password, scope, client_id, grant_type
**Response:** Access token, refresh token, expiration time
**Errors:** Invalid credentials, account locked, 2FA required

### GET /sync

**Purpose:** Retrieve all vault data including collections and items
**Parameters:** Authorization header with Bearer token
**Response:** Complete vault sync data including SSH keys collection
**Errors:** Invalid token, expired session, insufficient permissions

### GET /collections

**Purpose:** List all collections to locate "SSH Keys" collection
**Parameters:** Authorization header with Bearer token
**Response:** Array of collections with IDs and names
**Errors:** Invalid token, no access to collections

### GET /ciphers

**Purpose:** Retrieve all cipher items from vault
**Parameters:** Authorization header with Bearer token, optional collectionId filter
**Response:** Array of cipher objects containing SSH key data
**Errors:** Invalid token, collection not found

## CLI Commands

### bw config server <url>

**Purpose:** Configure Bitwarden CLI to use self-hosted Vaultwarden instance
**Parameters:** Server URL (vw.raida.fr)
**Response:** Configuration success confirmation
**Errors:** Invalid URL, network connectivity issues

### bw login --raw

**Purpose:** Authenticate and return session token
**Parameters:** Username from password file, password from password file
**Response:** Session token string for subsequent commands
**Errors:** Invalid credentials, server unreachable, 2FA required

### bw unlock --raw

**Purpose:** Unlock vault and return session token
**Parameters:** Master password from password file
**Response:** Session token string
**Errors:** Invalid password, vault not found

### bw list items --collectionid <id> --session <token>

**Purpose:** List all items in SSH Keys collection
**Parameters:** Collection ID for SSH Keys, session token
**Response:** JSON array of SSH key items with attachments
**Errors:** Invalid session, collection not accessible

### bw get attachment <filename> --itemid <id> --session <token>

**Purpose:** Download SSH key file from vault item
**Parameters:** Attachment filename, item ID, session token
**Response:** SSH key file content (private/public key)
**Errors:** Attachment not found, invalid permissions

### bw logout

**Purpose:** Logout and invalidate session
**Parameters:** None
**Response:** Logout confirmation
**Errors:** No active session

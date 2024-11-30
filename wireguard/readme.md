# Wireguard Role

## Overview
An Ansible role for managing Wireguard VPN client installation and configuration on Rocky Linux 9 and Debian 12 systems.

## Features
- Automated installation and configuration of Wireguard client
- Cross-platform support (Rocky 9 and Debian 12)
- Secure key generation and management
- Automatic key backup to local data directory
- Idempotent installation and removal
- Configurable client settings

## Requirements
- Ansible 2.9 or higher
- Root or sudo access on target systems
- Python 3.6 or higher

## Role Variables

### Required Variables
```yaml
wireguard_svr_public_key: ""        # Server's public key
wireguard_cluster_preshared_key: "" # Pre-shared key for the VPN
wireguard_server_endpoint: ""       # Server's public IP or hostname
```

### Optional Variables
```yaml
wireguard_state: present            # Role state (present/absent)
wireguard_client_ip: "10.10.0.2/24" # Client IP address
wireguard_server_port: "51820"      # Server port
wireguard_server_allowed_ips: "10.10.0.1/24" # Allowed IP range
```

## States

### Present State
When `wireguard_state: present`, the role will:
1. Validate required variables
2. Install Wireguard packages
3. Generate client keys if not present
4. Back up keys to ./data directory
5. Configure wg0.conf
6. Set appropriate permissions

### Absent State
When `wireguard_state: absent`, the role will:
1. Stop Wireguard service
2. Remove all Wireguard configurations
3. Uninstall Wireguard packages
4. Remove backed-up keys

## Tags

The role uses the following tags for granular execution control:

### Primary Tags
- `wireguard`: All Wireguard-related tasks
- `wireguard:config`: Configuration tasks
- `wireguard:install`: Installation tasks
- `wireguard:remove`: Removal tasks
- `wireguard:validate`: Variable validation tasks
- `wireguard:packages`: Package management tasks
- `wireguard:keys`: Key management tasks
- `wireguard:service`: Service management tasks

## Usage Examples

### Basic Installation
```yaml
- hosts: vpn_clients
  roles:
    - role: wireguard
      vars:
        wireguard_svr_public_key: "AbCdEf123..."
        wireguard_cluster_preshared_key: "XyZ789..."
        wireguard_server_endpoint: "vpn.example.com"
  tags:
    - wireguard
```

### Configuration Only
```yaml
- hosts: vpn_clients
  roles:
    - role: wireguard
      vars:
        wireguard_svr_public_key: "AbCdEf123..."
        wireguard_cluster_preshared_key: "XyZ789..."
        wireguard_server_endpoint: "vpn.example.com"
  tags:
    - wireguard:config
```

### Package Installation Only
```yaml
- hosts: vpn_clients
  roles:
    - role: wireguard
  tags:
    - wireguard:packages
```

### Validate Configuration
```yaml
- hosts: vpn_clients
  roles:
    - role: wireguard
      vars:
        wireguard_svr_public_key: "AbCdEf123..."
        wireguard_cluster_preshared_key: "XyZ789..."
        wireguard_server_endpoint: "vpn.example.com"
  tags:
    - wireguard:validate
```

### Tag Usage Examples

Run only configuration tasks:
```bash
ansible-playbook playbook.yml --tags "wireguard:config"
```

Skip package installation:
```bash
ansible-playbook playbook.yml --skip-tags "wireguard:packages"
```

Run validation and configuration:
```bash
ansible-playbook playbook.yml --tags "wireguard:validate,wireguard:config"
```

## Usage Examples

### Basic Installation
```yaml
- hosts: vpn_clients
  roles:
    - role: wireguard
      vars:
        wireguard_svr_public_key: "AbCdEf123..."
        wireguard_cluster_preshared_key: "XyZ789..."
        wireguard_server_endpoint: "vpn.example.com"
```

### Custom Configuration
```yaml
- hosts: vpn_clients
  roles:
    - role: wireguard
      vars:
        wireguard_state: present
        wireguard_svr_public_key: "AbCdEf123..."
        wireguard_cluster_preshared_key: "XyZ789..."
        wireguard_server_endpoint: "vpn.example.com"
        wireguard_client_ip: "10.10.0.100/24"
        wireguard_server_port: "51821"
```

### Removal
```yaml
- hosts: vpn_clients
  roles:
    - role: wireguard
      vars:
        wireguard_state: absent
```

## Suggested Improvements

### Security Enhancements
1. Add support for hardware security modules (HSM) for key storage
2. Implement automated key rotation
3. Add support for multi-factor authentication
4. Implement certificate-based authentication option

### Functionality Improvements
1. Add support for multi-peer configurations
2. Implement bandwidth monitoring and logging
3. Add support for traffic shaping and QoS
4. Create automatic backup and restore procedures
5. Add support for IPv6

### Operational Improvements
1. Add health check monitoring
2. Implement automatic failover capability
3. Add performance metrics collection
4. Create automatic documentation generation
5. Add integration with popular monitoring systems

### Management Improvements
1. Add web interface for configuration management
2. Create API endpoints for programmatic management
3. Implement configuration validation tools
4. Add support for configuration templates
5. Create migration tools for different VPN solutions

## License
MIT

## Author Information
Created and maintained by Your Organization

---
*Documentation format follows the OpenAPI/AsyncAPI documentation style guide version 3.0, incorporating elements from the Ansible Galaxy role documentation requirements.*

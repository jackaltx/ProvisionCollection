# Wireguard Role

[previous sections remain the same until Tags section]

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

[rest of the documentation remains the same]

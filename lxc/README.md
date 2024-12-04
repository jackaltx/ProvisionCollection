# LXC Ansible Role

This role manages the installation and configuration of LXC (Linux Containers), focusing on rootless container setup with appropriate user mappings and network configuration.

## Overview

The role handles:
- Installation of LXC packages
- Configuration of both system and user-level container defaults
- User namespace mappings
- Network configuration for rootless containers
- Complete lifecycle management (install/remove)

## Role Variables

```yaml
# Installation control
lxc_state: 'present'    # Use 'absent' to remove LXC
lxc_user: 'lavender'    # User for rootless container configuration
```

## Features

### System Configuration
Default system-wide configuration (`/etc/lxc/default.conf`):
```conf
lxc.net.0.type = veth
lxc.net.0.link = virbr0
lxc.net.0.flags = up
lxc.net.0.hwaddr = 00:16:3e:xx:xx:xx
lxc.apparmor.profile = generated
lxc.apparmor.profile = lxc-container-default-cgns
lxc.apparmor.allow_nesting = 1
```

### User Configuration
User-specific configuration (`~/.config/lxc/default.conf`):
```conf
lxc.apparmor.profile = unconfined

# UID/GID Mapping
lxc.idmap = u 0 100000 1000
lxc.idmap = g 0 100000 1000
lxc.idmap = u 1000 1000 1
lxc.idmap = g 1000 1000 1
lxc.idmap = u 1001 101001 64535
lxc.idmap = g 1001 101001 64535
```

### Network Configuration
- Creates user-specific network configuration
- Allows up to 10 veth interfaces per user
- Uses lcbr0 bridge interface

## Security Features

### User Namespace Mapping
- Maps container's root user to unprivileged user range
- Preserves user's UID/GID mapping
- Provides isolation between host and container users

### AppArmor Profiles
- System containers use default confined profile
- User containers use unconfined profile
- Supports nested virtualization

## Dependencies

This role has no dependencies on other Ansible roles.

## Example Playbooks

### Basic Installation

```yaml
- hosts: servers
  roles:
    - role: lxc
      vars:
        lxc_user: "myuser"
```

### Complete Removal

```yaml
- hosts: servers
  vars:
    lxc_state: absent
  roles:
    - role: lxc
```

## File Structure

```
lxc/
├── defaults/
│   └── main.yml              # Default variables
├── files/
│   ├── lxc_default.conf     # System-wide configuration
│   └── lxc_user_default.conf # User-specific configuration
└── tasks/
    └── main.yml            # Main tasks
```

## Installation Details

### Package Installation
- Installs core LXC package
- Creates necessary configuration directories
- Sets up user and system configurations

### Configuration Setup
1. System Configuration
   - Creates `/etc/lxc/default.conf`
   - Configures network defaults
   - Sets AppArmor profiles

2. User Configuration
   - Creates `~/.config/lxc/`
   - Sets up user-specific defaults
   - Configures UID/GID mappings

3. Network Setup
   - Configures `/etc/lxc/lxc-usernet`
   - Enables rootless networking
   - Sets interface limits

## Operational Notes

### User Namespace Mapping Details
The role configures the following mapping:
- Container UID/GID 0-999 → Host 100000-100999
- Container UID/GID 1000 → Host 1000 (user preservation)
- Container UID/GID 1001-65535 → Host 101001-165535

### Network Configuration
- Allows users to create up to 10 veth interfaces
- Uses veth type networking
- Configures bridge interface lcbr0

## Troubleshooting

Common issues and solutions:
1. Network Interface Issues
   - Verify lxc-usernet configuration
   - Check bridge interface existence
   - Validate user permissions

2. Container Start Failures
   - Check AppArmor profile status
   - Verify UID/GID mappings
   - Validate network configuration

## License

BSD

## Author Information

Originally created by Anthropic. Extended by the community.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Additional Resources

- [LXC Documentation](https://linuxcontainers.org/lxc/documentation/)
- [User Namespace Documentation](https://linuxcontainers.org/lxc/security/)
- [Rootless Containers Guide](https://linuxcontainers.org/lxc/getting-started/)


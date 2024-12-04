# Podman Ansible Role

This role manages the installation and configuration of Podman, a daemonless container engine for OCI containers. It's designed to provide a rootless container runtime environment as an alternative to Docker.

## Overview

The role handles:
- Installation of Podman and related packages
- Registry configuration
- Rootless container support
- Podman Compose functionality
- Complete lifecycle management (install/remove)

## Features

### Core Components
- Podman engine
- Podman Compose for container orchestration
- crun container runtime
- Registry configuration management

### Registry Configuration
Default search registries:
- quay.io
- docker.io

Security features:
- Configurable insecure registries
- Registry blocking
- Short name resolution control

## Requirements

### Platform Support
- Debian/Ubuntu systems
- Systemd-based systems

### Prerequisites
- Systemd
- apt package manager
- Network access to container registries

## Role Variables

Simple configuration with one main control variable:

```yaml
podman_state: present    # Use 'absent' to remove Podman
```

## Dependencies

This role has no dependencies on other Ansible roles.

## Example Playbooks

### Basic Installation

```yaml
- hosts: servers
  roles:
    - role: podman
```

### Installation with Custom Options

```yaml
- hosts: servers
  vars:
    podman_state: present
  roles:
    - role: podman
```

### Complete Removal

```yaml
- hosts: servers
  vars:
    podman_state: absent
  roles:
    - role: podman
```

## File Structure

```
podman/
├── defaults/
│   └── main.yml                 # Default variables
├── files/
│   └── site-registries.conf     # Registry configuration
├── tasks/
│   └── main.yml                # Main tasks
└── vars/
    └── main.yml               # Role variables
```

## Registry Configuration

The role includes a default registry configuration with:

```conf
[registries.search]
registries = []

[registries.insecure]
registries = []

[registries.block]
registries = []

unqualified-search-registries = ["quay.io","docker.io"]
short-name-mode = "permissive"
```

This configuration:
- Defines default search registries
- Allows configuration of insecure registries
- Enables registry blocking
- Configures short name resolution

## Security Considerations

### Rootless Containers
- Runs containers without root privileges
- Improved security isolation
- Reduced attack surface

### Registry Security
- Configurable registry trust
- Insecure registry management
- Registry blocking capabilities

## Operational Notes

### Installation
- Installs podman-compose for orchestration
- Includes crun container runtime
- Configures system registries

### Removal
- Complete package removal
- Configuration cleanup
- Automatic dependency cleanup

## Troubleshooting

Common issues and solutions:
1. Registry access issues
   - Check network connectivity
   - Verify registry configuration
   - Check registry credentials
2. Container runtime issues
   - Verify crun installation
   - Check system resources
   - Validate user permissions

## License

MIT

## Author Information

Created by Jack Lavender, et al.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Future Development

Current goals include:
- Testing rootless systemd container support
- Optimizing for daemon containers
- Performance testing with applications like InfluxDB
- Enhanced rootless runtime capabilities

## Notes

- Designed for rootless container operations
- Focuses on security and simplicity
- Includes Podman Compose support
- Provides flexible registry configuration
- Supports complete lifecycle management

## Additional Resources

- [Podman Documentation](https://docs.podman.io/en/latest/)
- [Rootless Containers Guide](https://docs.podman.io/en/latest/markdown/podman.1.html#rootless-mode)
- [Podman Compose Documentation](https://docs.podman.io/en/latest/markdown/podman-compose.1.html)


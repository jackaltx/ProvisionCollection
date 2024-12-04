# Minikube Ansible Role

This role manages the installation and configuration of Minikube, a tool that makes it easy to run Kubernetes locally. It focuses on providing a simple development and learning environment for Kubernetes.

## Overview

The role handles:
- Installation of Minikube binary
- Optional kubectl installation
- Rootless Podman driver configuration
- Support scripts for initialization

## System Requirements

### Hardware Requirements
- 2 CPUs or more
- 2GB of free memory
- 20GB of free disk space
- Internet connection

### Supported Container/VM Managers
- Docker
- QEMU
- Hyperkit
- Hyper-V
- KVM
- Parallels
- Podman
- VirtualBox
- VMware Fusion/Workstation

## Role Variables

```yaml
# Installation control
minikube_state: 'present'        # Use 'absent' to remove Minikube
minikube_install_kubectl: true   # Whether to install kubectl binary
```

## Features

### Core Components
- Minikube binary installation
- Latest stable kubectl installation (optional)
- Rootless configuration support
- Containerd runtime integration

### Startup Configuration
Includes a startup script that configures:
- Podman driver
- Rootless operation
- Containerd runtime

## Dependencies

This role has no dependencies on other Ansible roles.

## Example Playbooks

### Basic Installation

```yaml
- hosts: servers
  roles:
    - role: minikube
```

### Installation without kubectl

```yaml
- hosts: servers
  vars:
    minikube_install_kubectl: false
  roles:
    - role: minikube
```

### Complete Removal

```yaml
- hosts: servers
  vars:
    minikube_state: absent
  roles:
    - role: minikube
```

## File Structure

```
minikube/
├── defaults/
│   └── main.yml                # Default variables
├── files/
│   └── start-minikube.sh      # Startup configuration script
├── tasks/
│   └── main.yml              # Main tasks
└── vars/
    └── main.yml             # Role variables
```

## Installation Details

### Minikube Installation
- Downloads latest version from Google Storage
- Installs to `/usr/local/bin/minikube`
- Sets appropriate permissions
- Includes startup configuration script

### kubectl Installation (Optional)
- Fetches latest stable version information
- Downloads from official Kubernetes repository
- Installs to `/usr/local/bin/kubectl`
- Sets appropriate permissions

## Configuration

### Default Startup Configuration
```bash
# Rootless configuration
minikube config set driver podman
minikube config set rootless true

# Container runtime configuration
minikube start --driver=podman --container-runtime=containerd
```

## Security Considerations

### Rootless Operation
- Runs without root privileges
- Uses Podman driver
- Improved security isolation

### Binary Verification
- Downloads from official sources
- Sets appropriate file permissions
- Runs with minimal privileges

## Operational Notes

### Installation
- Checks for existing installations
- Downloads only if necessary
- Configures for rootless operation

### Removal
- Removes Minikube binary
- Removes support scripts
- Clean uninstallation

## Troubleshooting

Common issues and solutions:
1. Resource constraints
   - Verify system meets minimum requirements
   - Check available disk space
   - Monitor memory usage
2. Container runtime issues
   - Verify Podman installation
   - Check container runtime status
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

## Usage Tips

### Starting Minikube
```bash
# Use the provided startup script
start-minikube

# Or use manual configuration
minikube start --driver=podman --container-runtime=containerd
```

### Working with kubectl
- Use `kubectl` directly when installed via this role
- Alternative: use `minikube kubectl --` if kubectl is not installed

## Additional Resources

- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Podman Driver Documentation](https://minikube.sigs.k8s.io/docs/drivers/podman/)

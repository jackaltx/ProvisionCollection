# ProvisionCollection

A comprehensive collection of Ansible roles for provisioning homelab environments on Debian 12 and Rocky Linux 9.

## Overview

This repository contains a set of carefully crafted Ansible roles designed to streamline homelab infrastructure deployment and maintenance. The primary goal is to transform manual, pet-like infrastructure management into a reproducible, cattle-based approach through solid DevOps principles.

### Key Features

- Full support for Debian 12 and Rocky Linux 9
- Idempotent installation and removal processes
- Comprehensive testing support
- Spans from basic workstation setups to complex service deployments
- Focus on reproducibility and standardization

## Available Roles

### Development & Workstation
- `vs-code`: Visual Studio Code installation and configuration
- `podman`: Container management tool deployment
- `minikube`: Local Kubernetes development environment

### Infrastructure & Storage
- `nfs-client`: NFS client setup and mount configuration
- `lxc`: Linux Container infrastructure
- `wireguard`: VPN server and client setup

### Monitoring Stack
- `grafana`: Data visualization and dashboards
- `influxdb`: Time series database
- `telegraf`: Metrics collection agent
- `loki`: Log aggregation system
- `promtail`: Log forwarding agent  (deprecating)
- `alloy`: Log forwarding agent

### Services
- `mailsvc`: Complete email service deployment
- `gitea`: Self-hosted Git service
- `mariadb`: MySQL-compatible database server

### Utility
- `quiet-rtkit`: Quiet the rt-kit daemon
- `shared`: Common resources and configurations

## Getting Started

### Prerequisites
- Ansible 2.9 or higher
- Target systems running Debian 12 or Rocky Linux 9
- SSH access to target systems

### Installation
```bash
git clone [repository-url]
cd ProvisionCollection
```

### Usage
```bash
# Example playbook execution
ansible-playbook -i inventory playbooks/[playbook-name].yml
```

## Role Documentation

Each role includes:
- Detailed README with usage instructions
- Default variables with documentation
- Example playbooks
- Testing procedures

## Testing

The roles are designed with testability in mind:
- Idempotent installations and removals
- Support for limited resource environments
- Reproducible configurations

## Roadmap

### Planned Improvements
- ProxMox LXC integration
- Enhanced security features
- Additional role documentation
- Expanded testing coverage

### Under Consideration
- Container orchestration improvements
- Backup and disaster recovery solutions
- Configuration management enhancements

## Contributing

Contributions are welcome! Please feel free to submit pull requests or create issues for bugs and feature requests.

## License

[License Information Needed]

## Acknowledgments

- Documentation assistance provided by Claude AI
- Community contributions and feedback

---
*Note: This project is under active development. Role capabilities and documentation are continuously being improved.*

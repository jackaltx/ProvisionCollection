# MariaDB Role

An Ansible role for deploying and managing MariaDB database servers with a focus on security and maintainability.

## Features

- Automated MariaDB installation and configuration
- Security-focused installation with optional hardening
- Support for database initialization scripts
- Built-in backup functionality
- Support for both Debian 12 and Rocky Linux 9
- Easy removal/cleanup capability

## Prerequisites

- Target system running Debian 12 or Rocky Linux 9
- Ansible 2.10 or higher
- Sufficient disk space for database storage
- Access to official package repositories

## Role Variables

### Required Variables

```yaml
# Root password for MariaDB
mariadb_mysql_root_password: ""
```

### Optional Variables

```yaml
# State management
mariadb_state: present  # Use 'absent' to remove
mariadb_remove_data: false  # Set to true to remove data directories during removal

# Security options
mariadb_security: true  # Enable security hardening
mariadb_remove_anonymous: yes  # Remove anonymous users
mariadb_remove_test_db: yes   # Remove test database

# Configuration options
mariadb_bind_address: "127.0.0.1"  # Network binding
mariadb_port: 3306               # Port to listen on
```

## Dependencies

- None

## Example Playbook

### Basic Installation

```yaml
---
- name: Install MariaDB
  hosts: database_servers
  become: true
  vars:
    mariadb_mysql_root_password: "secure_password_here"
    mariadb_state: present
    mariadb_security: true
  roles:
    - mariadb
```

### Complete Removal

```yaml
---
- name: Remove MariaDB
  hosts: database_servers
  become: true
  vars:
    mariadb_state: absent
    mariadb_remove_data: true
    mariadb_mysql_root_password: "your_root_password"
  roles:
    - mariadb
```

## Role Tags

- `packages`: Package installation tasks
- `config`: Configuration tasks
- `security`: Security-related tasks
- `service`: Service management tasks
- `backup`: Backup related tasks
- `cleanup`: Cleanup tasks when removing services

## Security Features

When `mariadb_security: true`:
1. Removes anonymous users
2. Removes test database
3. Disables remote root login
4. Sets up root password
5. Configures secure defaults

## What Gets Removed

When running with `mariadb_state: absent`:

1. **Services Stopped**
   - mariadb service stopped and disabled

2. **Packages Removed**
   - mariadb-server and related packages
   - Package cleanup on Debian systems

3. **With `mariadb_remove_data: true`**
   - Database directory (/var/lib/mysql)
   - Configuration files
   - Log files

## Backup and Restore

The role supports basic backup functionality:

1. **Creating Backups**
   - Automated backup during configuration changes
   - Backup stored in specified backup directory

2. **Backup Location**
   - Default: /var/backup/mysql
   - Configurable through variables

## Post-Installation Steps

After installation:

1. Verify MariaDB is running:
   ```bash
   systemctl status mariadb
   ```

2. Test database connection:
   ```bash
   mysql -u root -p
   ```

3. Check secure installation:
   ```bash
   mysql -u root -p -e "SELECT user,host FROM mysql.user;"
   ```

## Troubleshooting

Common issues and solutions:

1. **Service Won't Start**
   - Check system logs: `journalctl -u mariadb`
   - Verify permissions on data directory

2. **Can't Connect**
   - Check bind address configuration
   - Verify firewall settings
   - Ensure correct credentials

3. **Permission Issues**
   - Check file permissions in /var/lib/mysql
   - Verify mysql user ownership

## License

BSD

## Author Information

Created by [Your Name]
Maintained by [Your Organization]

## Support

File issues on GitHub or contact [your support email]

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request


# Mailsvc Role

A comprehensive Ansible role for deploying and managing a complete mail server solution using Postfix, Dovecot, PostfixAdmin, and Roundcube.

## Features

- Complete mail server deployment with virtual domains support
- Web-based administration interface (PostfixAdmin)
- Web-based mail client (Roundcube)
- Spam filtering with Rspamd
- TLS/SSL support for secure mail transmission
- Virtual mailbox support using MySQL backend
- Log rotation with proper permissions
- Support for both Debian 12 and Rocky Linux 9

## Prerequisites

- Target system running Debian 12 or Rocky Linux 9
- MariaDB/MySQL server installed and configured
- SSL certificates for the mail domain
- DNS records properly configured for mail service
- Ansible 2.10 or higher

## Role Variables

### Required Variables

```yaml
# MySQL root password for database creation
mailsvc_mysql_root_password: ""

# Domain configuration
mailsvc_domain: "example.com"
mailsvc_hostname: "mail.example.com"

# SSL certificate paths
ssl_cert_file: "/etc/ssl/certs/{{ mailsvc_hostname }}.crt"
ssl_key_file: "/etc/ssl/private/{{ mailsvc_hostname }}.key"

# PostfixAdmin settings
postfixadmin_admin_email: "admin@{{ mailsvc_domain }}"
```

### Optional Variables

```yaml
# State management
mailsvc_state: present  # Use 'absent' to remove
mailsvc_remove_config: true  # Remove configuration when state is absent
mailsvc_remove_data: false   # Remove data when state is absent

# Database configurations (if needed to override defaults)
postfixadmin_db:
  name: postfixadmin
  user: postfixadmin
  host: localhost
  port: 3306

roundcube_db:
  name: roundcube
  user: roundcube
  host: localhost
  port: 3306

# Redis configuration for Rspamd
redis_bind_address: "127.0.0.1"
redis_port: 6379
```

## Dependencies

- Community MySQL collection: `community.mysql`
- Working MySQL/MariaDB installation

## Example Playbook

```yaml
---
- name: Deploy mail server
  hosts: mailserver
  become: true
  vars:
    mailsvc_mysql_root_password: "secure_password_here"
    mailsvc_domain: "example.com"
    mailsvc_hostname: "mail.example.com"
    mailsvc_state: present
  roles:
    - mailsvc
```
## Complete Removal

To completely remove all mail services, databases, and configurations:

```yaml
---
- name: Remove mail server completely
  hosts: mailserver
  become: true
  vars:
    mailsvc_state: absent
    mailsvc_remove_config: true
    mailsvc_remove_data: true
    mailsvc_mysql_root_password: "your_mysql_root_password"
  roles:
    - mailsvc
```

### What Gets Removed

When running with `mailsvc_state: absent`:

1. **Services Stopped and Disabled**
   - nginx
   - postfix
   - dovecot
   - php-fpm
   - rspamd
   - redis-server

2. **With `mailsvc_remove_config: true`**
   - All configuration files from:
     - /etc/postfix
     - /etc/dovecot
     - /etc/postfixadmin
     - /etc/nginx
     - /etc/rspamd
     - /etc/roundcube
     - /etc/redis

3. **With `mailsvc_remove_data: true`**
   - All data directories:
     - /var/lib/postfix
     - /var/lib/dovecot
     - /var/lib/rspamd
     - /var/lib/roundcube
     - /var/lib/redis
   - Databases:
     - postfixadmin database
     - roundcube database
   - Database users:
     - postfixadmin user
     - roundcube user

### Clean Up After Removal

After running the removal playbook, you may want to:

1. Verify removal of mail-related databases:
   ```sql
   mysql -u root -p
   SHOW DATABASES;
   ```

2. Check for any remaining processes:
   ```bash
   ps aux | grep -E 'postfix|dovecot|rspamd|nginx'
   ```

3. Verify configuration cleanup:
   ```bash
   ls -la /etc/{postfix,dovecot,postfixadmin,nginx/conf.d,rspamd,roundcube}
   ```

4. Check data directory cleanup:
   ```bash
   ls -la /var/lib/{postfix,dovecot,rspamd,roundcube}
   ```

### DNS Records

After removal, remember to:
1. Remove or update MX records
2. Remove SPF records
3. Remove DKIM records
4. Remove DMARC records

This ensures no mail is attempted to be delivered to the removed mail server.

## Required DNS Records

Ensure these DNS records are set up:

```
# MX record
example.com.    IN    MX    10    mail.example.com.

# A record for mail server
mail.example.com.    IN    A    203.0.113.1

# SPF record
example.com.    IN    TXT    "v=spf1 mx -all"

# DKIM (after configuration)
default._domainkey.example.com.    IN    TXT    "v=DKIM1; k=rsa; p=..."

# DMARC
_dmarc.example.com.    IN    TXT    "v=DMARC1; p=quarantine; rua=mailto:postmaster@example.com"
```

## Security Considerations

1. **SSL/TLS Certificates**
   - Must be valid and trusted certificates
   - Proper permissions required
   - Regular renewal process recommended

2. **Database Security**
   - Strong passwords for database users
   - Restricted database access to localhost only
   - Regular backup procedures recommended

3. **Mail Security**
   - SPF, DKIM, and DMARC records recommended
   - Regular monitoring of mail logs
   - Rspamd configuration for spam protection

## Role Tags

- `packages`: Package installation tasks
- `database`: Database setup tasks
- `mailconfig`: Mail service configuration tasks
- `webconfig`: Web interface configuration tasks
- `ssl_check`: SSL certificate verification
- `postfixadmin_setup`: PostfixAdmin specific tasks
- `log_access`: Log rotation configuration
- `services`: Service management tasks
- `cleanup`: Cleanup tasks when removing services

## License

BSD

## Author Information

Created by [Your Name] with assistance from Claude
Maintained by [Your Organization]

## Support

File issues on GitHub or contact [your support email]

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request


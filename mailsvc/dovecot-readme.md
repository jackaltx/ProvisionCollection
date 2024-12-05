# Dovecot Configuration Guide

## Overview
This document explains the Dovecot configuration structure used in the mail server setup. The configuration is organized into logical sections for easier maintenance and understanding.

## Main Sections

### Protocol and SSL Configuration
```
protocols = imap lmtp sieve
```
- **IMAP**: Email access protocol
- **LMTP**: Local mail transfer protocol for efficient delivery
- **Sieve**: Email filtering protocol

SSL settings ensure secure communication with strong encryption:
```
ssl = required
ssl_min_protocol = TLSv1.2
ssl_cipher_list = EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH
```

### Mail Storage
```
mail_location = maildir:/var/vmail/%d/%n
```
- Uses Maildir format
- %d = domain
- %n = username
- Example: /var/vmail/example.com/user/

### Service Configurations

#### LMTP Service
Handles local mail delivery from Postfix to Dovecot:
```
service lmtp {
  unix_listener /var/spool/postfix/private/dovecot-lmtp {
    mode = 0600
    user = postfix
    group = postfix
  }
}
```

#### Authentication Service
Provides authentication services to Postfix:
```
service auth {
  unix_listener /var/spool/postfix/private/auth {
    mode = 0660
    user = postfix
    group = postfix
  }
}
```

#### IMAP Service
Handles email client connections:
```
service imap-login {
  inet_listener imap {
    port = 143
  }
  inet_listener imaps {
    port = 993
    ssl = yes
  }
}
```

### Protocol-Specific Settings

#### IMAP Protocol
```
protocol imap {
  mail_plugins = $mail_plugins quota imap_quota
  imap_idle_notify_interval = 29 mins
  mail_max_userip_connections = 20
}
```
- Enables quota support
- Sets IDLE notification interval
- Limits connections per IP

### Sieve Filtering
```
plugin {
  sieve = file:~/sieve;active=~/.dovecot.sieve
  sieve_max_script_size = 1M
  sieve_quota_max_scripts = 20
}
```
- Enables email filtering
- Sets script size limits
- Limits number of scripts per user

### Quota Management
```
plugin {
  quota = maildir:User quota
  quota_rule = *:storage=1G
  quota_rule2 = Trash:storage=100M
}
```
- Sets default quota to 1GB
- Limits Trash folder to 100MB
- Configures quota status responses

### Mailbox Configuration
```
namespace inbox {
  inbox = yes
  separator = /
  mailbox Drafts {
    auto = subscribe
    special_use = \Drafts
  }
  [...]
}
```
- Defines special folders
- Enables auto-subscription
- Sets folder separator

## Authentication Configuration
Uses SQL backend for user authentication:
```
userdb {
  driver = sql
  args = /etc/dovecot/dovecot-sql.conf.ext
}
```

## Performance Settings
```
mail_fsync = optimized
service_count = 1
process_min_avail = 3
```
- Optimizes disk I/O
- Controls service processes
- Ensures minimum available processes

## Security Considerations
- SSL is required
- Strong cipher configuration
- Proper file permissions on Unix sockets
- Limited script sizes for Sieve
- Connection limits per IP

## Debugging
Debugging can be enabled by uncommenting:
```
#auth_debug = yes
#auth_debug_passwords = yes
```

## File Organization
Configuration is split across several files:
- `dovecot.conf`: Main configuration file
- `dovecot-sql.conf.ext`: SQL authentication settings
- Additional configuration in `/etc/dovecot/conf.d/`

## Common Tasks

### Adding New Mailboxes
- Create through PostfixAdmin
- Directory structure created automatically
- Quota applies immediately

### Modifying Quotas
- Edit quota rules in configuration
- Restart Dovecot service
- Or use doveadm for per-user quotas

### Enabling Features
Add required plugins to mail_plugins line:
```
mail_plugins = $mail_plugins <plugin_name>
```

## Maintenance

### Service Management
```bash
systemctl status dovecot    # Check service status
systemctl restart dovecot   # Restart service
doveadm reload             # Reload configuration
```

### Checking Logs
```bash
tail -f /var/log/mail.log  # Monitor mail logs
doveadm log errors         # View error logs
```

### Quota Verification
```bash
doveadm quota get -u user@domain.com
doveadm quota recalc -u user@domain.com
```

# Dovecot Configuration Testing Guide

## Prerequisites Testing
1. Check MySQL Service:
```bash
systemctl status mysql
mysql -e "SELECT VERSION();"
```

2. Verify PostfixAdmin Database:
```bash
mysql -e "use postfixadmin; SHOW TABLES;"
mysql -e "use postfixadmin; SELECT COUNT(*) FROM domain;"
mysql -e "use postfixadmin; SELECT COUNT(*) FROM mailbox;"
```

## Authentication Testing

1. Test Database Connection:
```bash
mysql -u postfixadmin -p'yourpassword' postfixadmin -e "SELECT 1;"
```

2. Check User/Mailbox Settings:
```bash
# List all mailboxes
mysql -e "use postfixadmin; SELECT username, domain, maildir, active FROM mailbox;"

# Check specific user
mysql -e "use postfixadmin; SELECT * FROM mailbox WHERE username='user@domain.com';"
```

## Directory Structure Testing

1. Check Mail Directory:
```bash
# Verify base directory
ls -la /var/vmail/

# Check domain directory
ls -la /var/vmail/domain.com/

# Check user maildir
ls -la /var/vmail/domain.com/user/
```

2. Verify Permissions:
```bash
# Check ownership
find /var/vmail -type f -exec stat -c "%U:%G" {} \;

# Check directory permissions
find /var/vmail -type d -exec stat -c "%a %n" {} \;
```

## Dovecot Service Testing

1. Check Service Status:
```bash
systemctl status dovecot
doveadm service list
```

2. Test SSL Configuration:
```bash
openssl s_client -connect localhost:993
```

3. Test IMAP Login:
```bash
# Connect to IMAPS
openssl s_client -connect localhost:993

# At the prompt:
a1 login user@domain.com password
a2 list "" "*"
a3 select INBOX
```

## Quota Testing

1. Check Quota Settings:
```bash
# View quota settings in database
mysql -e "use postfixadmin; SELECT username, quota FROM mailbox;"

# Check actual quota usage
doveadm quota get -u user@domain.com
doveadm quota recalc -u user@domain.com
```

2. Test Quota Enforcement:
```bash
# Create large test message
dd if=/dev/zero of=test.msg bs=1M count=100

# Try to deliver it (should fail if over quota)
sendmail user@domain.com < test.msg
```

## Sieve Testing

1. Check Sieve Service:
```bash
netstat -tlnp | grep 4190
```

2. Test Sieve Scripts:
```bash
# Check Sieve directory
ls -la /var/vmail/domain.com/user/sieve/

# Create test script
cat > test.sieve << EOF
require ["fileinto"];
if header :contains "Subject" "Test" {
    fileinto "Test";
}
EOF

# Compile and check script
sievec test.sieve
```

## Performance Testing

1. Check Connections:
```bash
# View current connections
doveadm who

# Check connection limits
doveadm director status
```

2. Monitor Resource Usage:
```bash
# Watch process stats
watch -n 1 'ps aux | grep dovecot'

# Monitor system resources
top -p $(pgrep -d ',' dovecot)
```

## Log Analysis

1. Check Authentication Logs:
```bash
# Enable detailed logging temporarily
echo "auth_debug=yes" >> /etc/dovecot/conf.d/10-logging.conf
systemctl restart dovecot

# Monitor logs
tail -f /var/log/mail.log | grep dovecot

# Test login and check logs
```

2. Check Error Logs:
```bash
# View recent errors
doveadm log errors

# Check for failed logins
grep "auth failed" /var/log/mail.log
```

## Common Issues and Tests

1. Authentication Problems:
```bash
# Check password scheme
mysql -e "use postfixadmin; SELECT username, password FROM mailbox LIMIT 1;"

# Verify auth mechanisms
doveconf -n | grep auth_mechanisms
```

2. Permission Issues:
```bash
# Check vmail user
id vmail

# Verify mail directory ownership
find /var/vmail -not -user vmail -ls
```

3. SSL Certificate Issues:
```bash
# Verify certificate
openssl x509 -in /etc/ssl/certs/mailsvc0.a0a0.org.crt -text -noout

# Check private key
openssl rsa -in /etc/ssl/private/mailsvc0.a0a0.org.key -check
```

## Cleanup After Testing

```bash
# Disable debug logging
sed -i '/auth_debug/d' /etc/dovecot/conf.d/10-logging.conf

# Remove test files
rm test.msg test.sieve

# Restart service
systemctl restart dovecot
```

Remember to:
- Replace 'user@domain.com' with actual test account
- Use appropriate passwords
- Clean up test data after verification
- Document any issues found during testing

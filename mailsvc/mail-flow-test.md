# Mail System Flow Testing Guide

## 1. System Status Checks

### Check All Services
```bash
for service in postfix mysql redis-server rspamd dovecot; do
    echo "=== $service status ==="
    systemctl status $service
done
```

### Network Ports
```bash
# Check all relevant ports
netstat -tlnp | grep -E ':(25|587|11334|3306|6379|143|993|4190)'

# Expected Results:
# 25 (SMTP) - Postfix
# 587 (Submission) - Postfix
# 11334 - RSpamd
# 3306 - MySQL
# 6379 - Redis
# 143 - IMAP
# 993 - IMAPS
# 4190 - Sieve
```

## 2. MySQL Testing

### Database Connectivity
```bash
# Test MySQL connection
mysql -e "SELECT VERSION();"

# Check PostfixAdmin database
mysql -e "use postfixadmin; SHOW TABLES;"
```

### Mail Routing Tables
```bash
# Check domains
mysql -e "use postfixadmin; SELECT domain,active FROM domain;"

# Check mailboxes
mysql -e "use postfixadmin; SELECT username,domain,active FROM mailbox;"

# Check aliases
mysql -e "use postfixadmin; SELECT address,goto,active FROM alias;"
```

## 3. Postfix Testing

### Configuration Check
```bash
# Test configuration
postfix check
postconf -n

# Check MySQL map files
postmap -q example.com mysql:/etc/postfix/mysql_virtual_domains.cf
postmap -q user@example.com mysql:/etc/postfix/mysql_virtual_mailboxes.cf
postmap -q user@example.com mysql:/etc/postfix/mysql_virtual_aliases.cf
```

### SMTP Tests
```bash
# Test SMTP connection
telnet localhost 25
EHLO test.com
QUIT

# Test Submission port (587)
telnet localhost 587
EHLO test.com
STARTTLS
QUIT
```

### Send Test Emails
```bash
# Local delivery test
echo "Test message" | sendmail user@example.com

# External delivery test
echo "Test message" | sendmail -v user@gmail.com
```

## 4. RSpamd Testing

### RSpamd Status
```bash
# Check RSpamd worker status
rspamc stat

# Check configuration
rspamadm configtest

# Check symbols
rspamc symbols < test-email.txt
```

### Redis Connection
```bash
# Test Redis connection
redis-cli ping

# Check RSpamd keys in Redis
redis-cli keys 'rs*'

# Monitor Redis in real-time
redis-cli monitor
```

### RSpamd Learning
```bash
# Train spam/ham
rspamc learn_spam < spam.eml
rspamc learn_ham < ham.eml

# Check statistics
rspamc statistic
```

## 5. Mail Flow Testing

### Complete Flow Test
1. Create test email:
```bash
cat > test-email.txt << EOF
From: sender@external.com
To: user@example.com
Subject: Test Email Flow

This is a test message.
EOF
```

2. Submit through system:
```bash
sendmail user@example.com < test-email.txt
```

3. Check logs for flow:
```bash
# Follow all relevant logs
tail -f /var/log/mail.log | grep -E '(postfix|rspamd|dovecot)'
```

### Headers Check
```bash
# Check headers of delivered mail
cat /var/vmail/example.com/user/new/* | grep -A20 "^From "
```

## 6. Performance Testing

### Queue Management
```bash
# Check Postfix queue
postqueue -p

# Check deferred mail
find /var/spool/postfix/deferred -type f | wc -l
```

### RSpamd Performance
```bash
# Check processing time
rspamc fuzzy_check test-email.txt -t 

# Check scan queue
rspamc stat
```

### Redis Performance
```bash
# Check Redis stats
redis-cli info stats

# Monitor Redis memory
redis-cli info memory
```

## 7. Security Testing

### SSL/TLS Check
```bash
# Test SMTP TLS
openssl s_client -starttls smtp -connect localhost:25

# Test IMAPS
openssl s_client -connect localhost:993
```

### Authentication
```bash
# Test SMTP AUTH
swaks --server localhost:587 --tls --auth PLAIN --auth-user user@example.com

# Test IMAP AUTH
openssl s_client -connect localhost:993
# Then: a1 login user@example.com password
```

### Spam Detection
```bash
# Test with GTUBE pattern
echo 'XJS*C4JDBQADN1.NSBN3*2IDNEN*GTUBE-STANDARD-ANTI-UBE-TEST-EMAIL*C.34X' | rspamc symbols
```

## 8. Troubleshooting Commands

### Log Analysis
```bash
# Check all mail flow for specific address
grep -r "user@example.com" /var/log/mail.log

# Check RSpamd actions
grep "rspamd_task" /var/log/mail.log

# Check authentication failures
grep "authentication failed" /var/log/mail.log
```

### Queue Management
```bash
# View queue content
postqueue -p

# Flush queue
postqueue -f

# Delete specific message
postsuper -d QUEUEID
```

### Connection Testing
```bash
# Test all components
for port in 25 587 11334 3306 6379 143 993; do
    nc -zv localhost $port
done
```

## 9. Cleanup After Testing

```bash
# Remove test files
rm test-email.txt

# Clear Redis test data
redis-cli FLUSHDB

# Clear test emails
postsuper -d ALL

# Reset logs
truncate -s 0 /var/log/mail.log
```

## 10. Common Issues

### Authentication Failures
```bash
# Check MySQL authentication
mysql -u postfix -p'password' postfixadmin -e "SELECT 1;"

# Check Dovecot auth
doveadm auth test user@example.com
```

### Mail Delivery Issues
```bash
# Check permissions
find /var/vmail -type d -exec stat -c "%U:%G %a %n" {} \;

# Check mail queue
mailq
```

### RSpamd Issues
```bash
# Check RSpamd user/group
ps aux | grep rspamd

# Test Redis connection
redis-cli ping
```

Remember to:
- Replace example.com with your actual domain
- Use real credentials in tests
- Clean up test data after verification
- Document any issues found

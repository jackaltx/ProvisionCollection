# managing mail quotas in your setup. There are several layers:

1. Check current quota settings in PostfixAdmin:
```bash
mysql -e "use postfixadmin; SELECT username, quota FROM mailbox;"
```

2. Check Dovecot's quota configuration in /etc/dovecot/conf.d/90-quota.conf:
```bash
cat /etc/dovecot/conf.d/90-quota.conf
```

To set up quotas:

1. Enable quota plugin in Dovecot:
```
mail_plugins = $mail_plugins quota
```

2. Configure quota settings:
```
plugin {
  quota = maildir:User quota
  quota_rule = *:storage=1G
  quota_rule2 = Trash:storage=100M
}
```

3. Check quota usage for a user:
```bash
doveadm quota get -u jack@a0a0.org
```

4. Set quota for a specific user through PostfixAdmin web interface or CLI:
```bash
doveadm quota set -u jack@a0a0.org 2GB
```

## Let me demonstrate the correct usage of doveadm quota commands.

1. To get current quota usage:
```bash
doveadm quota get -u jack@a0a0.org
```

2. To recalculate quota:
```bash
doveadm quota recalc -u jack@a0a0.org
```

You can also verify quota in several other ways:

1. Check PostfixAdmin database:
```bash
mysql -e "use postfixadmin; SELECT username, quota FROM mailbox WHERE username='jack@a0a0.org';"
```

2. Check maildir size directly:
```bash
du -sh /var/vmail/a0a0.org/jack
```

3. Check the quota configured in Dovecot:
```bash
grep -r quota /etc/dovecot/conf.d/
```

Would you like to see the current quota usage for jack@a0a0.org?

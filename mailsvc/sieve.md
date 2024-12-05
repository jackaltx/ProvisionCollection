# Sieve 

Sieve is a protocol/language for email filtering. It allows users to create rules to filter and process incoming mail. 

1. Install required packages:
```bash
apt install dovecot-sieve dovecot-managesieved
```

2. Edit /etc/dovecot/conf.d/20-managesieve.conf:
```
service managesieve-login {
  inet_listener sieve {
    port = 4190
  }
}
```

3. Add to /etc/dovecot/conf.d/15-lda.conf:
```
protocol lda {
  mail_plugins = $mail_plugins sieve
}
```

4. Edit /etc/dovecot/conf.d/90-sieve.conf:
```
plugin {
  sieve = file:~/sieve;active=~/.dovecot.sieve
  sieve_before = /var/lib/dovecot/sieve/before.sieve
  sieve_after = /var/lib/dovecot/sieve/after.sieve
  sieve_dir = ~/sieve
}
```

5. Create directories and set permissions:
```bash
mkdir -p /var/lib/dovecot/sieve/
chmod 755 /var/lib/dovecot/sieve
chown vmail:vmail /var/lib/dovecot/sieve
```

6. Restart Dovecot:
```bash
systemctl restart dovecot
```

Would you like me to explain what each of these configurations does?


Sieve is useful for email filtering and organization. Here are the practical benefits:

1. Server-side Email Rules
- Filters run on the server before mail reaches your inbox
- Works even when email client is offline
- More efficient than client-side filters

2. Common Use Cases:
- Auto-sort emails into folders
- Set up vacation/out-of-office replies
- Filter spam or unwanted emails
- Forward specific emails
- Send automatic replies based on conditions
- File emails from specific senders into designated folders

3. User Control
- Users can manage their own filters through webmail
- No need for admin intervention for basic mail rules
- Roundcube has a Sieve plugin for easy rule creation

4. Example Scenarios:
- Move all newsletters to a "Newsletters" folder
- Auto-reply to customer inquiries
- Sort emails based on importance or sender
- Forward work emails to colleagues when on vacation

Would you like to see some practical examples of Sieve rules?
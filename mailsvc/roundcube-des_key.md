The DES key in Roundcube (`$config['des_key'] = '5FxmuedZTukoeDjn71QkDzfX'`) is used for encryption of sensitive data like stored passwords and session variables.

To generate a new DES key for Roundcube, you can use several methods:

1. Using PHP:
```php
php -r 'echo bin2hex(random_bytes(24)) . "\n";'
```

2. Using OpenSSL:
```bash
openssl rand -base64 24
```

3. Using the Roundcube installer's built-in function:
```bash
cd /usr/share/roundcube
./bin/install-jsdeps.sh --des-key
```

The key should be:
- At least 24 characters long
- Contain random characters
- Be unique to each Roundcube installation
- Kept secret as it's used for security purposes

The key in your current config (`5FxmuedZTukoeDjn71QkDzfX`) appears to be Base64 encoded and 24 characters long, which matches the recommended format.V
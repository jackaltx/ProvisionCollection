SET GLOBAL validate_password_policy=STRONG;
SET GLOBAL validate_password_length=12;
DELETE FROM mysql.user WHERE Password = '';
FLUSH PRIVILEGES;

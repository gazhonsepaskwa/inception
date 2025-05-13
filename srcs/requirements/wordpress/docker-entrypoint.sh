#!/bin/bash
set -ex

sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf
chown -R www-data:www-data /var/www/html

if [ ! -f /var/www/html/wp-config.php ]; then
wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz \
    && mkdir -p /var/www/html \
    && tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1 \
    && rm /tmp/wordpress.tar.gz

cat <<EOF > /var/www/html/wp-config.php
<?php
define('DB_NAME',     '${MYSQL_DATABASE}');
define('DB_USER',     '${MYSQL_USER}');
define('DB_PASSWORD', '${MYSQL_PASSWORD}');
define('DB_HOST',     '${DB_HOST}');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
\$table_prefix = 'wp_';
define('WP_DEBUG', false);
if (!defined('ABSPATH')) {
    define('ABSPATH', dirname(__FILE__) . '/');
}
require_once ABSPATH . 'wp-settings.php';
EOF

echo "installing..."

wp core install --allow-root --path=/var/www/html --url=nalebrun.42.fr --title="1 sept i+" --admin_user="${WP_ADMIN_NAME}" --admin_password="${WP_ADMIN_PASSWORD}" --admin_email="${WP_ADMIN_EMAIL}"

wp user create "${WP_USER_NAME}" "${WP_USER_EMAIL}" --allow-root --path=/var/www/html --role="author" --user_pass="${WP_USER_PASSWORD}"

fi

echo "Starting PHP-FPM..."
exec php-fpm7.4 -F

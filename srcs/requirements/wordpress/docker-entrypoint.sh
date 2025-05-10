#!/bin/bash
set -e

echo -n "Waiting for MariaDB to be accessible"
until nc -z "${WORDPRESS_DB_HOST}" 3306; do
    echo -n "."
    sleep 2
done
echo "\nMariaDB is up - continuing"

if [ ! -f /var/www/html/wp-config.php.template ]; then
    echo "Error: wp-config.php.template not found in /var/www/html"
    exit 1
fi

envsubst < /var/www/html/wp-config.php.template > /var/www/html/wp-config.php

chown -R www-data:www-data /var/www/html

sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

mkdir -p /run/php/

echo "Starting php srv"
exec php-fpm7.4 -F -v
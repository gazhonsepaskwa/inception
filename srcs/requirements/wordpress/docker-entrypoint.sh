#!/bin/bash
set -e

envsubst < /var/www/html/wp-config.php.template > /var/www/html/wp-config.php

chown -R www-data:www-data /var/www/html

sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

mkdir -p /run/php/

echo "Starting php srv"
exec php-fpm7.4 -F -v
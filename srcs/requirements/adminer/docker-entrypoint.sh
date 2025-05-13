#!/bin/bash
set -ex

sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf
chown -R www-data:www-data /var/www/html


echo "Starting PHP-FPM..."
exec php-fpm7.4 -F

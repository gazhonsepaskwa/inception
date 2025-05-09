#!/bin/bash
set -e

envsubst < /var/www/wordpress/wp-config.php.template > /var/www/wordpress/wp-config.php

chown www-data:www-data /var/www/wordpress/wp-config.php

sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

mkdir /run/php/

echo "Starting php srv"
exec php-fpm7.4 -F -v

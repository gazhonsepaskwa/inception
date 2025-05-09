#!/bin/bash
set -e

envsubst < /var/www/wordpress/wp-config.php.template > /var/www/wordpress/wp-config.php

chown www-data:www-data /var/www/wordpress/wp-config.php

echo "Starting php srv"
exec php-fpm7.4 -v

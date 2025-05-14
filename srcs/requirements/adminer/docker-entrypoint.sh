#!/bin/bash

wget -O /var/www/html/index.php "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php"

echo "Starting PHP-FPM..."
exec php-fpm7.4 -F

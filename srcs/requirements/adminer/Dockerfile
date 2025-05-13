FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php php-fpm php-mysqli wget \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html && \
    wget -O /var/www/html/index.php "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php"

RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/*/fpm/pool.d/www.conf

RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000

CMD ["php-fpm7.4", "-F"]


FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-zip wget unzip \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz \
    && tar -xzf /tmp/wordpress.tar.gz -C /var/www/ \
    && rm /tmp/wordpress.tar.gz

RUN chown -R www-data:www-data /var/www/wordpress

COPY docker-entrypoint.sh /entrypoint.sh
COPY wp-config.php.template /var/www/wordpress/wp-config.php.template

RUN chmod +x /entrypoint.sh

EXPOSE 9000
CMD ["/entrypoint.sh"]

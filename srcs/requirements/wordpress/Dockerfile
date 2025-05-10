FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-zip wget unzip gettext netcat\
    && rm -rf /var/lib/apt/lists/*

RUN wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz \
    && mkdir -p /var/www/html \
    && tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1 \
    && rm /tmp/wordpress.tar.gz

RUN chown -R www-data:www-data /var/www/html

COPY wp-config.php.template /var/www/html/

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["docker-entrypoint.sh"]

FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php php-fpm php-mysqli wget \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/*/fpm/pool.d/www.conf

RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/www/html

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN mkdir -p /run/php/

EXPOSE 9000

ENTRYPOINT ["docker-entrypoint.sh"]

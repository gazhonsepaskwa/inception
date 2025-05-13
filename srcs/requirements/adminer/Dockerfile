FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-zip wget unzip gettext netcat curl\
    && rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN mkdir -p /run/php/

EXPOSE 9000

ENTRYPOINT ["docker-entrypoint.sh"]

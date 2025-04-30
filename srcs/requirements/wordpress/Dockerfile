FROM wordpress:php8.2-fpm

RUN docker-php-ext-install pdo pdo_mysql 

RUN apt-get update && apt-get install -y curl && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

COPY docker-entrypoint-init.sh /usr/local/bin/docker-entrypoint-init.sh
ENTRYPOINT [/usr/local/bin/docker-entrypoint-init.sh]
CMD [php-fpm]

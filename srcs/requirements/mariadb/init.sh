#!/bin/bash

function mysql_root_exec {
    mysql -uroot "$@"
}

echo "Initializing database..."

mariadb-install-db --user=mysql --datadir=/var/lib/mysql  #|| { echo "Error: fatal"; exit 1; }
echo $?
exit 1

echo "Starting temporary MariaDB server..."
mysqld_safe --skip-networking &
pid="$!"

# Wait for server to be ready
until mysqladmin ping --silent; do
    sleep 1
done

echo "Configuring root user and database..."

if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
    echo >&2 'Error: MYSQL_ROOT_PASSWORD is not set'
    exit 1
fi

echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'; FLUSH PRIVILEGES;" | mysql_root_exec

if [ -n "$MYSQL_DATABASE" ]; then
    echo "Creating database: $MYSQL_DATABASE"
    echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" | mysql_root_exec -p"${MYSQL_ROOT_PASSWORD}"
else
    echo >&2 'Error: MYSQL_DATABASE is not set'
    exit 1
fi

if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ]; then
    echo "Creating user: $MYSQL_USER with access to database: $MYSQL_DATABASE"
    echo "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'; GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE:-*}\`.* TO '${MYSQL_USER}'@'%'; FLUSH PRIVILEGES;" | mysql_root_exec -p"${MYSQL_ROOT_PASSWORD}"
fi

echo "Running init scripts..."
for f in /docker-entrypoint-initdb.d/*; do
    case "$f" in
        *.sh)  echo "Running $f"; . "$f" ;;
        *.sql) echo "Running $f"; mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" < "$f" ;;
        *)     echo "Ignoring $f" ;;
    esac
done

echo "Shutting down temporary server..."
mysqladmin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
wait "$pid"


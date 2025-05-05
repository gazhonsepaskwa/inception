#!/bin/bash
set -e

DATADIR="/var/lib/mysql"

function mysql_root_exec() {
    mysql -uroot "$@"
}

if [ ! -d "$DATADIR/mysql" ]; then
    echo "Initializing database..."

    mysqld --initialize-insecure --user=mysql

    echo "Starting temporary MariaDB server..."
    mysqld_safe --skip-networking &
    pid="$!"

    until mysqladmin ping --silent; do
        sleep 1
    done

    echo "Configuring root user and database..."
    if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
        echo >&2 'Error: MYSQL_ROOT_PASSWORD is not set'
        exit 1
    i

    mysql_root_exec <<-EOSQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
    EOSQL

    if [ -n "$MYSQL_DATABASE" ]; then
        echo "Creating database: $MYSQL_DATABASE"
        mysql_root_exec -p"${MYSQL_ROOT_PASSWORD}" <<-EOSQL
            CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
        EOSQL
    fi

    if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ]; then
        echo "Creating user: $MYSQL_USER with access to database: $MYSQL_DATABASE"
        mysql_root_exec -p"${MYSQL_ROOT_PASSWORD}" <<-EOSQL
            CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
            GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE:-*}\`.* TO '${MYSQL_USER}'@'%';
            FLUSH PRIVILEGES;
        EOSQL
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
fi

echo "Starting MariaDB server..."
exec mysqld

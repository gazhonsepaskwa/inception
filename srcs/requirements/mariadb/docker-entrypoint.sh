#!/bin/bash
set -e

DATADIR="/var/lib/mysql"

# Check if database is initialized
if [ ! -d "$DATADIR/mysql" ]; then
    echo "Initializing database..."
    mysqld --initialize-insecure --user=mysql
    echo "Starting temporary MariaDB server..."
    mysqld_safe --skip-networking &
    pid="$!"

    # Wait for server to start
    until mysqladmin ping --silent; do
        sleep 1
    done

	# run init scripts
    echo "Running init scripts..."
    for f in /docker-entrypoint-initdb.d/*; do
        case "$f" in
            *.sh)  echo "Running $f"; . "$f" ;;
            *.sql) echo "Running $f"; mysql -uroot < "$f" ;;
            *)     echo "Ignoring $f" ;;
        esac
    done

    echo "Shutting down temporary server..."
    mysqladmin -uroot shutdown
    wait "$pid"
fi

echo "Starting MariaDB server..."
exec mysqld

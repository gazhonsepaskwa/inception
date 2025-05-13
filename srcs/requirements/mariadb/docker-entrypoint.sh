#!/bin/bash
set -e

DATADIR="/var/lib/mysql"

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld
chown -R mysql:mysql "$DATADIR"

if [ ! -f /var/lib/mysql/mysql ]; then
  /usr/local/bin/init.sh
fi

echo "Starting MariaDB server..."
exec gosu mysql mysqld

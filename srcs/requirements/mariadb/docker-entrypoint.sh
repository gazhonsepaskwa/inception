#!/bin/bash
set -e

DATADIR="/var/lib/mysql"

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld
chown -R mysql:mysql "$DATADIR"

if [ ! -d "$DATADIR/mysql" ]; then
  echo "Database not initialized, running init.sh..."
  /usr/local/bin/init.sh
fi

echo "Starting MariaDB server..."
exec gosu mysql mysqld

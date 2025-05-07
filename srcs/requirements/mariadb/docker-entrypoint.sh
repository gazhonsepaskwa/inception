#!/bin/bash
set -e

DATADIR="/var/lib/mysql"

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld
chown -R mysql:mysql "$DATADIR"

# should have a if statement lol, but it does not work..
  echo "Database not initialized, running init.sh..."
  /usr/local/bin/init.sh

echo "Starting MariaDB server..."
exec gosu mysql mysqld

#!/bin/bash
set -e

DATADIR="/var/lib/mysql"

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

echo "Starting MariaDB server..."
exec gosu mysql mysqld

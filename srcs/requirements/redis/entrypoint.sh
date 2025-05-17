#!/bin/bash
set -e 

chown -R redis:redis /data
chown -R redis:redis /var/lib/redis-stack/

exec gosu redis "$@"

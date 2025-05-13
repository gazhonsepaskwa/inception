set -e 

chown redis:redis /data

exec gosu redis

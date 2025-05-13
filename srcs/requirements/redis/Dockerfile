FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates lsb-release curl gpg gosu && \
    curl -fsSL https://packages.redis.io/gpg | gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg && \
    chmod 644 /usr/share/keyrings/redis-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" > /etc/apt/sources.list.d/redis.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends redis-stack-server && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 6379

COPY ./redis.conf /etc/redis/redis.conf
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN groupadd -r redis && useradd -r -g redis redis

ENTRYPOINT ["/entrypoint.sh"]
CMD ["redis-stack-server"]

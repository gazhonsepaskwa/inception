FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	nginx openssl \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir /etc/nginx/ssl 
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
	-out /etc/nginx/ssl/nalebrun.crt \
	-keyout /etc/nginx/ssl/nalebrun.key \
	-subj "/C=BE/ST=Bruxelles/L=Bruxelles/O=s19/CN=nalebrun/"

COPY default.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /var/www/static/
COPY ./website /srv/static/

RUN mkdir -p /run/nginx

EXPOSE 8000

CMD ["nginx", "-g", "daemon off;"]

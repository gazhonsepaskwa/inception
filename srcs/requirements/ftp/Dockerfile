FROM debian:bullseye

RUN apt-get update && apt-get install -y vsftpd && rm -rf /var/lib/apt/lists/*

RUN useradd -m ftpuser && echo ftpuser:ftppassword | chpasswd

RUN mkdir -p /home/ftpuser/ftp && chown ftpuser:ftpuser /home/ftpuser/ftp
RUN mkdir -p /var/run/vsftpd/empty/ && chmod 755 /var/run/vsftpd/empty/

COPY vsftpd.conf /etc/vsftpd.conf

EXPOSE 21 21100-21110

CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]

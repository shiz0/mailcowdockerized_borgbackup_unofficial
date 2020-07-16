FROM alpine:latest

RUN apk upgrade --no-cache
RUN apk add --no-cache borgbackup
RUN apk add --no-cache openssh-client
RUN apk add --no-cache rsync
RUN apk add --no-cache pcre-tools
RUN apk add --no-cache docker-cli

COPY backup.sh /root/backup.sh
COPY crontab /root/crontab
COPY entrypoint.sh /root/entrypoint.sh
RUN chown -R root:root /root
RUN chmod 0700 /root/backup.sh
RUN chmod 0700 /root/entrypoint.sh

ENTRYPOINT [ "/root/entrypoint.sh" ]

CMD ["sh", "-c", "crontab /root/crontab && crond -f"]

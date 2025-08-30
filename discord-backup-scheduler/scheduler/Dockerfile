FROM alpine:latest

RUN apk add --no-cache docker-cli docker-compose

COPY scripts/export.sh /bin/export.sh
RUN chmod +x /bin/export.sh

COPY cronjobs/crontab /etc/crontabs/root

ENTRYPOINT ["crond", "-f"]
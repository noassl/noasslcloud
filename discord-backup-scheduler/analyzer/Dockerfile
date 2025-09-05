FROM node:lts-alpine

CMD npx -y chat-analytics \
        -p discord \
        -i /exports/*.json \
        -o /reports/index.html \
        >> /var/log/discord-analytics/analyzer.log
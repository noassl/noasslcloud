FROM node:lts-alpine

ENTRYPOINT ["npx", "-y", "chat-analytics"]
CMD -p discord -i /exports/*.json -o /reports/index.html >> /var/log/discord-analytics/analyzer.log
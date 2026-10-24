FROM node:lts-alpine

RUN npm install --global chat-analytics@1.1.2

CMD ["sh", "-c", "exec chat-analytics -p discord -i /exports/*.json -o /reports/index.html"]
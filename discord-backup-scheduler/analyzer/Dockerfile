FROM node:lts-alpine3.24

RUN npm install --global chat-analytics@1.1.2

CMD ["sh", "-c", "exec chat-analytics -p discord -i /exports/*.json -o /reports/index.html"]

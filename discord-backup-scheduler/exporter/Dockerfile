FROM tyrrrz/discordchatexporter:stable

RUN apk add --no-cache jq

RUN mkdir /app
WORKDIR /app

# Copy script
COPY export.sh export.sh
RUN chmod +x export.sh

ENTRYPOINT ["/app/export.sh"]

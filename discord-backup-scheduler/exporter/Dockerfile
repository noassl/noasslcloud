FROM tyrrrz/discordchatexporter:stable

RUN mkdir /app
WORKDIR /app

# Copy script
COPY export.sh export.sh
RUN chmod +x export.sh

ENTRYPOINT ["/app/export.sh"]

FROM debian:bookworm-slim

# Install jq for JSON parsing, wget and unzip for downloading the exporter, and libicu72 as a dependency of the exporter
RUN apt-get update \
    && apt-get install jq wget unzip libicu72 -y

RUN mkdir /app
WORKDIR /app

# Copy script
COPY export.sh export.sh
RUN chmod +x export.sh

# Download and unpack the exporter
RUN wget -O exporter.zip https://github.com/Tyrrrz/DiscordChatExporter/releases/download/2.43.3/DiscordChatExporter.Cli.linux-x64.zip \
    && unzip -d exporter exporter.zip

ENTRYPOINT ["/app/export.sh"]

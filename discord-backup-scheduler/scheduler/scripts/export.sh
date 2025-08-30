#!/bin/sh

cd /app || (echo "/app not found, exiting." && exit)

docker compose run exporter
docker compose run analyzer

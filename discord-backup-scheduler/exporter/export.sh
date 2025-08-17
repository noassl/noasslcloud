#!/bin/bash

exportsDir="/exports"

workDir="/app"
mkdir -p "$workDir"

function exportPartial {
  lastExportFile=$(ls -1t "$exportsDir"/*.json | head -n 1)

  echo "Reading export from $lastExportFile."
  lastExport=$(jq -r .exportedAt "$lastExportFile")

  echo "Exporting messages since $lastExport"
  /app/exporter/DiscordChatExporter.Cli exportguild \
    -g "$2" \
    --format Json \
    -o "$1" \
    --include-threads all\
    --include-vc true\
    --after "$lastExport"
}

function exportFull {
  echo "Performing full export"
  /app/exporter/DiscordChatExporter.Cli exportguild \
    -g "$2" \
    --format Json \
    -o "$1" \
    --include-threads all \
    --include-vc true
}

function main {
  # Count json files in /out
  numFiles=$(ls -1 "$exportsDir"/*.json | wc -l)

  # If no json files are in /out, there hasn't been a prior export, so a full one needs to be performed
  if [ "$numFiles" -eq 0 ]; then
    exportFull "$exportsDir" "$GUILD_ID"
  else
    exportPartial "$exportsDir" "$GUILD_ID"
  fi
}

# Nachrichten exportieren
main

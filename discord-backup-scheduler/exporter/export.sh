#!/bin/bash

exportsDir="/exports"

workDir="/app"
mkdir -p "$workDir"

function exportPartial {
  /opt/app/docker-entrypoint.sh exportguild \
    --parallel 5 \
    -g "$2" \
    --format Json \
    -o "$1" \
    --include-threads all \
    --include-vc true \
    --after "3"
}

function export {
  # Count json files in /out
  numFiles=$(ls -1 "$exportsDir"/*.json | wc -l)

  # If there are no json files in the export dir, there hasn't been a prior export, so a full one needs to be performed
  if [ "$numFiles" -eq 0 ]; then
    echo "Performing full export"
    exportPartial "$exportsDir" "$GUILD_ID" "1970-01-01"
  else
    lastExportFile=$(ls -1t "$exportsDir"/*.json | head -n 1)

    echo "Reading export from $lastExportFile."
    lastExport=$(jq -r .exportedAt "$lastExportFile")

    echo "Exporting messages since $lastExport"
    exportPartial "$exportsDir" "$GUILD_ID" "$lastExport"
  fi
}

function cleanup {
  echo "Performing cleanup"
  for file in "$exportsDir"/*.json; do
    messageCount=$(jq -r '.messages | length' "$file")
    if [ "$messageCount" -eq 0 ]; then
      echo "$file has no messages - deleting."
      rm "$file"
    fi
  done
}

# Nachrichten exportieren
export

# Channel-Exports ohne Nachrichten löschen
cleanup

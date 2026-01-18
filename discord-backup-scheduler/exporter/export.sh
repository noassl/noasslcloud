#!/bin/sh

# Redirect logs to file
exec > >(tee -a /var/log/discord-analytics/exporter.log)
exec 2>&1

exportsDir="/exports"

workDir="/app"
mkdir -p "$workDir"

filenameTemplate="%T - %C - after %a.json"

exportPartial() {
  # docker-entrypoint always runs with dce user
  chown dce:dce $exportsDir

  # Discord Token wird per env var gesetzt
  /opt/app/docker-entrypoint.sh exportguild \
    --parallel 5 \
    -g "$2" \
    --format Json \
    -o "${1}/${filenameTemplate}" \
    --include-threads all \
    --include-vc true \
    --after "3"
}

export() {
  # Count json files in /out
  numFiles=$(ls -1 "$exportsDir"/*.json | wc -l)

  # If there are no json files in the export dir, there hasn't been a prior export, so a full one needs to be performed
  if [ "$numFiles" -eq 0 ]; then
    log "Performing full export"
    exportPartial "$exportsDir" "$GUILD_ID" "1970-01-01"
  else
    lastExportFile=$(ls -1t "$exportsDir"/*.json | head -n 1)

    log "Reading export from $lastExportFile."
    lastExport=$(jq -r .exportedAt "$lastExportFile")

    log "Exporting messages since $lastExport"
    exportPartial "$exportsDir" "$GUILD_ID" "$lastExport"
  fi
}

cleanup() {
  log "Performing cleanup"

  set -- "$exportsDir"/*.json
  if [ ! -e "$1" ]; then
    log "{$exportsDir} empty, exiting"
    return 0
  fi

  for file in "$exportsDir"/*.json; do
    messageCount=$(jq -r '.messages | length' "$file")
    if [ "$messageCount" -eq 0 ]; then
      log "$file has no messages - deleting."
      rm "$file"
    fi
  done
}

log() {
  echo "[$(date +%d.%m.%Y\ %H:%M:%S)] ${1}"
}

echo "--------------------------------------------------------------------------"
log  "Starting export..."
echo "--------------------------------------------------------------------------"

# Nachrichten exportieren
export

# Channel-Exports ohne Nachrichten löschen
cleanup

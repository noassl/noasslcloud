#!/bin/bash

workDir="/app"

mkdir -p "$workDir"

function exportPartial {
  files=(/out/*.json)
  firstFile="${files[0]}"

  echo "Reading export from $firstFile."

  lastExport=$(jq -r .exportedAt "$firstFile")

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

#if [ ! -d $workDir ]; then
#  echo "No input dir found at $workDir."
#  exit 1
#fi

#outFolder="/out/export-$(date +'%d.%m.%y-%H:%M:%S')"
#mkdir "${outFolder}"

# Count json files in /out
#numFiles=$(ls -l /out/*.json | wc -l)

# If no json files are in /out, there hasn't been a prior export, so a full one needs to be performed
#if [ "$numFiles" -eq 0 ]; then
#  exportFull "$workDir" "$GUILD_ID"
#else
#  exportPartial "$workDir" "$GUILD_ID"
#fi

# Über files in $outFolder loopn
#for filepath in "${outFolder}"/*; do
#  filename=$(basename "${filepath}")
#  baseFile="/out/${filename}"
#
#  # Fia jedes file schaun obs in /out existiert
#  if [[ -e $baseFile ]]; then
#    # jo -> mergen
#    # TODO: JSON merging: overwrite exportedAt, merge messages, sum messageCount
#    true;
#  else
#    # na -> einfoch ausse kopieren
#    cp "${filepath}" "${baseFile}"
#  fi;
#done

# Nachrichten exportieren
exportFull "/exports" "$GUILD_ID"

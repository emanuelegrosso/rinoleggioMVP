#!/bin/sh
set -e
mkdir -p /data
db_image="/app/Rinoleggio.db"
db_volume="/data/Rinoleggio.db"
if [ ! -f "$db_volume" ] || [ ! -s "$db_volume" ]; then
  if [ ! -f "$db_image" ]; then
    echo "ERROR: database missing in image at $db_image"
    exit 1
  fi
  cp "$db_image" "$db_volume"
  echo "Copied $db_volume from image."
fi
exec dotnet Rinoleggio.Web.dll

#!/bin/sh
set -e
mkdir -p /data
if [ ! -f /data/Rinoleggio.db ]; then
  cp /app/seed/Rinoleggio.db /data/Rinoleggio.db
  echo "Seeded /data/Rinoleggio.db from image."
fi
exec dotnet Rinoleggio.Web.dll

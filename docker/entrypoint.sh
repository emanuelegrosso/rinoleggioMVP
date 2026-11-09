#!/bin/sh
set -e
mkdir -p /data
seed="/app/seed/Rinoleggio.db"
target="/data/Rinoleggio.db"
needs_seed=0
if [ ! -f "$target" ]; then
  needs_seed=1
elif [ ! -s "$target" ]; then
  needs_seed=1
fi
if [ "$needs_seed" -eq 1 ]; then
  if [ ! -f "$seed" ]; then
    echo "ERROR: seed database missing at $seed"
    exit 1
  fi
  cp "$seed" "$target"
  echo "Seeded $target from image ($(stat -c%s "$target" 2>/dev/null || wc -c <"$target") bytes)."
fi
exec dotnet Rinoleggio.Web.dll

#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <backup-timestamp>"
  echo "Example: $0 2025-01-15-1412"
  exit 1
fi

BACKUP_DIR=./backups/$1

VOLUMES=(
  cb-data
  ddb-data
  mysql-data
  pg-data
  pgadmin-data
)

if [ ! -d "$BACKUP_DIR" ]; then
  echo "Backup directory not found: $BACKUP_DIR"
  exit 1
fi

echo "→ Stopping containers"
docker compose down

echo "→ Recreating volumes"
for V in "${VOLUMES[@]}"; do
  docker volume rm "$V" 2>/dev/null || true
  docker volume create "$V"
done

for V in "${VOLUMES[@]}"; do
  echo "→ Restoring volume: $V"
  docker run --rm \
    -v "$V:/volume" \
    -v "$BACKUP_DIR:/backup" \
    alpine \
    tar xzf "/backup/$V.tgz" -C /volume
done

echo "✓ Restore complete from $BACKUP_DIR"

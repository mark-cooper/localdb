#!/usr/bin/env bash
set -euo pipefail

TS=$(date +%F-%H%M)
BACKUP_DIR=./backups/$TS

VOLUMES=(
  cb-data
  ddb-data
  mysql-data
  pg-data
  pgadmin-data
)

mkdir -p "$BACKUP_DIR"

echo "→ Stopping databases for clean snapshot"
docker compose stop

for V in "${VOLUMES[@]}"; do
  echo "→ Backing up volume: $V"
  docker run --rm \
    -v "$V:/volume" \
    -v "$BACKUP_DIR:/backup" \
    alpine \
    tar czf "/backup/$V.tgz" -C /volume .
done

echo "✓ Backup complete: $BACKUP_DIR"

#!/bin/bash
# Phase 6.2 — Automated MongoDB backup to S3
# Runs on the MongoDB VM via cron

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/tmp/mongo_backup_${TIMESTAMP}"
BUCKET_NAME="wiz-database-backups-1789996355"

# Dump the database
mongodump --uri="mongodb://wizuser:wizpassword@localhost:27017/tasky?authSource=admin" --out="${BACKUP_DIR}"

# Compress
tar -czf "/tmp/tasky_backup_${TIMESTAMP}.tar.gz" -C "${BACKUP_DIR}".

# Upload to S3
aws s3 cp "/tmp/tasky_backup_${TIMESTAMP}.tar.gz" "s3://${BUCKET_NAME}/backups/tasky_backup_${TIMESTAMP}.tar.gz"

# Cleanup local files
rm -rf "${BACKUP_DIR}" "/tmp/tasky_backup_${TIMESTAMP}.tar.gz"

echo "Backup completed: tasky_backup_${TIMESTAMP}.tar.gz"

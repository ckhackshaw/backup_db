#!/bin/bash

USER="root"
PASSWORD="password"
BACKUP_DIR="/Users/courtneyhackshaw/Backups"
DATE=$(date +%Y-%m-%d_%H-%M-%S)

mkdir -p "$BACKUP_DIR"

# Get list of user databases only
databases=$(mysql -u "$USER" -p"$PASSWORD" -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")

for db in $databases; do
  echo "Backing up $db..."
  mysqldump -u "$USER" -p"$PASSWORD" "$db" | gzip > "$BACKUP_DIR/${db}_$DATE.sql.gz"
done

echo "Cleaning up old files..."
find "$BACKUP_DIR" -type f -name "*.sql.gz" -mtime +7 -exec rm {} \;
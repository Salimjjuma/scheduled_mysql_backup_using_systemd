#!/bin/bash

# Current date in YYYY-MM-DD-HHMMSS format for unique backup filenames
DATE=$(date +%F-%H%M%S)

# Backup directory on the host
BACKUP_DIR="./backup/"

# Database credentials and details
DB_HOST="YOURHOST"  # Set to 'localhost' since we're using a running container
DB_USER="YOURUSER"
DB_NAME="YOURDB"

# Running MySQL container name or ID
MYSQL_CONTAINER="YOUR_CONTAINER_ID_OR_NAME"  # Replace with your running container's name or ID

# Backup filename
BACKUP_FILENAME="$BACKUP_DIR/$DB_NAME-$DATE.sql"

# Log file for the backup process
LOG_FILE="/var/log/db_backup.log"

# Log the start time and backup details
echo "[$(date)] Starting backup for database: $DB_NAME" >> $LOG_FILE

# Check if backup directory exists, if not, create it
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir -p "$BACKUP_DIR"
  if [ $? -eq 0 ]; then
    echo "[$(date)] Created backup directory: $BACKUP_DIR" >> $LOG_FILE
  else
    echo "[$(date)] ERROR: Failed to create backup directory: $BACKUP_DIR" >> $LOG_FILE
    exit 1
  fi
fi

# Run mysqldump inside the running container and output the backup to the host
if docker exec $MYSQL_CONTAINER /usr/bin/mysqldump --defaults-file=/docker-entrypoint-initdb.d/my.cnf $DB_NAME > $BACKUP_FILENAME 2>> $LOG_FILE; then
  echo "[$(date)] Backup completed successfully. Backup file: $BACKUP_FILENAME" >> $LOG_FILE

  # Compress the backup file
  if gzip $BACKUP_FILENAME 2>> $LOG_FILE; then
    echo "[$(date)] Backup file compressed successfully: $BACKUP_FILENAME.gz" >> $LOG_FILE
  else
    echo "[$(date)] ERROR: Failed to compress backup file: $BACKUP_FILENAME" >> $LOG_FILE
    exit 1
  fi
else
  echo "[$(date)] ERROR: Failed to create backup for database: $DB_NAME" >> $LOG_FILE
  exit 1
fi

# Final success log
echo "[$(date)] Backup process completed successfully for database: $DB_NAME" >> $LOG_FILE

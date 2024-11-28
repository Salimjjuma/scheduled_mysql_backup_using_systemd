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

# Check if backup directory exists, if not, create it
mkdir -p "$BACKUP_DIR"

# Run mysqldump inside the running container and output the backup to the host
docker exec $MYSQL_CONTAINER /usr/bin/mysqldump --defaults-file=/docker-entrypoint-initdb.d/my.cnf $DB_NAME > $BACKUP_FILENAME

# Compress the backup file
gzip $BACKUP_FILENAME

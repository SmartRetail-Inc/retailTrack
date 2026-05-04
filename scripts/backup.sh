#!/bin/bash

echo "Creating backup..."

# create backup folder
mkdir -p data/backup

# timestamp (consistent with all logs)
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# copy files
cp data/inventory.csv data/backup/inventory_backup.csv
cp data/sales.log data/backup/sales_backup.log
cp data/console.log data/backup/console_backup.log

# structured backup log
echo "$timestamp | BACKUP CREATED | inventory,sales,console" >> data/backup.log

echo "System backup completed at $timestamp"

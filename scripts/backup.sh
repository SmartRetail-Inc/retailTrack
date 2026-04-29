echo "Creating backup..."

mkdir -p data/backup

cp data/inventory.csv data/backup/
cp data/sales.log data/backup/

echo "Backup done at $(date)" >> data/backup_log.txt

echo "System backup completed."
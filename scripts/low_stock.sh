echo "LOW STOCK ITEMS:"
awk -F, '$2 < 5 {print $1 " - stock: " $2}' data/inventory.csv
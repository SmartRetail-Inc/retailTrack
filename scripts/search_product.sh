echo "Enter product name:"
read product

grep -i "$product" data/inventory.csv || echo "Product not found"
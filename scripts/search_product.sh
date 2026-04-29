#!/bin/bash

echo "=============================="
echo "     AVAILABLE PRODUCTS"
echo "=============================="

printf "%-10s | %-6s | %-5s\n" "Product" "Stock" "Price"
echo "--------------------------------------"

# show all products
while IFS=',' read -r product stock price
do
    product=$(echo "$product" | xargs)
    stock=$(echo "$stock" | xargs)
    price=$(echo "$price" | xargs)

    printf "%-10s | %-6s | $%-5s\n" "$product" "$stock" "$price"
done < data/inventory.csv

echo ""
echo "Enter product name to view details:"
read search

search=$(echo "$search" | xargs)

# find product
line=$(grep -i "^$search," data/inventory.csv)

if [ -z "$line" ]; then
    echo "Product not found!"
    exit 1
fi

# extract values
name=$(echo "$line" | cut -d',' -f1)
stock=$(echo "$line" | cut -d',' -f2)
price=$(echo "$line" | cut -d',' -f3)

# clean numeric values safely
stock=$(echo "$stock" | tr -cd '0-9')
price=$(echo "$price" | tr -cd '0-9.')

echo ""
echo "=============================="
echo "      PRODUCT DETAILS"
echo "=============================="
echo "Product: $name"
echo "Stock: $stock"
echo "Price: $price"
echo "=============================="
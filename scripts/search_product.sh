#!/bin/bash

echo "=============================="
echo "     AVAILABLE PRODUCTS"
echo "=============================="

printf "%-6s | %-15s | %-10s | %-6s | %-8s\n" "ID" "Product" "Category" "Stock" "Price"
echo "-----------------------------------------------------------"

while IFS=',' read -r id name category stock price
do
    id=$(echo "$id" | xargs)
    name=$(echo "$name" | xargs)
    category=$(echo "$category" | xargs)
    stock=$(echo "$stock" | xargs)
    price=$(echo "$price" | xargs)

    printf "%-6s | %-15s | %-10s | %-6s | $%-8s\n" "$id" "$name" "$category" "$stock" "$price"
done < <(tail -n +2 data/inventory.csv)

echo ""
echo "Enter product ID or name to search:"
read search

search=$(echo "$search" | xargs)

line=$(tail -n +2 data/inventory.csv | grep -i "$search" | head -1)

if [ -z "$line" ]; then
    echo "Product not found!"
    exit 1
fi

id=$(echo "$line" | cut -d',' -f1)
name=$(echo "$line" | cut -d',' -f2)
category=$(echo "$line" | cut -d',' -f3)
stock=$(echo "$line" | cut -d',' -f4)
price=$(echo "$line" | cut -d',' -f5)

stock=$(echo "$stock" | tr -cd '0-9')
price=$(echo "$price" | tr -cd '0-9.')

echo ""
echo "=============================="
echo "      PRODUCT DETAILS"
echo "=============================="
echo "ID:       $id"
echo "Product:  $name"
echo "Category: $category"
echo "Stock:    $stock"
echo "Price:    \$$price"
echo "=============================="
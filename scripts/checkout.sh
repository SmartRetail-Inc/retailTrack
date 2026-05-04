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
echo "Enter product ID (e.g. P001):"
read product_id

echo "Enter quantity:"
read qty

product_id=$(echo "$product_id" | xargs | tr '[:lower:]' '[:upper:]')
qty=$(echo "$qty" | xargs)

line=$(grep -i "^$product_id," data/inventory.csv)

if [ -z "$line" ]; then
    echo "Product not found!"
    exit 1
fi

id=$(echo "$line" | cut -d',' -f1)
name=$(echo "$line" | cut -d',' -f2)
category=$(echo "$line" | cut -d',' -f3)
stock=$(echo "$line" | cut -d',' -f4)
price=$(echo "$line" | cut -d',' -f5)

stock=$((stock))
qty=$((qty))
price=$((price))

if [ "$qty" -le 0 ]; then
    echo "Invalid quantity!"
    exit 1
fi

if [ "$qty" -gt "$stock" ]; then
    echo "Not enough stock!"
    exit 1
fi

total=$((qty * price))
new_stock=$((stock - qty))

awk -F',' -v id="$id" -v new_stock="$new_stock" '
BEGIN {OFS=","}
NR==1 {print; next}
$1==id {$4=new_stock}
{print}
' data/inventory.csv > data/inventory.tmp && mv data/inventory.tmp data/inventory.csv

timestamp=$(date '+%Y-%m-%d %H:%M:%S')

echo "$id,$name,$qty,$price,$total" >> data/sales.log
echo "$timestamp | $id | $name | -$qty | remaining:$new_stock" >> data/inventory.log

echo ""
echo "=============================="
echo "         RECEIPT"
echo "=============================="
echo "ID:         $id"
echo "Item:       $name"
echo "Category:   $category"
echo "Quantity:   $qty"
echo "Unit Price: \$${price}"
echo "Total:      \$${total}"
echo "Time:       $timestamp"
echo "=============================="
echo "Purchase successful!"
#!/bin/bash

clear

echo "=============================="
echo "     AVAILABLE PRODUCTS"
echo "=============================="

printf "%-6s | %-18s | %-10s | %-6s | %-10s\n" "ID" "Name" "Category" "Stock" "Price"
echo "---------------------------------------------------------------------"

# display sorted products by ID
sort data/inventory.csv | while IFS=',' read -r id name category stock price
do
    id=$(echo "$id" | xargs)
    name=$(echo "$name" | xargs)
    category=$(echo "$category" | xargs)
    stock=$(echo "$stock" | xargs)
    price=$(echo "$price" | xargs)

    # low stock warning
    if [[ "$stock" =~ ^[0-9]+$ ]] && [ "$stock" -le 5 ]; then
        stock_display="\033[1;31m$stock (LOW)\033[0m"
    else
        stock_display="$stock"
    fi

    printf "%-6s | %-18s | %-10s | %-6b | $%-10s\n" \
    "$id" "$name" "$category" "$stock_display" "$price"
done

echo ""
echo "Enter Product ID:"
read id

echo "Enter quantity:"
read qty

# clean input
id=$(echo "$id" | xargs)
qty=$(echo "$qty" | xargs)

# find product
line=$(grep -E "^$id," data/inventory.csv | head -n 1)

if [ -z "$line" ]; then
    echo "Product not found!"
    exit 1
fi

# extract fields safely
name=$(echo "$line" | cut -d',' -f2 | xargs)
category=$(echo "$line" | cut -d',' -f3 | xargs)
stock=$(echo "$line" | cut -d',' -f4 | xargs)
price=$(echo "$line" | cut -d',' -f5 | xargs)

# remove Windows line endings safety
stock=${stock//$'\r'/}
price=${price//$'\r'/}

# validation
if ! [[ "$stock" =~ ^[0-9]+$ ]]; then
    echo "ERROR: invalid stock value: $stock"
    exit 1
fi

if ! [[ "$price" =~ ^[0-9]+$ ]]; then
    echo "ERROR: invalid price value: $price"
    exit 1
fi

if ! [[ "$qty" =~ ^[0-9]+$ ]]; then
    echo "Invalid quantity!"
    exit 1
fi

if [ "$qty" -le 0 ]; then
    echo "Invalid quantity!"
    exit 1
fi

if [ "$qty" -gt "$stock" ]; then
    echo "Not enough stock!"
    exit 1
fi

# calculations
total=$((qty * price))
new_stock=$((stock - qty))

# update inventory
awk -F',' -v id="$id" -v new_stock="$new_stock" '
BEGIN {OFS=","}
$1==id {$4=new_stock}
{print}
' data/inventory.csv > data/inventory.tmp && mv data/inventory.tmp data/inventory.csv

# logs
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

echo "$timestamp,$id,$name,$qty,$total" >> data/sales.log
echo "$timestamp | $id | $name | -$qty | remaining:$new_stock" >> data/inventory.log

# receipt
echo ""
echo "=============================="
echo "         RECEIPT"
echo "=============================="
echo "Product ID: $id"
echo "Name: $name"
echo "Category: $category"
echo "Quantity: $qty"
echo "Unit Price: $$price"
echo "Total Price: $$total"
echo "Time: $timestamp"
echo "=============================="
echo "Purchase successful!"
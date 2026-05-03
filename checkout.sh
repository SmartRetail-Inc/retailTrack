#!/bin/bash

echo "=============================="
echo "     AVAILABLE PRODUCTS"
echo "=============================="

printf "%-6s | %-15s | %-10s | %-6s | %-5s\n" "ID" "Name" "Category" "Stock" "Price"
echo "--------------------------------------------------------------"

# display products
while IFS=',' read -r id name category stock price
do
    id=$(echo "$id" | tr -d '\r' | xargs)
    name=$(echo "$name" | tr -d '\r' | xargs)
    category=$(echo "$category" | tr -d '\r' | xargs)
    stock=$(echo "$stock" | tr -d '\r' | xargs)
    price=$(echo "$price" | tr -d '\r' | xargs)

    printf "%-6s | %-15s | %-10s | %-6s | $%-5s\n" "$id" "$name" "$category" "$stock" "$price"
done < data/inventory.csv

echo ""
echo "Enter Product ID:"
read id

echo "Enter quantity:"
read qty

# clean input
id=$(echo "$id" | xargs)
qty=$(echo "$qty" | xargs)

# validation FIRST (fix)
if ! [[ "$qty" =~ ^[0-9]+$ ]] || [ "$qty" -le 0 ]; then
    echo "Invalid quantity!"
    exit 1
fi

# FIXED SEARCH (this is the main bug fix)
line=$(awk -F',' -v id="$id" 'tolower($1)==tolower(id)' data/inventory.csv)

if [ -z "$line" ]; then
    echo "Product not found!"
    exit 1
fi

# extract fields
name=$(echo "$line" | cut -d',' -f2 | xargs)
category=$(echo "$line" | cut -d',' -f3 | xargs)
stock=$(echo "$line" | cut -d',' -f4 | xargs)
price=$(echo "$line" | cut -d',' -f5 | xargs)

# force numeric safety
stock=${stock//[^0-9]/}
price=${price//[^0-9]/}

stock=$((stock))
qty=$((qty))
price=$((price))

if [ "$qty" -gt "$stock" ]; then
    echo "Not enough stock!"
    exit 1
fi

# calculations
total=$((qty * price))
new_stock=$((stock - qty))

# safe inventory update
awk -F',' -v id="$id" -v new_stock="$new_stock" '
BEGIN {OFS=","}
$1==id {$4=new_stock}
{print}
' data/inventory.csv > data/inventory.tmp && mv data/inventory.tmp data/inventory.csv

# ==============================
# LOGGING
# ==============================

timestamp=$(date '+%Y-%m-%d %H:%M:%S')

echo "$timestamp,$id,$name,$qty,$total" >> data/sales.log
echo "$timestamp | $id | $name | -$qty | remaining:$new_stock" >> data/inventory.log

# ==============================
# RECEIPT
# ==============================

echo ""
echo "=============================="
echo "         RECEIPT"
echo "=============================="
echo "Product ID: $id"
echo "Name: $name"
echo "Category: $category"
echo "Quantity: $qty"
echo "Unit Price: \$${price}"
echo "Total Price: \$${total}"
echo "Time: $timestamp"
echo "=============================="
echo "Purchase successful!"
#!/bin/bash

echo "=============================="
echo "     AVAILABLE PRODUCTS"
echo "=============================="

printf "%-10s | %-6s | %-5s\n" "Product" "Stock" "Price"
echo "--------------------------------------"

# display products
while IFS=',' read -r product stock price
do
    product=$(echo "$product" | xargs)
    stock=$(echo "$stock" | xargs)
    price=$(echo "$price" | xargs)

    printf "%-10s | %-6s | $%-5s\n" "$product" "$stock" "$price"
done < data/inventory.csv

echo ""
echo "Enter product:"
read product

echo "Enter quantity:"
read qty

# clean input
product=$(echo "$product" | xargs)
qty=$(echo "$qty" | xargs)

# find product
line=$(grep -i "^$product," data/inventory.csv)

if [ -z "$line" ]; then
    echo "Product not found!"
    exit 1
fi

# extract fields
name=$(echo "$line" | cut -d',' -f1)
stock=$(echo "$line" | cut -d',' -f2)
price=$(echo "$line" | cut -d',' -f3)

# force numeric safety
stock=$((stock))
qty=$((qty))
price=$((price))

# validation
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

# safe inventory update (prevents corruption)
awk -F',' -v name="$name" -v new_stock="$new_stock" -v price="$price" '
BEGIN {OFS=","}
$1==name {$2=new_stock; $3=price}
{print}
' data/inventory.csv > data/inventory.tmp && mv data/inventory.tmp data/inventory.csv

# ==============================
# LOGGING
# ==============================

timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# sales log (STRICT CSV)
echo "$name,$qty,$total" >> data/sales.log

# inventory log (audit trail)
echo "$timestamp | $name | -$qty | remaining:$new_stock" >> data/inventory.log

# ==============================
# RECEIPT
# ==============================

echo ""
echo "=============================="
echo "      RECEIPT"
echo "=============================="
echo "Item: $name"
echo "Quantity: $qty"
echo "Unit Price: \$${price}"
echo "Total Price: \$${total}"
echo "Time: $timestamp"
echo "=============================="
echo "Purchase successful!"
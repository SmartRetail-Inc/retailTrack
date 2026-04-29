#!/bin/bash

echo "=============================="
echo "     AVAILABLE PRODUCTS"
echo "=============================="

printf "%-10s | %-6s | %-5s\n" "Product" "Stock" "Price"
echo "--------------------------------------"

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

# stock check
if [ "$qty" -gt "$stock" ]; then
    echo "Not enough stock!"
    exit 1
fi

# calculations
total=$((qty * price))
new_stock=$((stock - qty))

# update inventory
sed -i "s/^$name,$stock,$price/$name,$new_stock,$price/" data/inventory.csv

# ==============================
# LOGGING (IMPORTANT PART)
# ==============================

# sales log (product,qty,total)
echo "$name,$qty,$total" >> data/sales.log

# inventory log (movement tracking)
echo "$(date '+%Y-%m-%d %H:%M:%S') | $name | -$qty | remaining:$new_stock" >> data/inventory.log

# ==============================
# RECEIPT
# ==============================

echo ""
echo "=============================="
echo "      RECEIPT"
echo "=============================="
echo "Item: $name"
echo "Quantity: $qty"
echo "Unit Price: $price"
echo "Total Price: $$total"
echo "=============================="
echo "Purchase successful!"
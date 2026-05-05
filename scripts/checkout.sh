#!/bin/bash

INVENTORY_FILE="data/inventory.csv"
SALES_FILE="data/sales.log"
INV_LOG="data/inventory.log"

echo "=============================="
echo "     AVAILABLE PRODUCTS"
echo "=============================="

printf "%-6s | %-15s | %-10s | %-6s | %-8s\n" "ID" "Product" "Category" "Stock" "Price"
echo "-----------------------------------------------------------"

tail -n +2 "$INVENTORY_FILE" | while IFS=',' read -r id name category stock price
do
    id=$(echo "$id" | xargs)
    name=$(echo "$name" | xargs)
    category=$(echo "$category" | xargs)
    stock=$(echo "$stock" | xargs)
    price=$(echo "$price" | xargs)

    printf "%-6s | %-15s | %-10s | %-6s | $%-8s\n" "$id" "$name" "$category" "$stock" "$price"
done

echo ""
echo "Enter product ID (e.g. P001):"
read product_id

echo "Enter quantity:"
read qty

product_id=$(echo "$product_id" | xargs | tr '[:lower:]' '[:upper:]')
qty=$(echo "$qty" | xargs)

line=$(grep -i "^$product_id," "$INVENTORY_FILE")

if [ -z "$line" ]; then
    echo "Product not found!"
    exit 1
fi

IFS=',' read -r id name category stock price <<< "$line"

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

# ==============================
# UPDATE INVENTORY
# ==============================
awk -F',' -v id="$id" -v new_stock="$new_stock" '
BEGIN {OFS=","}
NR==1 {print; next}
$1==id {$4=new_stock}
{print}
' "$INVENTORY_FILE" > data/inventory.tmp && mv data/inventory.tmp "$INVENTORY_FILE"

timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# ==============================
# SAVE SALES LOG (FIXED)
# ==============================
echo "$timestamp | $id | $name | $qty | $price | $total" >> "$SALES_FILE"

# ==============================
# INVENTORY LOG
# ==============================
echo "$timestamp | $id | $name | -$qty | remaining:$new_stock" >> "$INV_LOG"

# ==============================
# RECEIPT
# ==============================
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
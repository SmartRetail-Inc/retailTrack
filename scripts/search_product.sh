#!/bin/bash

FILE="data/inventory.csv"

echo "=============================="
echo "     AVAILABLE PRODUCTS"
echo "=============================="

printf "%-6s | %-15s | %-10s | %-6s | %-8s\n" "ID" "Product" "Category" "Stock" "Price"
echo "-----------------------------------------------------------"

# ==============================
# DISPLAY PRODUCTS
# ==============================
while IFS=',' read -r id name category stock price
do
    id=$(echo "$id" | xargs)
    name=$(echo "$name" | xargs)
    category=$(echo "$category" | xargs)
    stock=$(echo "$stock" | xargs)
    price=$(echo "$price" | xargs)

    printf "%-6s | %-15s | %-10s | %-6s | $%-8s\n" "$id" "$name" "$category" "$stock" "$price"
done < <(tail -n +2 "$FILE")

# ==============================
# SEARCH
# ==============================
echo ""
echo "Enter product ID or name to search:"
read -r search

search=$(echo "$search" | xargs)

# Use awk for clean matching
line=$(awk -F',' -v search="$search" '
BEGIN { IGNORECASE=1 }
NR > 1 {
    # trim spaces
    gsub(/^[ \t]+|[ \t]+$/, "", $1)
    gsub(/^[ \t]+|[ \t]+$/, "", $2)
    gsub(/^[ \t]+|[ \t]+$/, "", $3)
    gsub(/^[ \t]+|[ \t]+$/, "", $4)
    gsub(/^[ \t]+|[ \t]+$/, "", $5)

    if ($1 == search || $2 == search) {
        print $0
        exit
    }
}' "$FILE")

# ==============================
# CHECK RESULT
# ==============================
if [ -z "$line" ]; then
    echo "Product not found!"
    exit 1
fi

# ==============================
# EXTRACT DATA
# ==============================
IFS=',' read -r id name category stock price <<< "$line"

id=$(echo "$id" | xargs)
name=$(echo "$name" | xargs)
category=$(echo "$category" | xargs)
stock=$(echo "$stock" | xargs | tr -cd '0-9')
price=$(echo "$price" | xargs | tr -cd '0-9.')

# ==============================
# DISPLAY DETAILS
# ==============================
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
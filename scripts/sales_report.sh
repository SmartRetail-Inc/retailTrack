#!/bin/bash

echo "=============================="
echo "      SALES REPORT"
echo "=============================="
echo "Generated on: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=============================="

printf "%-6s | %-15s | %-5s | %-8s | %-8s\n" "ID" "Product" "Qty" "Price" "Total"
echo "-----------------------------------------------------------"

total_sales=0

while IFS=',' read -r id name qty price total
do
    [ -z "$id" ] && continue

    qty=$(echo "$qty" | tr -cd '0-9')
    total=$(echo "$total" | tr -cd '0-9')

    printf "%-6s | %-15s | %-5s | $%-7s | $%-8s\n" "$id" "$name" "$qty" "$price" "$total"

    total_sales=$((total_sales + total))

done < data/sales.log

echo ""
echo "=============================="
echo "TOTAL SALES: \$$total_sales"
echo "=============================="
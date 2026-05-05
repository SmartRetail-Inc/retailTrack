#!/bin/bash

FILE="data/sales.log"

echo "============================== SALES REPORT =============================="
echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
echo "======================================================================"

printf "%-6s | %-15s | %-3s | %-10s | %-6s\n" "ID" "Product" "Qty" "Unit Price" "Total"
echo "----------------------------------------------------------------------"

count=0
total_sales=0

while IFS=',' read -r id name qty price total
do
    [[ -z "$id" ]] && continue

    printf "%-6s | %-15s | %3s | $%-9s | $%-6s\n" \
    "$id" "$name" "$qty" "$price" "$total"

    count=$((count + 1))
    total_sales=$((total_sales + total))

done < "$FILE"

echo "----------------------------------------------------------------------"
echo "TOTAL RECORDS: $count"
echo "TOTAL SALES: \$$total_sales"
echo "======================================================================"
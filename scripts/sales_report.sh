#!/bin/bash

FILE="data/sales.log"

echo "============================== SALES REPORT =============================="
echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
echo "======================================================================"

printf "%-19s | %-6s | %-15s | %-5s | %-10s | %-8s\n" \
"Timestamp" "ID" "Product" "Qty" "Unit Price" "Total"

echo "----------------------------------------------------------------------"

total_sales=0
count=0

while IFS='|' read -r timestamp id name qty price total
do
    # clean spaces
    timestamp=$(echo "$timestamp" | xargs)
    id=$(echo "$id" | xargs)
    name=$(echo "$name" | xargs)
    qty=$(echo "$qty" | xargs)
    price=$(echo "$price" | xargs)
    total=$(echo "$total" | xargs)

    # skip bad lines
    [[ ! "$id" =~ ^P[0-9]+$ ]] && continue

    printf "%-19s | %-6s | %-15s | %-5s | $%-9s | $%-8s\n" \
    "$timestamp" "$id" "$name" "$qty" "$price" "$total"

    total_sales=$((total_sales + total))
    count=$((count + 1))

done < "$FILE"

echo "----------------------------------------------------------------------"
echo "TOTAL RECORDS: $count"
echo "TOTAL SALES: \$$total_sales"
echo "======================================================================"
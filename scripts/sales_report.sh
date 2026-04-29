#!/bin/bash

echo "=============================="
echo "      SALES REPORT"
echo "=============================="
echo "Generated on: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=============================="

printf "%-15s %-10s %-10s\n" "Product" "Qty" "Total"
echo "--------------------------------------------"

total_sales=0

while IFS=',' read -r product qty total
do
    # skip empty lines
    [ -z "$product" ] && continue

    # clean numeric values
    qty=$(echo "$qty" | tr -cd '0-9')
    total=$(echo "$total" | tr -cd '0-9')

    echo "$product sold: $qty | Total: $total"

    # IMPORTANT: numeric addition ONLY
    total_sales=$((total_sales + total))

done < data/sales.log

echo ""
echo "=============================="
echo "TOTAL SALES: $total_sales"
echo "=============================="
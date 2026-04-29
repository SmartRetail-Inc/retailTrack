#!/bin/bash

echo "=============================="
echo "      SALES REPORT"
echo "=============================="
echo "Generated on: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=============================="
echo ""

total_sales=0
total_items=0

if [ ! -s data/sales.log ]; then
    echo "No sales recorded yet."
    exit 0
fi

printf "%-15s %-10s %-10s %-10s\n" "Product" "Qty" "Total" "Date/Time"
echo "------------------------------------------------------------"

while IFS=',' read -r product qty total datetime
do
    product=$(echo "$product" | xargs)
    qty=$(echo "$qty" | xargs)
    total=$(echo "$total" | xargs)
    datetime=$(echo "$datetime" | xargs)

    # fallback if no timestamp exists
    if [ -z "$datetime" ]; then
        datetime="N/A"
    fi

    echo "$product sold: $qty | Total: $$total | $datetime"

    total_sales=$((total_sales + total))
    total_items=$((total_items + qty))

done < data/sales.log

echo ""
echo "=============================="
echo "TOTAL ITEMS SOLD: $total_items"
echo "TOTAL SALES: $$total_sales"
echo "=============================="
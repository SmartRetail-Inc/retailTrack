echo "=============================="
echo "      SALES REPORT"
echo "=============================="
echo "Generated on: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=============================="

total=0

if [ ! -s data/sales.log ]; then
    echo "No sales recorded yet."
    exit 0
fi

printf "%-15s %-10s %-10s\n" "Product" "Qty" "Total"
echo "--------------------------------------------"

while IFS=',' read -r product qty total
do
    # skip broken lines
    if ! [[ "$qty" =~ ^[0-9]+$ ]]; then
        continue
    fi

    echo "$product sold: $qty | Total: $$total"

    total=$((total + total))

done < data/sales.log

echo ""
echo "=============================="
echo "TOTAL SALES: $$total"
echo "=============================="
echo "=============================="
echo "      SALES REPORT"
echo "=============================="

total=0

if [ ! -s data/sales.log ]; then
    echo "No sales recorded yet."
    exit 0
fi

while read -r product qty
do
    echo "$product sold: $qty | Total: $$qty"
    total=$((total + qty))
done < data/sales.log

echo "------------------------------"
echo "TOTAL SALES: $$total"
echo "=============================="
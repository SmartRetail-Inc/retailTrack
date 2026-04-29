echo "=============================="
echo "      SALES REPORT"
echo "=============================="

total=0

while IFS=',' read -r product qty price
do
    echo "$product sold: $qty | Total: $$price"
    total=$((total + price))
done < data/sales.log

echo "------------------------------"
echo "TOTAL SALES: $$total"
echo "=============================="
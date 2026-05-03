echo "=============================="
echo "      LOW STOCK CHECK"
echo "=============================="

found=0

while IFS=',' read -r product stock price
do
    product=$(echo "$product" | xargs)
    stock=$((stock))

    if [ "$stock" -lt 5 ]; then
        echo "$product is LOW STOCK ($stock left)"
        found=1
    fi
done < data/inventory.csv

echo ""

if [ "$found" -eq 0 ]; then
    echo "✅ All stocks are sufficient."
fi

echo "=============================="
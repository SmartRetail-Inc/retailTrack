#!/bin/bash

echo "=============================="
echo "      LOW STOCK CHECK"
echo "=============================="

found=0

while IFS=',' read -r id name category stock price
do
    name=$(echo "$name" | xargs)
    stock=$((stock))

    if [ "$stock" -lt 5 ]; then
        echo "⚠️  $id | $name ($category) - LOW STOCK ($stock left)"
        found=1
    fi
done < <(tail -n +2 data/inventory.csv)

echo ""

if [ "$found" -eq 0 ]; then
    echo "✅ All stocks are sufficient."
fi

echo "=============================="
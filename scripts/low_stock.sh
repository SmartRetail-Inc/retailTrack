#!/bin/bash

echo "=============================="
echo "      LOW STOCK CHECK"
echo "=============================="

FILE="data/inventory.csv"
THRESHOLD=5
found=0

# Check if file exists
if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

while IFS=',' read -r id name category stock price
do
    name=$(echo "$name" | xargs)
    category=$(echo "$category" | xargs)

    # ensure stock is a number
    if ! [[ "$stock" =~ ^[0-9]+$ ]]; then
        echo "⚠️  Skipping invalid stock: $stock (ID: $id)"
        continue
    fi

    if [ "$stock" -lt "$THRESHOLD" ]; then
        echo "⚠️  $id | $name ($category) - LOW STOCK ($stock left)"
        found=1
    fi

done < <(tail -n +2 "$FILE")

echo ""

if [ "$found" -eq 0 ]; then
    echo "✅ All stocks are sufficient."
fi

echo "=============================="
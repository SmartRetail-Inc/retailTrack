echo "=============================="
echo "     AVAILABLE PRODUCTS"
echo "=============================="
echo ""

# Show products before buying
printf "%-10s | %s\n" "Product" "Stock"
echo "-----------------------------"

while IFS=',' read -r product stock
do
    printf "%-10s | %s\n" "$product" "$stock"
done < data/inventory.csv

echo ""
echo "=============================="

# Now take purchase input
echo "Enter product you want to buy:"
read product

echo "Enter quantity:"
read qty

# Find product
line=$(grep -i "^$product," data/inventory.csv)

if [ -z "$line" ]; then
    echo "Product not found!"
    exit 1
fi

name=$(echo $line | cut -d',' -f1)
stock=$(echo $line | cut -d',' -f2)

# Check stock
if [ "$qty" -gt "$stock" ]; then
    echo "Not enough stock available!"
    exit 1
fi

# Update stock
new_stock=$((stock - qty))
sed -i "s/^$name,$stock/$name,$new_stock/" data/inventory.csv

# Log sale
echo "$name $qty" >> data/sales.log

echo ""
echo "✅ Purchase successful!"
echo "Item: $name"
echo "Quantity: $qty"
echo "Remaining stock: $new_stock"
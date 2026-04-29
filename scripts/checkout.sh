echo "Enter product:"
read product

echo "Enter quantity:"
read qty

line=$(grep -i "^$product," data/inventory.csv)

if [ -z "$line" ]; then
    echo "Product not found"
    exit 1
fi

name=$(echo $line | cut -d',' -f1)
stock=$(echo $line | cut -d',' -f2)

if [ "$qty" -gt "$stock" ]; then
    echo "Not enough stock!"
    exit 1
fi

new_stock=$((stock - qty))

sed -i "s/^$name,$stock/$name,$new_stock/" data/inventory.csv

echo "$name $qty" >> data/sales.log

echo "Payment successful. Item sold: $name x $qty"
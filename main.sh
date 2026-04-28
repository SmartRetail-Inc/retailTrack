#!/bin/bash

echo "===== RetailTrack System ====="

# 🔐 LOGIN
echo "Enter username:"
read username

echo "Enter PIN:"
read pin

valid=false

while IFS=: read -r user pass
do
    if [ "$username" = "$user" ] && [ "$pin" = "$pass" ]; then
        valid=true
        break
    fi
done < users.txt

if [ "$valid" = false ]; then
    echo "Invalid login!"
    exit 1
fi

echo "Login successful. Welcome $username!"

# 🔁 INTERACTIVE MENU LOOP
while true
do
    echo ""
    echo "===== MAIN MENU ====="
    echo "1. Low Stock"
    echo "2. Sales Summary"
    echo "3. Search Product"
    echo "4. Checkout"
    echo "5. Backup"
    echo "6. Exit"

    echo "Choose option:"
    read choice

    case $choice in
        1) bash scripts/low_stock.sh ;;
        2) bash scripts/sales_report.sh ;;
        3) bash scripts/search_product.sh ;;
        4) bash scripts/checkout.sh ;;
        5) bash scripts/backup.sh ;;
        6) echo "Goodbye!"; exit ;;
        *) echo "Invalid option" ;;
    esac
done
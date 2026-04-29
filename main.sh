#!/bin/bash

echo "=============================="
echo "   RETAILTRACK POS SYSTEM"
echo "=============================="

# LOGIN
echo "Username:"
read username

echo "PIN:"
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

# ==============================
# LOG FUNCTION (STEP 1 ADDED)
# ==============================
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $username | $1" >> data/console.log
}

# MENU LOOP
while true
do
    echo ""
    echo "===== MAIN MENU ====="
    echo "1. View Low Stock"
    echo "2. Sales Report"
    echo "3. Search Product"
    echo "4. Checkout (Sell Item)"
    echo "5. Backup System"
    echo "6. Exit"

    echo "Select option:"
    read choice

    case $choice in
        1)
            log_action "Viewed Low Stock"
            bash scripts/low_stock.sh
            ;;

        2)
            log_action "Viewed Sales Report"
            bash scripts/sales_report.sh
            ;;

        3)
            log_action "Searched Product"
            bash scripts/search_product.sh
            ;;

        4)
            log_action "Checkout Started"
            bash scripts/checkout.sh
            ;;

        5)
            log_action "Backup System"
            bash scripts/backup.sh
            ;;

        6)
            log_action "Exited System"
            echo "Goodbye!"
            exit
            ;;

        *)
            echo "Invalid option"
            ;;
    esac
done
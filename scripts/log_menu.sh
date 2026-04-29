#!/bin/bash

while true
do
    echo ""
    echo "=============================="
    echo "        LOG MENU"
    echo "=============================="
    echo "1. View Sales Log"
    echo "2. View Inventory Log"
    echo "3. View Console Log"
    echo "4. Clear Screen"
    echo "5. Exit to Main Menu"
    echo "=============================="

    echo "Select option:"
    read choice

    case $choice in
        1)
            echo ""
            echo "----- SALES LOG -----"
            echo "Format: product,qty,total"
            echo "------------------------------"
            cat data/sales.log
            echo "------------------------------"
            ;;

        2)
            echo ""
            echo "----- INVENTORY LOG -----"
            echo "Format: timestamp | product | qty change | remaining stock"
            echo "------------------------------"
            cat data/inventory.log
            echo "------------------------------"
            ;;

        3)
            echo ""
            echo "----- CONSOLE LOG -----"
            echo "Format: timestamp | user | action"
            echo "------------------------------"
            cat data/console.log
            echo "------------------------------"
            ;;

        4)
            clear
            ;;

        5)
            echo "Returning to main menu..."
            exit 0
            ;;

        *)
            echo "Invalid option. Try again."
            ;;
    esac
done
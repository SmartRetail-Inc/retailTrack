# 🛒 RetailTrack POS System

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Status](https://img.shields.io/badge/status-stable-brightgreen)
![Language](https://img.shields.io/badge/language-Bash-4EAA25)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey)
![License](https://img.shields.io/badge/license-MIT-yellow)

---

## 📌 Overview

RetailTrack is a **terminal-based Point of Sale (POS) system** built using Bash scripting.  
It simulates a real-world retail environment with features such as inventory control, checkout processing, sales reporting, logging, and system backup.

This project demonstrates:
- Shell scripting automation
- File-based data management
- Logging and auditing systems
- Modular software design

---

## 🚀 Features

### 🔐 Authentication System
- User login using `users.txt`
- PIN-based validation
- Session tracking via console logs

### 📦 Inventory Management
- View available products
- Stock tracking
- Automatic stock deduction after purchase

### 🛒 Checkout System
- Product selection
- Quantity validation
- Real-time total calculation
- Receipt generation

### 📊 Sales Reporting
- Displays all sales records
- Shows quantity sold per item
- Calculates total revenue
- Timestamped report generation

### 📜 Logging System
- Console activity log (`console.log`)
- Sales log (`sales.log`)
- Inventory movement log (`inventory.log`)

### 💾 Backup System
- Copies inventory and sales data
- Timestamped backup logs
- Stored in `data/backup/`

### 📁 Log Viewer Menu
- View all system logs in one interface
- Admin-style navigation menu

---

## 🗂️ Project Structure


RetailTrack/
│
├── main.sh
├── users.txt
├── .gitignore
│
├── scripts/
│ ├── checkout.sh
│ ├── sales_report.sh
│ ├── search_product.sh
│ ├── low_stock.sh
│ ├── backup.sh
│ ├── log_menu.sh
│
├── data/
│ ├── inventory.csv
│ ├── sales.log
│ ├── inventory.log
│ ├── console.log
│ ├── backup/
│
└── README.md


---

## ⚙️ Installation & Setup

### 1. Clone Repository
```bash
git clone https://github.com/ORG_NAME/RetailTrack.git
cd RetailTrack
2. Give Execution Permissions
chmod +x main.sh
chmod +x scripts/*.sh
3. Run the System
bash main.sh
🔐 Demo Login Credentials
Jordy:1234
Joy:1234
Effa:1234
Solomon:1234
Jen:1234
Smith:1234
Franck:1234
Gael:1234
🧾 How It Works
Step 1: Login

User authenticates using username and PIN.

Step 2: Main Menu

User selects operations:

View inventory
Checkout items
View sales report
Search products
Backup system
View logs
Step 3: Checkout Process
Product list displayed
User enters product + quantity
System validates stock
Inventory updated
Sale recorded in logs
Receipt generated
📊 Sales Report Example
Product         Qty        Total
--------------------------------------------
apple sold: 3 | Total: 3
bread sold: 2 | Total: 2

TOTAL SALES: 5
📜 Logging System
Log File	Description
sales.log	Records all sales (product, qty, total)
inventory.log	Tracks stock changes
console.log	Tracks user actions
💾 Backup System

Backups are stored in:

data/backup/

Includes:

inventory snapshot
sales log copy
timestamped backup record
🧠 System Architecture
        ┌────────────────────┐
        │     main.sh        │
        │  Menu Controller   │
        └────────┬───────────┘
                 │
 ┌───────────────┼────────────────┐
 │               │                │
 ▼               ▼                ▼
Login        Checkout        Sales Report
 │               │                │
 ▼               ▼                ▼
users.txt   inventory.csv    sales.log
                 │                │
                 ▼                ▼
         inventory.log     console.log
🐞 Bug Fixes (Development History)
RETAIL-001: Login validation failure
Fixed incorrect delimiter parsing in users.txt
RETAIL-002: Checkout total corruption (e.g. 3125total)
Fixed string concatenation in arithmetic operations
RETAIL-003: Sales report duplication
Fixed loop variable reuse and parsing logic
RETAIL-004: Inventory corruption via sed
Replaced sed with safe awk update method
RETAIL-005: Logging inconsistency
Standardized log formats across all modules
📈 Improvements Made
Modular script design
Centralized logging system
Improved input validation
Safer inventory updates
Structured reporting system


RetailTrack is a modular Bash-based POS system that demonstrates real-world software design concepts such as authentication, inventory control, transaction logging, and system auditing using file-based data structures and shell scripting automation.

📌 Author

Developed as a learning project to demonstrate:

Linux shell scripting
File system operations
Modular system design
Basic software engineering principles
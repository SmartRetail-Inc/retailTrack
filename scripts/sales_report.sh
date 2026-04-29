echo "SALES REPORT:"
awk '{sum += $2} END {print "Total Items Sold:", sum}' data/sales.log
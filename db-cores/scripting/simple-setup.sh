#!/bin/bash
echo Simple core Setup
exec 5<>/dev/tcp/127.0.0.1/7777

# 62 is the first room It seems
# The Noth park seems 97
cat >&5 <<EOF
connect wizard
EOF



for f in $(dirname $0)/1*.txt; do
    echo Loading ${f}...
    cat >&5 < $f    
done
echo Quitting...

cat >&5 <<EOF

;"Quit from $0"
@quit
EOF

cat <&5

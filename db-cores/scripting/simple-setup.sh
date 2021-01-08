#!/bin/bash
echo Simple core Setup

# 62 is the first room It seems
# The Noth park seems 97

# $(dirname $0)/1*.txt
for f in $@; do
    echo Loading ${f}...
    exec 5<>/dev/tcp/127.0.0.1/7777
    cat >&5 < $f    
    cat <&5
done
echo Quitting...





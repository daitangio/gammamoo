#!/bin/bash
echo Simple core Setup
exec 5<>/dev/tcp/127.0.0.1/7777

# 62 is the first room It seems
# The Noth park seems 97
cat >&5 <<EOF
connect wizard
@describe me as "Root user of the system"
home
look wizard
@dig north,n to "The North Park"
n
@dig south,s to #62
"Ensure we come back to home
home
@quit
EOF
cat <&5

#!/bin/bash
echo Simple core Setup
exec 5<>/dev/tcp/127.0.0.1/7777
# password trustn00ne
cat >&5 <<EOF
connect wizard
@describe me as "Root user of the system"
look wizard
@quit
EOF
cat <&5

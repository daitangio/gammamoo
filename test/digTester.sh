#!/bin/bash
# Small script to test dump phase
killall moo
make || { echo "Build failed" ; exit;  }
rm DaitaCore.db.tmp.sqlite3
nohup ./moo DaitaCore.db DaitaCore.db.tmp >>test.log  2>&1 &
sleep 2
socat - tcp4:localhost:7777 <<EOF
CO wizard
@dig n to "Test1"
@describe #103 as "A test Room"
@dump #103
;shutdown()
EOF
tail -f test.log 
./sqlite3/sqlite3 DaitaCore.db.tmp.sqlite3 .dump | less


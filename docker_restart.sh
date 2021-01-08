#!/bin/bash

# Copyright (c) 1992, 1994, 1995, 1996 Xerox Corporation.  All rights reserved.
# Portions of this code were written by Stephen White, aka ghond.
# Use and copying of this software and preparation of derivative works based
# upon this software are permitted.  Any distribution of this software or
# derivative works must comply with all applicable United States export
# control laws.  This software is made available AS IS, and Xerox Corporation
# makes no warranty about the software, its performance or its conformity to
# any specification.  Any person obtaining a copy of this software is requested
# to send their name and post office or electronic mail address to:
#   Pavel Curtis
#   Xerox PARC
#   3333 Coyote Hill Rd.
#   Palo Alto, CA 94304
#   Pavel@Xerox.Com

if [ $# -lt 1 -o $# -gt 2 ]; then
	echo 'Usage: restart dbase-prefix [port]'
	exit 1
fi

# Remove .db from first parameter if any
prefix=$1
dbname_without_postifix=${prefix/.db/}

dbname=${dbname_without_postifix}.db

if [ ! -r $dbname ]; then
	echo "Unknown database: ${dbname}"
	exit 1
fi



if [ -r $dbname_without_postifix.db.new ]; then
	mv $dbname_without_postifix.db $dbname_without_postifix.db.old
	mv $dbname_without_postifix.db.new $dbname_without_postifix.db
	rm -f $dbname_without_postifix.db.old.gz
	gzip $dbname_without_postifix.db.old &
fi


echo === Docker container ====
echo `date`: RESTARTED
set -x
./moo $dbname_without_postifix.db $dbname_without_postifix.db.new $2

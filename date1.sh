#!/bin/bash

if [ $# -lt 1 ]; then
	echo "usage: ./date1.sh <diffs> <unit> [format]"
	exit 1
fi

D=$1
U=$2

if [ $# -gt 2 ]; then
	F=$3
else
	F="+%Y-%m-%d"
fi

RET=$(date $F --date="$D $U")
echo "$RET"


#!/bin/bash

print_try(){
	echo "Try 'date2.sh -h' for more information"
	exit 1
}

print_help(){
	echo "usage: date2.sh -d <diffs> -u <unit> [-f format]"
	exit 1
}

while getopts d:u:f:h opt
do
	echo "opt=$opt, OPTARG=$OPTARG"
	case $opt in
		d)
			D=$OPTARG;;
		u)
			U=$OPTARG;;
		f)
			F=$OPTARG;;
		h)
			print_help;;
		*)
			print_try;;
	esac
done

if [ "$F"="" ]; then
	F=+"%Y-%m-%d"
fi
RET=$(date $F --date="$D $U")
echo "$RET"

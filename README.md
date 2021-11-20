# assignment_20203174

> shellscript
>> getopt
>>
>> getopts
>
> command
>> sed
>> 
>> awk

## shellscript

기존에 쓰던 방식에서 getopt, getopts를 이용해서 좀 더 우아한 옵션을 줄 수 있다.

* 기존에 쓰던 방식

`date +%Y-%m-%d`

2020-12-20

`date +%Y-%m-%d`

2020-12-22

`date +%Y-%m-%d`

2020-12-18

이를 date1.sh에 작성해보자
```sh
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
```
쉘 스크립트나 함수가 파라미터(argument)를 받는 기본 방식

!<img src="https://user-images.githubusercontent.com/93987703/142729665-9d6e1f8c-6d12-45d2-ad37-17a222c461fe.jpg" width="50%" height="50%"/>

그런데 이렇게 주고 싶을 수 있다.
`. date1.sh -d 3 -u day -f`

이럴 때 getopts를 사용하면 된다.
|usage|getopts option_string varname|
|---|---|
|option_string|옵션을 정의하는 문자, 뒤에 콜론(:)이 있으면 옵션값을 받는 다는 의미|
|varname|옵션 명(d, u, f)을 받을 변수, OPTARG 변수에는 실제 옵션의 값이 세팅|

getopts를 이용한 date2.sh을 작성해보자

```sh
#!/bin/bash

print_try(){  #-h옵션을 넣으면 사용법이 출력됨을 알려줌
	echo "Try 'date2.sh -h' for more information"
	exit 1
}

print_help(){  #사용법을 출력해줌
	echo "usage: date2.sh -d <diffs> -u <unit> [-f format]"
	exit 1
}

while getopts d:u:f:h opt 
# d, u, f, h는 각각 입력 받는 옵션 값
# 뒤에 콜론(:)이 붙으면 옵션에 해당하는 인자값이 입력된다는 의미
# 각각 옵션은 opt변수로 들어간다.
do
	# echo "opt=$opt, OPTARG=$OPTARG" 출력할 때 확인용으로 사용
	case $opt in
		d)  #d옵션에 해당하는 인자값을 변수 D에 넣음
			D=$OPTARG;;
		u)  #u옵션에 해당하는 인자값을 변수 U에 넣음
			U=$OPTARG;;
		f)  #f옵션에 해당하는 인자값을 변수 F에 넣음
			F=$OPTARG;;
		h)  #사용법을 화면에 출력
			print_help;;
		*)
			print_try;;
	esac
done

if [ "$F"="" ]; then  #
	F=+"%Y-%m-%d"
fi
RET=$(date $F --date="$D $U")
echo "$RET"
```

이번에는 긴 옵션을 줄 수도 있다.

예를 들어

`date3.sh --diffs 3 --unit month --format +%Y-%m-%d`

2020-03-20

```sh
#!/bin/bash

print_try(){
	echo "Try 'date3.sh -h' for more information"
	exit 1
}

print_help(){
	echo "usage: date3.sh -d <diffs> -u <unit> [-f format]"
	exit 1
}

options="$(getopt -o d:u:f:h -l diffs:,unit:,format:,help - "$@")"
eval set --$options

while true
do
	# echo "$1,$2	[$@]"
	case $1 in
		-d|--diffs)
			D=$2
			shift 2;;
		-u|--unit)
			U=$2
			shift 2;;
		-f|--format)
			F=$2
			shift 2;;
		-h|--help)
			print_help;;
		--)
			break;;
		*)
			print_try;;
	esac
done

if [ "$F"="" ]; then
	F=+"%Y-%m-%d"
fi
RET=$(date $F --date="$D $U")
echo "$RET"
```

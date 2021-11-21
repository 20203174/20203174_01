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

<img src="https://user-images.githubusercontent.com/93987703/142729665-9d6e1f8c-6d12-45d2-ad37-17a222c461fe.jpg" width="50%" height="50%"/>

그런데 이렇게 주고 싶을 수 있다.
`. date1.sh -d 3 -u day -f`

* getopts

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

* getopt

이번에는 긴 옵션을 줄 수도 있다.
|usage|getopt -o/--options shortops [-l/--longoptioins Longopts] [-n/--name progname] [--] parameters|
|---|---|
|shortopts|옵션을 정의하는 문자|
|Longopts|긴 옵션을 정의하는 문자(--diffs와 같은 긴 옵션 정의), 콤마로 구분한다|
|progname|오류 발생시 리포팅할 프로그램 명칭(현재 쉘 스크립트 파일명)|
|parameters|옵션에 해당하는 실제 명령 구문(보통은 모든 파라미터를 뜻하는 $@사용)|

예를 들어

`date3.sh --diffs 3 --unit month --format +%Y-%m-%d`

2020-03-20

```sh
#!/bin/bash

print_try(){  #-h옵션을 주면 사용법을 출력할 수 있다고 알려줌
	echo "Try 'date3.sh -h' for more information"
	exit 1
}

print_help(){  #사용법을 출력해줌
	echo "usage: date3.sh -d <diffs> -u <unit> [-f format]"
	exit 1
}

options="$(getopt -o d:u:f:h -l diffs:,unit:,format:,help - "$@")"  
# 짧은 옵션을 받는 d, u, f, h
# 긴 옵션을 받는 diffs, unit, format, help
# 입력 받는 인자가 있는 경우 콜론(:)을 붙임
eval set --$options  
# 문자열을 명령어처럼 사용하는 eval
# set은 잘라주는 역할을 함
# 하이픈(-)하이픈(-)이 마지막에 추가되어서 총 7개의 set생김

while true
do
	# echo "$1,$2	[$@]" 확인용으로 사용
	case $1 in
		-d|--diffs)  #-d 또는 --diffs를 입력한 경우
			D=$2
			shift 2;;
		-u|--unit)  #-u 또는 --unit를 입력한 경우
			U=$2
			shift 2;;
		-f|--format)  #-f 또는 --format를 입력한 경우
			F=$2
			shift 2;;
		-h|--help)  #-h 또는 --help를 입력한 경우
			print_help;;
		--)
			break;;
		*)
			print_try;;
	esac
done

if [ "$F"="" ]; then  #format값으로 아무것도 입력 되지 않았을 때 default값을 넣어줌
	F=+"%Y-%m-%d"
fi

RET=$(date $F --date="$D $U")
echo "$RET"
```

## command

* awk 명령어

> 대부분의 리눅스 명령들이, 그 명령의 이름만으로 대략적인 기능이 예상되는 것과 다르게, awk 명령은 이름에 그 기능을 의미하는 단어나 약어가 포함되어 있지 않다. awk는 최초에 awk 기능을 디자인한 사람들의 이니셜을 조합하여 만든 이름이다.


> awk는 파일로부터 레코드(record)를 선택하고, 선택된 레코드에 포함된 값을 조작하거나 데이터화하는 것을 목적으로 사용하는 프로그램이다. 즉, awk 명령의 입력으로 지정된 파일로부터 데이터를 분류한 다음, 분류된 텍스트 데이터를 바탕으로 패턴 매칭 여부를 검사하거나 데이터 조작 및 연산 등의 액션을 수행하고, 그 결과를 출력하는 기능을 수행한다.

> awk명령으로 할 수 있는 일들
<img src="https://user-images.githubusercontent.com/93987703/142756033-1a9160ea-6689-40cd-9f5c-1deb2e47503f.png" width="70%" height="70%"/>

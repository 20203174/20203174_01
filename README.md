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

> awk는 기본적으로 입력 데이터를 라인(line) 단위의 레코드(Record)로 인식한다. 그리고 각 레코드에 들어 있는 텍스트는 공백 문자(space, tab)로 구분된 필드(Field)들로 분류되는데, 이렇게 식별된 레코드 및 필드의 값들은 awk 프로그램에 의해 패턴 매칭 및 다양한 액션의 파라미터로 사용된다. 

<img src="https://user-images.githubusercontent.com/93987703/142756132-6a996afe-d0d2-4a06-9444-6ff703ad2af7.png" width="70%" height="70%"/>

> awk명령어 옵션

|usage|awk [OPTION...] [awk program] [ARGUMENT...]|
|---|---|
|OPTION(-F)|필드 구분 문자 지정|
|OPTION(-f)|awk program 파일 경로 지정|
|OPTION(-v)|awk program 에서 사용될 특정 변수값 지정|
|awk program|-f옵션이 사용되지 않은 경우, awk가 실행할 awk program 코드 지정|
|ARGUMENT|입력 파일 지정 또는 변수값 지정|

> 예제

|awk 사용 예|	명령어 옵션|
|---|---|
|파일의 전체 내용 출력|	awk '{ print }' [FILE]|
|필드 값 출력|	awk '{ print $1 }' [FILE]|
|필드 값에 임의 문자열을 같이 출력|	awk '{print "STR"$1, "STR"$2}' [FILE]|
|지정된 문자열을 포함하는 레코드만 출력|	awk '/STR/' [FILE]|
|특정 필드 값 비교를 통해 선택된 레코드만 출력|	awk '$1 == 10 { print $2 }' [FILE]|
|특정 필드들의 합 구하기|	awk '{sum += $3} END { print sum }' [FILE]|
|여러 필드들의 합 구하기|	awk '{ for (i=2; i<=NF; i++) total += $i }; END { print "TOTAL : "total }' [FILE]|
|레코드 단위로 필드 합 및 평균 값 구하기|	awk '{ sum = 0 } {sum += ($3+$4+$5) } { print $0, sum, sum/3 }' [FILE]|
|필드에 연산을 수행한 결과 출력하기|	awk '{print $1, $2, $3+2, $4, $5}' [FILE]|
|레코드 또는 필드의 문자열 길이 검사|	awk ' length($0) > 20' [FILE]|
|파일에 저장된 awk program 실행|	awk -f [AWK FILE] [FILE]|
|필드 구분 문자 변경하기|	awk -F ':' '{ print $1 }' [FILE]|
|awk 실행 결과 레코드 정렬하기|	awk '{ print $0 }' [FILE]|
|특정 레코드만 출력하기|	awk 'NR == 2 { print $0; exit }' [FILE]|
|출력 필드 너비 지정하기|	awk '{ printf "%-3s %-8s %-4s %-4s %-4s\n", $1, $2, $3, $4, $5}' [FILE]|
|필드 중 최대 값 출력|	awk '{max = 0; for (i=3; i<NF; i++) max = ($i > max) ? $i : max ; print max}' [FILE]|


* sed 명령어

> sed 명령어 알기

sed 명령어는 편집에 특화된 명령어다. 수정, 치환, 삭제, 글 추가 등 편집기능이 모두 가능하다. vi편집기는 편집기를 열어서 서로 소통하듯 수정/변경을 해나가는 대화형 방식인 반면에, sed는 명령행에서 파일을 인자로 받아 명령어를 통해 작업한 후 결과를 화면으로 확인하는 방식이다.

특징은 원본을 손상하지 않는다는 점이다. 쉘 리다이렉션을 이용해 편집 결과를 저장하기 전까지는 파일에 아무런 변경도 가하지 않는다. 모든 결과는 명령을 수행 후 화면으로 출력되는데 출력된 결과가 원본과 다르더라도 원본에 손해가 없다는 게 특징이다.

> 패턴 스페이스(Pattern space)와 홀드 스페이스(Hold space)

sed 명령어는 동작시 내부적으로 두 개의 워크스페이스를 사용하는데, (마치 복사 붙여넣기의 임시 저장소 클립보드와 같다) 이 두 버퍼를 패턴 스페이스와 홀드 스페이스라고 한다.

<img scr="https://user-images.githubusercontent.com/93987703/142757071-6c005978-f228-4fe3-8a96-3864ee7268ab.png" width="70%" height="70%"/>

패턴 버퍼는 sed가 파일을 라인 단위로 읽을 때 그 읽힌 라인이 저장되는 임시 공간이다. 

홀드 스페이스는 패턴 버퍼처럼 짧은 순간 임시 버퍼가 아니라 좀 더 길게 가지고 있는 저장소이다. 두 번째 라인을 작업중이더라도 첫 번째 라인을 기억할 수 있는 것이다. 즉, 어떤 내용을 홀드 스페이스에 저장하면 sed가 다음 행을 읽더라도 나중에 내가 원할 때 불러와서 재사용할 수 있는 버퍼가 된다.



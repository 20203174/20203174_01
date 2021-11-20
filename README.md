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

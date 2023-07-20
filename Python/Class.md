# Class란?

함수와 변수를 하나의 객체로 묶어서 선언하는 것으로 독립적인 메모리 공간에 객체(instance)를 생성하여 사용가능하다.

### class의 특징

1) 독립된 메모리 공간을 사용하므로 가용성을 확보할 수 있다.
2) 상속을 통해 빠른 기능구현이 가능.

```
# var_1과 func_1을 묶어 myClass라는 클래스 선언

class myClass:
  var_1 = "'Hello Class >>> Class Member'"

  def func_1(self):
    var_2 = "'Method >>> Instance Member'"
    print(self.var_1, 'AND', var_2)
```
```
obj = myClass()
	# obj라는 객체(instance)를 생성
```
### Member 및 Method

Class Method : class내에 선언된 함수, 여기서는 func_1
Class Member : class내에 선언된 변수, 여기서는 var_1
Instance Member : Class Method내에 선언된 변수, 여기서는 var_2

### self

self란 class로 생성한 객체(instance)자체를 지정하는 것으로 self를 사용하여 class member에 접근가능하다.
self.var_1를 살펴보면 self로 var_1라는 class member에 접근함을 볼 수  있다.



# Module이란?

변수, 함수, 클래스 등의 코드를 포함하고 있는 파이썬 스크립트로 파일 단위로 구성된다.

### module의 특징

1. 파이썬 파일에서 모듈을 import하여 사용할 수 있으므로 코드를 분할하여 관리할 수 있다.
2. 모듈로 인해 코드의 가독성과 재사용성을 확보할 수 있다.

~~~
# myModule.py라는 모듈의 구조
variable = 10

def func_1():
	# 함수 구현
	
class myClass:
	# 클래스 구현
~~~

~~~
# 다른 파일에서 모듈을 import하여 사용
import myModule

print(myModule.variable) # 10 출력
myModule.func_1() # 함수 호출
~~~

### module의 유형

1. 내장 모듈 : 파이썬 자체에 기본적으로 포함되어있는 모듈로  time, datetime, sys등의 모듈이 있다.
2. 사용자 모듈 : 파이썬 사용자가 만든 모듈로 손쉽게 공유하여 재사용 가능하다.
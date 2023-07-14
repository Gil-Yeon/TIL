## Class란?
함수와 변수를 하나의 객체로 묶어서 선언하는 것으로 독립적인 메모리 공간에 instance를 생성하여 사용가능하다.

#### class의 특징
1) 독립된 메모리 공간을 사용하므로 가용성을 확보할 수 있다.
2) 상속을 통해 빠른 기능구현이 가능.

```
class myClass:
  var_1 = "'Hello Class >>> Class Member'"

  def func_1(self):
    var_2 = "'Method >>> Instance Member'"
    print(self.var_1, 'AND', var_2)
```
```
obj = myClass()
```
var_1과 func_1을 하나로 묶어 myClass라는 class로 선언하고 obj라는 instance를 생성한다.

#### Member 및 Method
Class Method : class내에 선언된 함수, 여기서는 func_1
Class Member : class내에 선언된 변수, 여기서는 var_1
Instance Member : Class Method내에 선언된 변수, 여기서는 var_2

#### self
self란 class로 생성한 instance자체를 지정하는 것으로 self를 사용하여 class member에 접근가능하다.
self.var_1를 살펴보면 self로 var_1라는 class member에 접근함을 볼 수  있다.
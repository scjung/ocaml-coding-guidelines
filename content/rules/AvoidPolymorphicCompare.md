* Language: ko 
* Keywords: comparison, Pervasives, polymorphism, performance

# 되도록 다형 비교 함수를 사용하지 마시오.

되도록 어떠한 값이라도 비교하는 다형 비교 함수인 `Pervasives.compare`를 그대로 사용하지 마십시오. 다형 비교 함수는 실행시간(run-time)에 비교할 대상의 타입을 조사하고 비교할 방법을 결정하기 때문에 성능이 저하됩니다. 다형 비교 함수 대신 비교할 대상의 타입이 결정된 비교 함수를 사용하는 것이 좋습니다.

예를 들어 다음과 같은 프로그램 살펴 봅시다.

```ocaml
type value = ...
(* 'a -> 'a -> int *)
let compare_value = Pervasives.compare
```

다음과 같이 `Pervasives.compare` 함수에 에타 변환(conversion)을 적용하여 인수의 타입을 한정지을 수 있습니다.

```ocaml
type value = ...

(* value -> value -> int *)
let compare_value (x : value) y = Pervasives.compare x y

```
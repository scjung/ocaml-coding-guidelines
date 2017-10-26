* Language: ko 
* Keywords: comparison, Pervasives, polymorphism, performance

# 되도록 다형(polymorphic) 비교 함수를 사용하지 마시오.

되도록 어떠한 값이라도 비교하는 다형(polymorphic) 비교 함수인 `Pervasives.compare`를 그대로 사용하지 마십시오. 다형 비교 함수는 실행시간(run-time)에 비교할 대상의 타입을 조사하고 비교할 방법을 결정하기 때문에 성능이 저하됩니다. 다형 비교 함수 대신 비교할 대상의 타입이 결정된 비교 함수를 사용하는 것이 좋습니다.

예를 들어 다음과 같은 프로그램 살펴 봅시다.

```ocaml
type value = string
(* 'a -> 'a -> int *)
let compare_value_1 = Pervasives.compare
```

여기서는 `value` 타입을 새로 정의하고, `value` 값끼리 비교할 때는 `Pervasives.compare` 함수를 사용하도록 정의하였습니다. 그런데 `Pervasives.compare` 함수는 `value` 타입 외의 값도 비교할 수 있는 다형 함수이므로 `compare_value` 함수 역시 다형 함수입니다. 즉 이 함수를 다음과 같이 사용할 수 있습니다.

```ocaml
# type value = string;;
type value = string
# let compare_value_1 = Pervasives.compare;;
val compare_value_1 : 'a -> 'a -> int = <fun>
# compare_value_1 1 2;;   (* value 타입 외의 값도 비교 가능 *)
- : int = -1
```

이렇게 특정 타입을 비교하는 함수를 만들 때는 다음과 같이 인수 타입을 명시하고 `Pervasives.compare` 함수에 전달하는 식으로(eta-conversion) 구현해야 합니다.

```ocaml
(* value -> value -> int *)
let compare_value_2 (x : value) y = Pervasives.compare x y
```

다음은 앞에서 살펴본 두 비교 함수의 성능을 측정해 본 결과입니다.

|  | Rate | `compare_value_1` | `compare_value_2` |
| --- | ---: | ---: | ---: |
| `compare_value_1` | 292783±1563/s | | -46% |
| `compare_value_2` | 545889±1129/s | 86% | |

(`value` 타입의 무작위 쌍 100개 비교, 2.93 GHz Intel Core i7, 16 GB 1333 MHz DDR3)

다음은 앞에서 살펴본 두 비교 함수를 컴파일한 중간 언어 코드입니다.

```
     compare_value_1/1211 =
       (function prim/1458 prim/1457 (caml_compare prim/1458 prim/1457))
     compare_value_2/1212 =
       (function t1/1213 t2/1214
         (funct-body bench.ml(9)<ghost>:146-190
           (before bench.ml(9):166-190
             (after bench.ml(9):166-190
               (caml_string_compare t1/1213 t2/1214)))))
```
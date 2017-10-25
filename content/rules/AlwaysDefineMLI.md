* Language: ko 
* Keywords: interface, mli

# 항상 mli 파일을 정의하시오.

항상 ml 구현 파일에 대응하는 mli 인터페이스 파일을 작성하십시오. 작성하는 mli 파일에는 ml 파일을 사용하는 측에서 필요한 내용만을 기술해야 합니다 (information hiding). 그래야만 사용자가 모듈을 이해하기 쉽고 불필요한 의존 관계가 생기지 않습니다.

예를 들어 다음과 같은 ml 파일을 살펴봅시다.

```ocaml
(* ml *)
type data = int
type result = string

let counter = ref 0 (* 처리 과정에서 사용. process에서 초기화 *)
let load_data () = ... (* data 값을 로드 *)
let inner_work x = ... (* data 값을 *)
let process x = ... (* data 값을 처리함 *)
```

이러한 ml 파일만 작성하면 사용하는 측에서는 다음과 같은 의문이 생길 것입니다.

* 함수의 인수 타입과 결과 타입은 무엇인가?
* 함수를 어떤 순서대로 사용해야 하는가?
* counter 값은 어디서 초기화되고 어디서 바뀌는가? 밖에서 조작해도 되는 값인가?
* inner_work 함수는 호출해도 되는 것인가?
* data, result 타입은 이후로도 int, string 타입인가? 임의의 int, string 값을 data, result 값으로 지정해도 괜찮은가?

이러한 의문은 모두 코드를 해석해야만 해결할 수 있습니다. 따라서 다음과 같은 mli 파일을 작성하면 모듈을 이해하는데 큰 도움이 됩니다.

```ocaml
(* mli *)
type data    (** 처리할 데이터 *)
type result  (** 처리한 결과 *)

(** 데이터를 로드한다. *)
val load_data : unit -> data

(** 데이터를 처리하여 결과를 내준다. *)
val process : data -> result
```

mli 파일에서 다음 사실을 알 수 있습니다.

* `data`, `result` 타입은 공개되지 않았으므로 모듈에서 제공하는 함수로만 만들 수 있다.
* 따라서 함수의 실행 순서는 자연스럽게 `load_data`, `process` 순이다. `process` 함수는 `data` 값을 받는데 `load_data` 함수로만 `data` 값을 만들 수 있기 때문이다.
* 모듈 내에 존재하는 `counter` 값은 모듈 밖에서 조작할 수 없다. 사용자는 이 값이 어떻게 초기화되고 바뀌는지 신경쓸 필요가 없다.
* 모듈 내에 존재하는 `inner_work` 함수는 모듈 밖에서 호출할 수 없다. 따라서 이 함수는 작업 도중 보조 용도로만 쓰이는 함수임을 알 수 있다.

다음과 같은 명령을 사용하면 ml 파일에서 mli 파일을 자동으로 생성할 수 있습니다.

```sh
$ ocamlc -i Foo.ml > Foo.mli
```

이렇게 생성된 mli 파일 내에는 모든 선언의 타입이 나타납니다. 따라서 항상 생성된 파일을 검토하여 불필요한 선언을 제거하고 적절한 ocamldoc을 작성해야 합니다.

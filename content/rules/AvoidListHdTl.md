* Language: ko 
* Keywords: list, pattern matching

# List.hd, List.tl 함수 대신 패턴 매칭을 사용하시오.

`List.hd`, `List.tl` 함수로 리스트의 머리와 꼬리를 꺼내지 마십시오. 이 함수는 빈 리스트를 처리하지 못하고 `Failure` 예외를 발생시킵니다. OCaml은 예외 처리를 강제하지 않아 프로그래머가 예외 처리를 빠트리기 쉬우므로 되도록 이러한 함수 대신 패턴 매칭을 사용해야 합니다.

예를 들어 다음과 같은 프로그램을 살펴 봅시다.

```ocaml
let process list =
  let (x, y) = List.hd list, List.tl list in
  (work x, y)
```

여기서 구현한 함수는 빈 리스트를 처리하지 않았습니다. 따라서 함수에 빈 리스트를 전달하면 다음과 같이 예외가 발생합니다.

비록 빈 리스트가 주어질 때 예외를 발생시키는 것이 의도한 것이라도 다음과 같이 패턴 매칭을 사용하여 작성해서 명확히 드러내는 것이 좋습니다.

```ocaml
let process list =
  match list with
  | []     -> invalid_arg “process: nil”
  | (x, y) -> (work x, y)
```

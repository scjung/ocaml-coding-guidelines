* Language: ko 
* Keywords: array, index

# 배열 인덱스가 범위를 넘지 않도록 주의하시오.

기본적으로 OCaml은 Java처럼 실행시간(runtime)에 인덱스가 올바른 범위 내인지 검사한 후 사용합니다. 만일 인덱스가 범위 밖이라면 `Invalid_argument` 예외를 발생시킵니다. 하지만 `-unsafe` 컴파일 옵션을 사용하면 이러한 검사를 수행하지 않도록 할 수도 있습니다.

예를 들어 다음과 같은 프로그램을 살펴봅시다.

```ocaml
let array = [| "Hello"; "world"; |]

let () =
  let i = int_of_string (Sys.argv.(1)) in
  print_endline array.(i)
```

이를 컴파일 후 사용하면 다음과 같은 예외가 발생합니다.

```sh
$ ocamlopt -o test test.ml
$ ./test
Exception: Invalid_argument "index out of bounds".
   # Sys.argv 배열의 길이가 1이므로
$ ./test 1
world
$ ./test 2
Exception: Invalid_argument "index out of bounds".
   # array 배열의 길이가 2이므로
```

따라서 항상 배열에 접근할 때는 `Invalid_argument` 예외가 발생할 수 있음을 생각하고 적절하게 예외를 처리해야 합니다. 다음은 앞의 프로그램을 수정한 예입니다.

```ocaml
let array = [| "Hello"; "world"; |]

let () =
  try
    let i = int_of_string (Sys.argv.(1)) in
    print_endline array.(i)
  with
  | Invalid_argument _ ->
      prerr_endline "Invalid index."
```

당연히 이러한 검사 과정은 성능을 저하시킵니다. 때문에 OCaml 컴파일는 배열 인덱스 검사를 수행하지 않도록 하는 `-unsafe` 옵션을 제공합니다. 이 옵션을 사용하면 성능이 개선되지만, 범위 밖의 인덱스가 사용될 때 프로그램에서 **처리할 수 없는 오류**가 발생합니다.

```sh
$ ocamlopt -unsafe -o test test.ml
$ ./test
[1]    11061 segmentation fault  ./test
$ ./test 1
world
$ ./test 2
[1]    11080 segmentation fault  ./test
```

따라서 모든 배열 인덱스가 항상 범위 내임을 확실히 검증한 후에만 `-unsafe` 옵션을 사용하십시오.

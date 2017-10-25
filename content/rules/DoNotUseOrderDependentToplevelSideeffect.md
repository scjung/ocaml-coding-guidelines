* Language: ko 
* Keywords: side-effect

# 항상 탑레벨(toplevel)에서 발생하는 부수 효과(side-effect)는 모듈 순서와 상관없게 하시오.

```ocaml
(* def.ml *)
let i = ref 0
```
```ocaml
(* a.ml *)
let () =
  incr Def.i;
  print_endline ("A: i = " ^ (string_of_int !Def.i))
```
```ocaml
(* b.ml *)
let () =
  incr Def.i;
  print_endline ("B: i = " ^ (string_of_int !Def.i))
```

```sh
$ ocamlopt -o test def.ml a.ml b.ml
$ ./test
A: i = 1
B: i = 2
```
```sh
$ ocamlopt -o test def.ml b.ml a.ml
$ ./test
B: i = 1
A: i = 2
```

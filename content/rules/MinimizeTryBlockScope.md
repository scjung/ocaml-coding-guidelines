* Language: ko 
* Keywords: interface, mli

# try 블록의 영역을 최소화하시오.

try 블록은 꼬리재귀(tail-recursion)를 방해하므로 try 블록 영역을 최소화해야 합니다.

예를 들어 다음과 같은 프로그램을 살펴 봅시다.

```ocaml
let rec fail_safe_fold_left f accum = function
  | []     -> accum
  | h :: t ->
      try
        fail_safe_fold_left f (f accum h) t
      with
      | Failure _ -> accum
```

```ocaml
# let really_long_list =
    let l = ref [] in for i = 1 to 1_000_000 do l := i :: !l done; !l;;
val really_long_list : int list = [1000000; 999999; 999998; 999997; ...

# fail_safe_fold_left (+) 0 really_long_list;;
Stack overflow during evaluation (looping recursion?).
```

```ocaml
let rec fail_safe_fold_left f accum = function
  | []     -> accum
  | h :: t ->
      let accum =
        try f accum h with Failure _ -> accum
      in
      fail_safe_fold_left f accum t
```

```ocaml
# fail_safe_fold_left (+) 0 really_long_list;;
- : int = 500000500000
```

```ocaml
        let rec aux outch i c =
            try
              let p = input_line inch in
              let outch =
                if c = 0 then (
                  let f = mll_name i in
                  Printf.eprintf "%s     ...%!" f;
                  let outch = open_out f in
                  append_file outch "prologue.mll.part";
                  outch
                ) else
                  outch
              in
              Printf.fprintf outch "| \"%s\"\n" (String.escaped p);
              let (i, c) =
                if c = n then
                  let () = epilogue outch i in
                  (i + 1, 0)
                else
                  (i, c + 1)
              in
              aux outch i c
            with
            | End_of_file ->
                if c <> 0 then epilogue outch i;
                close_in_noerr inch
          in
          aux stdnull 0 0
```
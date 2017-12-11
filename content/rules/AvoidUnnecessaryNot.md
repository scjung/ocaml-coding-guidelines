* Language: ko 
* Keywords: wildcard, pattern matching

# 되도록 불필요한 not 연산은 사용하지 마시오.	

```ocaml
if !x then
  (* ...block A... *)
else
  (* ...block B... *)
```

```ocaml
if x then
  (* ...block B... *)
else
  (* ...block A... *)
```

```ocaml
if !(x = 0) then
  (* ...block A... *)
else
  (* ...block B... *)
```

```ocaml
if x <> 0 then
  (* ...block A... *)
else
  (* ...block B... *)
```

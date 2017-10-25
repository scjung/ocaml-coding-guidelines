* Language: ko
* Keywords: peformance, list

# 리스트를 다룰 때는 성능을 유의하시오.

* `List.map f` 대신 `List.rev (List.rev_map f)` 사용 권장


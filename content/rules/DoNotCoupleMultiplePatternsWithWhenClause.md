* Language: ko 
* Keywords: array, index

# 여러 패턴에 하나의 when-절을 붙이지 마시오.

예를 들어 다음과 같은 코드가 있을 때,

```
match (v1, v2) with
| (Foo x, _) | (_, Foo x) when is_it x ->
     ...CODE...
     
| ...PATTERNS....
```

프로그래머는 `v1` 태그 `Foo`에 달린 값이 `is_it`을 만족하거나 `v2` 태그 `Foo`에 달린 값이 `is_it`을 만족할 때 `CODE`를 수행하길 원했을 수 있습니다. 하지만 이 코드는 그런 의미가 전혀 아닙니다. 실제 의미는 다음과 같습니다.

* `v1`의 태그가 `Foo`인가?
	* 그렇다면 `v1` 태그 `Foo`에 달린 값이 `is_it`을 만족하는가?
		* 그렇다면 `CODE`를 수행함
		* 그렇지 않다면 `PATTERN` 절로 진행
	* 아니라면 `v2` 태그

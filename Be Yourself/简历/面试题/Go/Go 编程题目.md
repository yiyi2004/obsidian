- Time：2023-06-24 20:19
- Label： #面试题 #coding #go

## Abstract

## Content

### 字符串替换问题

```go
func replaceBlank(s string) (string, bool) {
	if len([]rune(s)) > 1000 {
		return s, false
	}
	for _, v := range s {
		if string(v) != " " && unicode.IsLetter(v) == false {
			return s, false
		}
	}
	return strings.Replace(s, " ", "%20", -1), true
}
```

1. unicode.IsLetter()
2. strings.Replace(s, " ", "%20", -1)

## Reference

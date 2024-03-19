## Domain

### Article

```go
type Article struct {
	Id      int64
	Title   string
	Status  int32
	Content string
	Tags    []string
}
```

### search_result

```go
type SearchResult struct {  
    Users    []User  
    Articles []Article  
}
```

### User

```go
type User struct {
	Id       int64
	Email    string
	Nickname string
	Phone    string
}
```

## Repository



## Service

## Event

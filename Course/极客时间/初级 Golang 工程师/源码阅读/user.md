- sql.NullString
- 因为是根据 id 缓存的

```go
func (ur *CachedUserRepository) FindById(ctx context.Context,  
    id int64) (domain.User, error) {  
    u, err := ur.cache.Get(ctx, id)  
    // 注意这里的处理方式  
    if err == nil {  
       return u, err  
    }  
    if ctx.Value("downgrade") == "true" {  
       // 触发了降级，直接返回  
       return domain.User{},  
          errors.New("缓存中没有数据，并且触发了降级，放弃查询数据库")  
    }  
    ue, err := ur.dao.FindById(ctx, id)  
    if err != nil {  
       return domain.User{}, err  
    }  
    u = ur.entityToDomain(ue)  
    // 忽略掉这里的错误  
    _ = ur.cache.Set(ctx, u)  
    return u, nil  
}
```

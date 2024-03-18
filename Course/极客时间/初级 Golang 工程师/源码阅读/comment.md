domain

```go
type Comment struct {  
    Id int64 `json:"id"`  
    // 评论者  
    Commentator User `json:"user"`  
    // 评论对象  
    // 数据里面  
    Biz   string `json:"biz"`  
    BizID int64  `json:"bizid"`  
    // 评论对象  
    Content string `json:"content"`  
    // 根评论  
    RootComment *Comment `json:"rootComment"`  
    // 父评论  
    ParentComment *Comment  `json:"parentComment"`  
    Children      []Comment `json:"children"`  
    CTime         time.Time `json:"ctime"`  
    UTime         time.Time `json:"utime"`  
}  
  
type User struct {  
    ID   int64  `json:"id"`  
    Name string `json:"name"`  
}
```

## Dao

```go
type CommentDAO interface {  
    Insert(ctx context.Context, u Comment) error  
    // FindByBiz 只查找一级评论  
    FindByBiz(ctx context.Context, biz string,  
       bizId, minID, limit int64) ([]Comment, error)  
    // FindCommentList Comment的id为0 获取一级评论，如果不为0获取对应的评论，和其评论的所有回复  
    FindCommentList(ctx context.Context, u Comment) ([]Comment, error)  
    FindRepliesByPid(ctx context.Context, pid int64, offset, limit int) ([]Comment, error)  
    // Delete 删除本节点和其对应的子节点  
    Delete(ctx context.Context, u Comment) error  
    FindOneByIDs(ctx context.Context, id []int64) ([]Comment, error)  
    FindRepliesByRid(ctx context.Context, rid int64, id int64, limit int64) ([]Comment, error)  
}
```

```go
type Comment struct {  
    Id int64 `gorm:"column:id;primaryKey" json:"id"`  
    // 发表评论的用户  
    Uid int64 `gorm:"column:uid;index" json:"uid"`  
    // 发表评论的业务类型  
    Biz string `gorm:"column:biz;index:biz_type_id" json:"biz"`  
    // 对应的业务ID  
    BizID int64 `gorm:"column:biz_id;index:biz_type_id" json:"bizID"`  
    // 根评论为0表示一级评论  
    RootID sql.NullInt64 `gorm:"column:root_id;index" json:"rootID"`  
    // 父级评论  
    PID sql.NullInt64 `gorm:"column:pid;index" json:"pid"`  
    // 外键 用于级联删除  
    ParentComment *Comment `gorm:"ForeignKey:PID;AssociationForeignKey:ID;constraint:OnDelete:CASCADE"`  
    // 评论内容  
    Content string `gorm:"type:text;column:content" json:"content"`  
    // 创建时间  
    Ctime int64 `gorm:"column:ctime;" json:"ctime"`  
    // 更新时间  
    Utime int64 `gorm:"column:utime;" json:"utime"`  
}
```

## Repository

```go
type CommentRepository interface {  
    // FindByBiz 根据 ID 倒序查找  
    // 并且会返回每个评论的三条直接回复  
    FindByBiz(ctx context.Context, biz string,  
       bizId, minID, limit int64) ([]domain.Comment, error)  
    // DeleteComment 删除评论，删除本评论何其子评论  
    DeleteComment(ctx context.Context, comment domain.Comment) error  
    // CreateComment 创建评论  
    CreateComment(ctx context.Context, comment domain.Comment) error  
    // GetCommentByIds 获取单条评论 支持批量获取  
    GetCommentByIds(ctx context.Context, id []int64) ([]domain.Comment, error)  
    GetMoreReplies(ctx context.Context, rid int64, id int64, limit int64) ([]domain.Comment, error)  
}
```

## Service

```go
type CommentRepository interface {  
    // FindByBiz 根据 ID 倒序查找  
    // 并且会返回每个评论的三条直接回复  
    FindByBiz(ctx context.Context, biz string,  
       bizId, minID, limit int64) ([]domain.Comment, error)  
    // DeleteComment 删除评论，删除本评论何其子评论  
    DeleteComment(ctx context.Context, comment domain.Comment) error  
    // CreateComment 创建评论  
    CreateComment(ctx context.Context, comment domain.Comment) error  
    // GetCommentByIds 获取单条评论 支持批量获取  
    GetCommentByIds(ctx context.Context, id []int64) ([]domain.Comment, error)  
    GetMoreReplies(ctx context.Context, rid int64, id int64, limit int64) ([]domain.Comment, error)  
}
```

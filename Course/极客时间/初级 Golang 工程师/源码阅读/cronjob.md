## Domain

message CronJob

```go
message CronJob {  
  int64 id = 1;  
  string name = 2;  
  string executor = 3;  
  string cfg = 4;  
  string expression = 5;  
  
  google.protobuf.Timestamp next_time = 6;  
}
```

## Dao

```go
func (dao *GORMJobDAO) Preempt(ctx context.Context) (Job, error) {  
    db := dao.db.WithContext(ctx)  
    for {  
       // 每一个循环都重新计算 time.Now，因为之前可能已经花了一些时间了  
       now := time.Now().UnixMilli()  
       var j Job  
       // 到了调度的时间  
       err := db.Where(  
          "next_time <= ? AND status = ?",  
          now, jobStatusWaiting).First(&j).Error  
       if err != nil {  
          // 数据库有问题  
          return Job{}, err  
       }  
       // 然后要开始抢占  
       // 这里利用 utime 来执行 CAS 操作  
       // 其它一些公司可能会有一些 version 之类的字段  
       res := db.Model(&Job{}).  
          Where("id = ? AND version=?", j.Id, j.Version).  
          Updates(map[string]any{  
             "utime":   now,  
             "version": j.Version + 1,  
             "status":  jobStatusRunning,  
          })  
       if res.Error != nil {  
          // 数据库错误  
          return Job{}, err  
       }  
       // 抢占成功  
       if res.RowsAffected == 1 {  
          return j, nil  
       }  
       // 没有抢占到，也就是同一时刻被人抢走了，那么就下一个循环  
    }  
}
```

- CAS 操作，乐观锁，判断 job 是否被其他协程拿着。

## Repository

```go
type CronJobRepository interface {  
    Preempt(ctx context.Context) (domain.CronJob, error)  
    UpdateNextTime(ctx context.Context, id int64, t time.Time) error  
    UpdateUtime(ctx context.Context, id int64) error  
    Release(ctx context.Context, id int64) error  
    AddJob(ctx context.Context, j domain.CronJob) error  
}
```

## Service

```go
type CronJobService interface {  
    Preempt(ctx context.Context) (domain.CronJob, error)  
    ResetNextTime(ctx context.Context, job domain.CronJob) error  
    AddJob(ctx context.Context, j domain.CronJob) error  
}
```

```go
func (s *cronJobService) Preempt(ctx context.Context) (domain.CronJob, error) {  
    j, err := s.repo.Preempt(ctx)  
    if err != nil {  
       return domain.CronJob{}, err  
    }  
    ch := make(chan struct{})  
    go func() {  
       // 这边要启动一个 goroutine 开始续约，也就是在持续占有期间  
       // 假定说我们这里是十秒钟续约一次  
       ticker := time.NewTicker(s.refreshInterval)  
       defer ticker.Stop()  
       for {  
          select {  
          case <-ch:  
             // 退出续约循环  
             return  
          case <-ticker.C:  
             s.refresh(j.Id)  
          }  
       }  
    }()  
    // 只能调用一次，也就是放弃续约。这时候要把状态还原回去  
    j.CancelFunc = func() {  
       close(ch)  
       ctx, cancel := context.WithTimeout(context.Background(), time.Second)  
       defer cancel()  
       err := s.repo.Release(ctx, j.Id)  
       if err != nil {  
          s.l.Error("释放任务失败",  
             logger.Error(err),  
             logger.Int64("id", j.Id))  
       }  
    }  
    return j, nil  
}

```

## Main

分布式定时任务

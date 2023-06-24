- Time：2023-06-24 16:50
- Label： #源码阅读 #go #memos #coding

## Abstract

![[Snipaste/Pasted image 20230624171517.png]]  

[PocketBase](https://pocketbase.io/) is an open source Go backend, consisting of:

- embedded database (_SQLite_) with **realtime subscriptions**
- built-in **files and users management**
- convenient **Admin dashboard UI**
- and simple **REST-ish API**

## Content

pocketbase 源码

```go
func (h *Hook[T]) PreAdd(fn Handler[T]) {
	h.mux.Lock()
	defer h.mux.Unlock()
	// minimize allocations by shifting the slice
	h.handlers = append(h.handlers, nil)
	copy(h.handlers[1:], h.handlers)
	h.handlers[0] = fn
}
```

```go
func (h *Hook[T]) Trigger(data T, oneOffHandlers ...Handler[T]) error {
	h.mux.RLock()
// 拼接多个 handlers 应该这样拼接喔，所以为什么需要拼接捏？
	handlers := make([]Handler[T], 0, len(h.handlers)+len(oneOffHandlers))
	handlers = append(handlers, h.handlers...)
	handlers = append(handlers, oneOffHandlers...)
	// unlock is not deferred to avoid deadlocks when Trigger is called recursive by the handlers
	h.mux.RUnlock()
	for _, fn := range handlers {
		err := fn(data)
		if err == nil {
			continue
		}
		if errors.Is(err, StopPropagation) {
			return nil
		}
		return err
	}
	return nil
}
```

今天在编码方便已经学到东西了，接下来都是附加的，牛蛙牛蛙。  
兼容开发效率和内存利用效率

```go
	// wait for interrupt signal to gracefully shutdown the application
	go func() {
		defer wg.Done()
		quit := make(chan os.Signal, 1) // we need to reserve to buffer size 1, so the notifier are not blocked
		signal.Notify(quit, os.Interrupt, syscall.SIGTERM)
		<-quit
	}()
// 这段代码是什么意思呢？
```

## Reference

- [pocketbase/pocketbase: Open Source realtime backend in 1 file (github.com)](https://github.com/pocketbase/pocketbase)

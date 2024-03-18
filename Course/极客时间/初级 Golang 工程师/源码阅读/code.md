repository

cache

```go
type CodeCache interface {
	Set(ctx context.Context, biz string,
		phone string, code string) error

	Verify(ctx context.Context, biz string,
		phone string, inputCode string) (bool, error)
}
```

lua

set_code

```lua
-- 发送到的 key，也就是 code:业务:手机号码  
local key = KEYS[1]  
-- 使用次数，也就是验证次数  
local cntKey = key..":cnt"  
local val = ARGV[1]  
-- 验证码的有效时间是十分钟，600 秒  
local ttl = tonumber(redis.call("ttl", key))  
  
-- -1 是 key 存在，但是没有过期时间  
if ttl == -1 then  
    -- 有人误操作，导致 key 冲突  
    return -2  
-- -2 是 key 不存在，ttl < 540 是发了一个验证码，已经超过一分钟了，可以重新发送  
elseif ttl == -2 or ttl < 540 then  
    --     后续如果验证码有不同的过期时间，要在这里优化  
    redis.call("set", key, val)  
    redis.call("expire", key, 600)  
    redis.call("set", cntKey, 3)  
    redis.call("expire", cntKey, 600)  
    return 0  
else  
    -- 已经发送了一个验证码，但是还不到一分钟  
    return -1  
end
```

verify_code

```lua
local key = KEYS[1]  
-- 使用次数，也就是验证次数  
local cntKey = key .. ":cnt"  
-- 预期中的验证码  
local expectedCode = ARGV[1]  
  
local cnt = tonumber(redis.call("get", cntKey))  
local code = redis.call("get", key)  
-- 验证次数已经耗尽了  
if cnt <= 0 then  
    return -1  
end  
-- 验证码相等  
-- 不能删除验证码，因为如果你删除了就有可能有人跟你过不去  
-- 立刻再次再次发送验证码  
if code == expectedCode then  
    -- 把次数标记位 -1，认为验证码不可用  
    redis.call("set", cntKey, -1)  
    return 0  
else  
    -- 可能使用户手一抖输错了  
    redis.call("decr", cntKey)  
    return -2  
end
```

通过本地缓存进行实现，如果 redis 崩溃了，可以直接使用本地缓存进行设置

- lru "github.com/hashicorp/golang-lru"

// 技术选型考虑的点  
// 1. 功能性：功能是否能够完全覆盖你的需求。  
// 2. 社区和支持度：社区是否活跃，文档是否齐全，  
// 以及百度（搜索引擎）能不能搜索到你需要的各种信息，有没有帮你踩过坑  
// 3. 非功能性：易用性（用户友好度，学习曲线要平滑），  
// 扩展性（如果开源软件的某些功能需要定制，框架是否支持定制，以及定制的难度高不高）  
// 性能（追求性能的公司，往往有能力自研）

利用 **sms** service 发送生成的验证码

Send 逻辑

生成验证码，存储验证码，利用 sms 服务发送验证码

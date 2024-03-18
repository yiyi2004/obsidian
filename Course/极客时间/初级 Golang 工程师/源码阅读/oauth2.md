- [uber-go/zap: Blazing fast, structured, leveled logging in Go. (github.com)](https://github.com/uber-go/zap)
- [ecodeclub/ekit: 支持泛型的工具库 (github.com)](https://github.com/ecodeclub/ekit)

domain

```go
type WechatInfo struct {  
    // OpenId 是应用内唯一  
    OpenId string  
    // UnionId 是整个公司账号内唯一  
    UnionId string  
}
```

登录流程：

1. 跳转到 wechat 的扫码的页面 oauth2
2. 扫码之后，会有一个 callback 链接
3. 验证 state
4. 验证 code
5. 登录成功
6. 设置 token
7. "https://api.weixin.qq.com/sms/oauth2/access_token"

```go
// 验证 code 流程
func (s *service) VerifyCode(ctx context.Context, code string) (wechat.WechatInfo, error) {  
    const baseURL = "https://api.weixin.qq.com/sms/oauth2/access_token"  
    // 这是另外一种写法  
    queryParams := url.Values{}  
    queryParams.Set("appid", s.appId)  
    queryParams.Set("secret", s.appSecret)  
    queryParams.Set("code", code)  
    queryParams.Set("grant_type", "authorization_code")  
    accessTokenURL := baseURL + "?" + queryParams.Encode()  
    req, err := http.NewRequest("GET", accessTokenURL, nil)  
    if err != nil {  
       return wechat.WechatInfo{}, err  
    }  
    req = req.WithContext(ctx)  
    resp, err := s.client.Do(req)  
    if err != nil {  
       return wechat.WechatInfo{}, err  
    }  
    defer resp.Body.Close()  
    var res Result  
  
    err = json.NewDecoder(resp.Body).Decode(&res)  
    if err != nil {  
       return wechat.WechatInfo{}, err  
    }  
    if res.ErrCode != 0 {  
       return wechat.WechatInfo{}, errors.New("换取 access_token 失败")  
    }  
    return wechat.WechatInfo{  
       OpenId:  res.OpenId,  
       UnionId: res.UnionId,  
    }, nil  
}  
  
func (s *service) AuthURL(ctx context.Context, state string) (string, error) {  
    return fmt.Sprintf(authURLPattern, s.appId, redirectURL, state), nil  
}
```

1. 整体流程
2. 关注的点  

通过 prometheus 包装

```go
// PrometheusDecorator 利用组合来避免需要实现所有的接口  
type PrometheusDecorator struct {  
    Service  
    sum prometheus.Summary  
}  
  
func NewPrometheusDecorator(svc Service,  
    namespace string,  
    subsystem string,  
    instanceId string,  
    name string) *PrometheusDecorator {  
    sum := prometheus.NewSummary(prometheus.SummaryOpts{  
       Name:      name,  
       Namespace: namespace,  
       Subsystem: subsystem,  
       ConstLabels: map[string]string{  
          "instance_id": instanceId,  
       },  
       Objectives: map[float64]float64{  
          0.5:   0.01,  
          0.9:   0.01,  
          0.95:  0.01,  
          0.99:  0.001,  
          0.999: 0.0001,  
       },  
    })  
    prometheus.MustRegister(sum)  
    return &PrometheusDecorator{  
       Service: svc,  
       sum:     sum,  
    }  
}  
  
// VerifyCode 因为 AuthURL 过于简单，没有监控的必要  
func (p *PrometheusDecorator) VerifyCode(ctx context.Context, code string) (wechat.WechatInfo, error) {  
    start := time.Now()  
    defer func() {  
       duration := time.Since(start)  
       p.sum.Observe(float64(duration.Milliseconds()))  
    }()  
    return p.Service.VerifyCode(ctx, code)  
}
```
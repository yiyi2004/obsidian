## Gin 使用回顾

![[Snipaste/Pasted image 20221002093717.png]]  
![[Snipaste/Pasted image 20221002093855.png]]

- 加载模板文件 + 如何传递数据

![[Snipaste/Pasted image 20221002102635.png]]

- 需要在路由上匹配
- * 所有路由都能够匹配，比较危险一些。

![[Snipaste/Pasted image 20221002103019.png]]

- 通过 ?id=123 的形式访问

![[Snipaste/Pasted image 20221002105620.png]]  
![[Snipaste/Pasted image 20221002105535.png]]

- router.Group("/admin")
- 这种方式和写在一起没什么区别，不过还是记录一下

![[Snipaste/Pasted image 20221002105806.png]]

- 控制器的继承，其实很简单的哦 。

Gin 中的中间件必须是一个 gin.HandlerFunc 类型，配置路由的时候可以传递多个 func 回调函数，最后一个 func 回调函数前面触发的方法都可以称为中间件。  
![[Snipaste/Pasted image 20221002110948.png]]

- c.Next() 函数会去执行后面的处理程序，原来 "Middleware" 还会回调
- Abort 是终止的意思， c.Abort() 表示终止调用该请求的剩余处理程序
- r.Use(initMiddleware)
- 全局中间件  
![[Snipaste/Pasted image 20221002111203.png]]  
![[Snipaste/Pasted image 20221002111217.png]]

![[Snipaste/Pasted image 20221002111333.png]]  
![[Snipaste/Pasted image 20221002111342.png]]  
![[Snipaste/Pasted image 20221002111355.png]]

- 中间件和控制器之间共享文件
- key:value 的形式哦

中间件的注意事情：  
![[Snipaste/Pasted image 20221002111551.png]]  
![[Snipaste/Pasted image 20221002111600.png]]

- 中间件的 goroutine 只能使用 gin.Context 的只读副本 c.Copy()

## Basic Knowledge

- gin MaxMultipartMemory 准确的说应该是限制每次处理文件所占用的最大内存，上传后的文件

## Gin Examples

### File-binding

```go
package main

  

import (

    "fmt"

    "mime/multipart"

    "net/http"

    "path/filepath"

  

    "github.com/gin-gonic/gin"

)

  

type BindFile struct {

    Name  string                `form:"name" binding:"required"`

    Email string                `form:"email" binding:"required"`

    File  *multipart.FileHeader `form:"file" binding:"required"`

}

  

func main() {

    router := gin.Default()

    // Set a lower memory limit for multipart forms (default is 32 MiB)

    router.MaxMultipartMemory = 8 << 20 // 8 MiB

    router.Static("/", "./public")

    router.POST("/upload", func(c *gin.Context) {

        var bindFile BindFile

  

        // Bind file

        if err := c.ShouldBind(&bindFile); err != nil {

            c.String(http.StatusBadRequest, fmt.Sprintf("err: %s", err.Error()))

            return

        }

  

        // Save uploaded file

        file := bindFile.File

        dst := filepath.Base(file.Filename)

        if err := c.SaveUploadedFile(file, dst); err != nil {

            c.String(http.StatusBadRequest, fmt.Sprintf("upload file err: %s", err.Error()))

            return

        }

  

        c.String(http.StatusOK, fmt.Sprintf("File %s uploaded successfully with fields name=%s and email=%s.", file.Filename, bindFile.Name, bindFile.Email))

    })

    router.Run(":8080")

}
```

- mime/multipart
- form
- MaxMultipartMemmory
- filepath.base
- ctx.SaveUploaded(file, filename)
- before saving the file, you should handle the filename with filepath.base() to obtaine the correct filepath.

## JWT

- JOSN WEB TOKEN
- Header, Claims 内容, Signature 签名
- 后端校验身份，不需要将这些信息存储到数据库
- 创建一个，解析一个

```go
func main() {
	mySigningKey := []byte("kewu")
	myClain := &MyClaim{
		Username: "zhangsan",
		Password: "123456",
		StandardClaims: jwt.StandardClaims{
			NotBefore: time.Now().Unix() - 60,
			ExpiresAt: time.Now().Unix() + 60*60*2,
			Issuer:    "zhangsan",
		},
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, myClain)
	str, err := token.SignedString(mySigningKey)
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(str)

	token, err = jwt.ParseWithClaims(str, &MyClaim{}, func(token *jwt.Token) (interface{}, error) {
		return mySigningKey, nil
	})
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(token.Claims.(*MyClaim).Username)
}
```

### Jwt Real World

```go
package middleware

import (
	"strconv"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/utils"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/model/system"
	"github.com/flipped-aurora/gin-vue-admin/server/service"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

var jwtService = service.ServiceGroupApp.SystemServiceGroup.JwtService

func JWTAuth() gin.HandlerFunc {
	return func(c *gin.Context) {
		// 我们这里jwt鉴权取头部信息 x-token 登录时回返回token信息 这里前端需要把token存储到cookie或者本地localStorage中 不过需要跟后端协商过期时间 可以约定刷新令牌或者重新登录
		token := c.Request.Header.Get("x-token")
		if token == "" {
			response.FailWithDetailed(gin.H{"reload": true}, "未登录或非法访问", c)
			c.Abort()
			return
		}
		if jwtService.IsBlacklist(token) {
			response.FailWithDetailed(gin.H{"reload": true}, "您的帐户异地登陆或令牌失效", c)
			c.Abort()
			return
		}
		j := utils.NewJWT()
		// parseToken 解析token包含的信息
		claims, err := j.ParseToken(token)
		if err != nil {
			if err == utils.TokenExpired {
				response.FailWithDetailed(gin.H{"reload": true}, "授权已过期", c)
				c.Abort()
				return
			}
			response.FailWithDetailed(gin.H{"reload": true}, err.Error(), c)
			c.Abort()
			return
		}

		// 已登录用户被管理员禁用 需要使该用户的jwt失效 此处比较消耗性能 如果需要 请自行打开
		// 用户被删除的逻辑 需要优化 此处比较消耗性能 如果需要 请自行打开

		//if user, err := userService.FindUserByUuid(claims.UUID.String()); err != nil || user.Enable == 2 {
		//	_ = jwtService.JsonInBlacklist(system.JwtBlacklist{Jwt: token})
		//	response.FailWithDetailed(gin.H{"reload": true}, err.Error(), c)
		//	c.Abort()
		//}
		if claims.ExpiresAt-time.Now().Unix() < claims.BufferTime {
			dr, _ := utils.ParseDuration(global.GVA_CONFIG.JWT.ExpiresTime)
			claims.ExpiresAt = time.Now().Add(dr).Unix()
			newToken, _ := j.CreateTokenByOldToken(token, *claims)
			newClaims, _ := j.ParseToken(newToken)
			c.Header("new-token", newToken)
			c.Header("new-expires-at", strconv.FormatInt(newClaims.ExpiresAt, 10))
			if global.GVA_CONFIG.System.UseMultipoint {
				RedisJwtToken, err := jwtService.GetRedisJWT(newClaims.Username)
				if err != nil {
					global.GVA_LOG.Error("get redis jwt failed", zap.Error(err))
				} else { // 当之前的取成功时才进行拉黑操作
					_ = jwtService.JsonInBlacklist(system.JwtBlacklist{Jwt: RedisJwtToken})
				}
				// 无论如何都要记录当前的活跃状态
				_ = jwtService.SetRedisJWT(newToken, newClaims.Username)
			}
		}
		c.Set("claims", claims)
		c.Next()
	}
}
```

- jwt.ClaimMap
- 解析的时候再 middleware 中进行解密。
- https://github.com/flipped-aurora/gin-vue-admin
- http://doc.henrongyi.top
- [【gin教学】第九章：jwt-go详细教学及使用示例（1010工作室出品）_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV14p4y1x7kF/?spm_id_from=333.788&vd_source=25509bb582bc4a25d86d871d5cdffca3)

## Casbin

- [casbin/casbin: An authorization library that supports access control models like ACL, RBAC, ABAC in Golang (github.com)](https://github.com/casbin/casbin)

访问控制的一个库

### Casbin Real World

## Middleware

- [gin-vue-admin/server/middleware at main · flipped-aurora/gin-vue-admin (github.com)](https://github.com/flipped-aurora/gin-vue-admin/tree/main/server/middleware)

## 跨域访问

- [(141条消息) gin解决跨域问题_.番茄炒蛋的博客-CSDN博客_gin 跨域](https://blog.csdn.net/qq_43135259/article/details/125236412?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166640683916800182193670%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=166640683916800182193670&biz_id=0&spm=1018.2226.3001.4187)

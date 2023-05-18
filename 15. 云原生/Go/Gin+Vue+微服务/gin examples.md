# autotls
```go
func main() {
    r := gin.Default()
    // Ping handler
    r.GET("/ping", func(c *gin.Context) {
        c.String(200, "pong")
    })
    log.Fatal(autotls.Run(r, "example1.com", "example2.com"))
}
```

# Basic Usage
```go
package main

import (
    "net/http"
    "github.com/gin-gonic/gin"
)

var db = make(map[string]string)

func setupRouter() *gin.Engine {

    // Disable Console Color
    // gin.DisableConsoleColor()
    r := gin.Default()
    // Ping test
    r.GET("/ping", func(c *gin.Context) {
        c.String(http.StatusOK, "pong")

    })

  

    // Get user value

    r.GET("/user/:name", func(c *gin.Context) {

        user := c.Params.ByName("name")

        value, ok := db[user]

        if ok {

            c.JSON(http.StatusOK, gin.H{"user": user, "value": value})

        } else {

            c.JSON(http.StatusOK, gin.H{"user": user, "status": "no value"})

        }

    })

  

    // Authorized group (uses gin.BasicAuth() middleware)

    // Same than:

    // authorized := r.Group("/")

    // authorized.Use(gin.BasicAuth(gin.Credentials{

    //    "foo":  "bar",

    //    "manu": "123",

    //}))

    authorized := r.Group("/", gin.BasicAuth(gin.Accounts{

        "foo":  "bar", // user:foo password:bar

        "manu": "123", // user:manu password:123

    }))

  

    /* example curl for /admin with basicauth header

       Zm9vOmJhcg== is base64("foo:bar")

  

        curl -X POST \

        http://localhost:8080/admin \

        -H 'authorization: Basic Zm9vOmJhcg==' \

        -H 'content-type: application/json' \

        -d '{"value":"bar"}'

    */

    authorized.POST("admin", func(c *gin.Context) {

        user := c.MustGet(gin.AuthUserKey).(string)

  

        // Parse JSON

        var json struct {

            Value string `json:"value" binding:"required"`

        }

  

        if c.Bind(&json) == nil {

            db[user] = json.Value

            c.JSON(http.StatusOK, gin.H{"status": "ok"})

        }

    })

  

    return r

}

  

func main() {

    r := setupRouter()

    // Listen and Server in 0.0.0.0:8080

    r.Run(":8080")

}
```

# Cookie
```go
package main

import (
    "net/http"

    "github.com/gin-gonic/gin"
)

func CookieTool() gin.HandlerFunc {
    return func(c *gin.Context) {
        // Get cookie
        if cookie, err := c.Cookie("label"); err == nil {
            if cookie == "ok" {
                c.Next()
                return
            }
        }

        // Cookie verification failed
        c.JSON(http.StatusForbidden, gin.H{"error": "Forbidden with no cookie"})
        c.Abort()
    }
}

  

func main() {
    route := gin.Default()

    route.GET("/login", func(c *gin.Context) {
        // Set cookie {"label": "ok" }, maxAge 30 seconds.
        c.SetCookie("label", "ok", 30, "/", "localhost", false, true)
        c.String(200, "Login success!")
    })

    route.GET("/home", CookieTool(), func(c *gin.Context) {

        c.JSON(200, gin.H{"data": "Your home page"})

    })

	route.Run(":8080")
}
```


# JWT
- middleware/jwt ---> middleware
- utils/jwt ---> generate and parse the jwt token
```go
package jwt

import (
	"net/http"

	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"

	"github.com/EDDYCJY/go-gin-example/pkg/e"
	"github.com/EDDYCJY/go-gin-example/pkg/util"
)

// JWT is jwt middleware
func JWT() gin.HandlerFunc {
	return func(c *gin.Context) {
		var code int
		var data interface{}

		code = e.SUCCESS
		token := c.Query("token")
		if token == "" {
			code = e.INVALID_PARAMS
		} else {
			_, err := util.ParseToken(token)
			if err != nil {
				switch err.(*jwt.ValidationError).Errors {
				case jwt.ValidationErrorExpired:
					code = e.ERROR_AUTH_CHECK_TOKEN_TIMEOUT
				default:
					code = e.ERROR_AUTH_CHECK_TOKEN_FAIL
				}
			}
		}

		if code != e.SUCCESS {
			c.JSON(http.StatusUnauthorized, gin.H{
				"code": code,
				"msg":  e.GetMsg(code),
				"data": data,
			})

			c.Abort()
			return
		}

		c.Next()
	}
}
```

```go
// utils
package util

import (
	"time"

	"github.com/dgrijalva/jwt-go"
)

var jwtSecret []byte

type Claims struct {
	Username string `json:"username"`
	Password string `json:"password"`
	jwt.StandardClaims
}

// GenerateToken generate tokens used for auth
func GenerateToken(username, password string) (string, error) {
	nowTime := time.Now()
	expireTime := nowTime.Add(3 * time.Hour)

	claims := Claims{
		EncodeMD5(username),
		EncodeMD5(password),
		jwt.StandardClaims{
			ExpiresAt: expireTime.Unix(),
			Issuer:    "gin-blog",
		},
	}

	tokenClaims := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	token, err := tokenClaims.SignedString(jwtSecret)

	return token, err
}

// ParseToken parsing token
func ParseToken(token string) (*Claims, error) {
	tokenClaims, err := jwt.ParseWithClaims(token, &Claims{}, func(token *jwt.Token) (interface{}, error) {
		return jwtSecret, nil
	})

	if tokenClaims != nil {
		if claims, ok := tokenClaims.Claims.(*Claims); ok && tokenClaims.Valid {
			return claims, nil
		}
	}

	return nil, err
}

```

# Reference
- [main.go - gin-gonic/examples - GitHub1s](https://github1s.com/gin-gonic/examples/blob/HEAD/basic/main.go#L1-L75)

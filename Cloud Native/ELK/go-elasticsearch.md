# Config
```go
// go.mod
github.com/elastic/go-elasticsearch/v6 6.x
github.com/elastic/go-elasticsearch/v7 7.16

// main.go
import (
  elasticsearch6 "github.com/elastic/go-elasticsearch/v6"
  elasticsearch7 "github.com/elastic/go-elasticsearch/v7"
)
// ...
es6, _ := elasticsearch6.NewDefaultClient()
es7, _ := elasticsearch7.NewDefaultClient()

```

- go mod 的正确操作是什么呢？
- 什么是集群？如何部署呢？集群和分布式是什么意思呢？

`config es

```go
// set the cluster endpoints
cfg := elasticsearch.Config{
  Addresses: []string{
    "http://localhost:9200",
    "http://localhost:9201",
  },
  // ...
}

// set username and passwd
es, err := elasticsearch.NewClient(cfg)

cfg := elasticsearch.Config{
  // ...
  Username: "foo",
  Password: "bar",
}

// certificate
cert, _ := ioutil.ReadFile(*cacert)

cfg := elasticsearch.Config{
  // ...
  CACert: cert,
}
```

- See the [`_examples/configuration.go`](https://github.com/elastic/go-elasticsearch/blob/v7.17.7/_examples/configuration.go) and [`_examples/customization.go`](https://github.com/elastic/go-elasticsearch/blob/v7.17.7/_examples/customization.go) files for more examples of configuration and customization of the client. See the [`_examples/security`](https://github.com/elastic/go-elasticsearch/blob/v7.17.7/_examples/security) for an example of a security configuration.

# Example

## Official
- an example for search index`
```go
// $ go run _examples/main.go

package main

import (
  "bytes"
  "context"
  "encoding/json"
  "log"
  "strconv"
  "strings"
  "sync"
  "bytes"

  "github.com/elastic/go-elasticsearch/v7"
  "github.com/elastic/go-elasticsearch/v7/esapi"
)

func main() {
  log.SetFlags(0)

  var (
    r  map[string]interface{}
    wg sync.WaitGroup
  )

  // Initialize a client with the default settings.
  //
  // An `ELASTICSEARCH_URL` environment variable will be used when exported.
  //
  es, err := elasticsearch.NewDefaultClient()
  if err != nil {
    log.Fatalf("Error creating the client: %s", err)
  }

  // 1. Get cluster info
  //
  res, err := es.Info()
  if err != nil {
    log.Fatalf("Error getting response: %s", err)
  }
  defer res.Body.Close()
  // Check response status
  if res.IsError() {
    log.Fatalf("Error: %s", res.String())
  }
  // Deserialize the response into a map.
  if err := json.NewDecoder(res.Body).Decode(&r); err != nil {
    log.Fatalf("Error parsing the response body: %s", err)
  }
  // Print client and server version numbers.
  log.Printf("Client: %s", elasticsearch.Version)
  log.Printf("Server: %s", r["version"].(map[string]interface{})["number"])
  log.Println(strings.Repeat("~", 37))

  // 2. Index documents concurrently
  //
  for i, title := range []string{"Test One", "Test Two"} {
    wg.Add(1)

    go func(i int, title string) {
      defer wg.Done()

      // Build the request body.      
      data, err := json.Marshal(struct{ Title string }{Title: title})
      if err != nil {
        log.Fatalf("Error marshaling document: %s", err)
      }

      // Set up the request object.
      req := esapi.IndexRequest{
        Index:      "test",
        DocumentID: strconv.Itoa(i + 1),
        Body:       bytes.NewReader(data),
        Refresh:    "true",
      }

      // Perform the request with the client.
      res, err := req.Do(context.Background(), es)
      if err != nil {
        log.Fatalf("Error getting response: %s", err)
      }
      defer res.Body.Close()

      if res.IsError() {
        log.Printf("[%s] Error indexing document ID=%d", res.Status(), i+1)
      } else {
        // Deserialize the response into a map.
        var r map[string]interface{}
        if err := json.NewDecoder(res.Body).Decode(&r); err != nil {
          log.Printf("Error parsing the response body: %s", err)
        } else {
          // Print the response status and indexed document version.
          log.Printf("[%s] %s; version=%d", res.Status(), r["result"], int(r["_version"].(float64)))
        }
      }
    }(i, title)
  }
  wg.Wait()

  log.Println(strings.Repeat("-", 37))

  // 3. Search for the indexed documents
  //
  // Build the request body.
  var buf bytes.Buffer
  query := map[string]interface{}{
    "query": map[string]interface{}{
      "match": map[string]interface{}{
        "title": "test",
      },
    },
  }
  if err := json.NewEncoder(&buf).Encode(query); err != nil {
    log.Fatalf("Error encoding query: %s", err)
  }

  // Perform the search request.
  res, err = es.Search(
    es.Search.WithContext(context.Background()),
    es.Search.WithIndex("test"),
    es.Search.WithBody(&buf),
    es.Search.WithTrackTotalHits(true),
    es.Search.WithPretty(),
  )
  if err != nil {
    log.Fatalf("Error getting response: %s", err)
  }
  defer res.Body.Close()

  if res.IsError() {
    var e map[string]interface{}
    if err := json.NewDecoder(res.Body).Decode(&e); err != nil {
      log.Fatalf("Error parsing the response body: %s", err)
    } else {
      // Print the response status and error information.
      log.Fatalf("[%s] %s: %s",
        res.Status(),
        e["error"].(map[string]interface{})["type"],
        e["error"].(map[string]interface{})["reason"],
      )
    }
  }

  if err := json.NewDecoder(res.Body).Decode(&r); err != nil {
    log.Fatalf("Error parsing the response body: %s", err)
  }
  // Print the response status, number of results, and request duration.
  log.Printf(
    "[%s] %d hits; took: %dms",
    res.Status(),
    int(r["hits"].(map[string]interface{})["total"].(map[string]interface{})["value"].(float64)),
    int(r["took"].(float64)),
  )
  // Print the ID and document source for each hit.
  for _, hit := range r["hits"].(map[string]interface{})["hits"].([]interface{}) {
    log.Printf(" * ID=%s, %s", hit.(map[string]interface{})["_id"], hit.(map[string]interface{})["_source"])
  }

  log.Println(strings.Repeat("=", 37))
}

// Client: 7.0.0-SNAPSHOT
// Server: 7.0.0-SNAPSHOT
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// [201 Created] updated; version=1
// [201 Created] updated; version=1
// -------------------------------------
// [200 OK] 2 hits; took: 5ms
//  * ID=1, map[title:Test One]
//  * ID=2, map[title:Test Two]
// =====================================
```
- 我大概知道怎么操作了，但是为什么接口设计的这么捞。
- 这个库的大概意思其实是让你的操作符合 ES，而不是另一种语言，这和原生 SQL 语言是统一的思想。

# Summary
- 这个库是更加顶层的设计，并没有封装一些操作，但是你可以对它的包再进一步封装，形成自己的工具库——这其实不难，考验的是对 es 的理解。



# Reference
- [elastic/go-elasticsearch: The official Go client for Elasticsearch (github.com)](https://github.com/elastic/go-elasticsearch)
- [elasticsearch package - github.com/elastic/go-elasticsearch/v8 - Go Packages](https://pkg.go.dev/github.com/elastic/go-elasticsearch/v8)

- Time：2023-07-05 09:17
- Label： #go #basic #项目结构

## Abstract

总结几种 Go 的项目结构。

## Content

```txt
myproject/
  |- cmd/
  |   |- main.go
  |
  |- pkg/
  |   |- mypackage/
  |       |- mypackage.go
  |
  |- internal/
  |   |- mymodule/
  |       |- mymodule.go
  |
  |- api/
  |   |- handlers/
  |   |   |- handler1.go
  |   |   |- handler2.go
  |   |
  |   |- middleware/
  |   |- routes/
  |   |- api.go
  |
  |- web/
  |   |- static/
  |   |- templates/
  |
  |- configs/
  |- scripts/
  |- test/
  |
  |- README.md
  |- LICENSE
```

## Reference

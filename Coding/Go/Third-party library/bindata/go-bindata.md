- Time：2023-07-05 17:57
- Label：

## Abstract

捆绑数据我目前了解的方法有两种：

1. go embed
2. go-bindata

> there are two ways to bind data.

通过 go-bindata 是有效的，但是我现在没有耐心了，明天再来做这样复杂的事情叭。

## Content

### Install

```shell
go get -u github.com/go-bindata/go-bindata/...

go install github.com/go-bindata/go-bindata/...
```

### Usage

```shell
go-bindata data/
```

To include all input sub-directories recursively, use the ellipsis postfix as defined for Go import paths. Otherwise it will only consider assets in the input directory **itself**.

```shell
go-bindata data/...
```

To **specify** the name of the output file being generated, we use the following:

```shell
go-bindata -o myfile.go data/
```

**Multiple** input directories can be specified if necessary.

```
go-bindata dir1/... /path/to/dir2/... dir3
```

The following paragraphs detail some of the command line options which can be supplied to `go-bindata`. Refer to the `testdata/out` directory for various output examples from the assets in `testdata/in`. Each example uses different command line options.

To ignore files, pass in regexes using -ignore, for example:

```
go-bindata -ignore=\\.gitignore data/...
```

### Accessing an Asset

To access asset data, we use the **`Asset(string) ([]byte, error)`** function which is included in the generated output.

```go
data, err := Asset("pub/style/foo.css")
if err != nil {
	// Asset was not found.
}

// use asset data
```

### Debug Vs Release Builds

When invoking the program with the `-debug` flag, the generated code does not actually include the asset data. Instead, it generates function stubs which load the data from the original file on disk. The asset API remains identical between debug and release builds, so your code will not have to change.

This is useful during development when you expect the assets to change often. The host application using these assets uses the same API in both cases and will not have to care where the actual data comes from.

An example is a Go webserver with some embedded, static web content like HTML, JS and CSS files. While developing it, you do not want to rebuild the whole server and restart it every time you make a change to a bit of javascript. You just want to build and launch the server once. Then just press refresh in the browser to see those changes. Embedding the assets with the `debug` flag allows you to do just that. When you are finished developing and ready for deployment, just re-invoke `go-bindata` without the `-debug` flag. It will now embed the latest version of the assets.

## Reference

- [go-bindata/go-bindata: Turn data file into go code. (github.com)](https://github.com/go-bindata/go-bindata)
- [What's the best way to bundle static resources in a Go program? - Stack Overflow](https://stackoverflow.com/questions/13904441/whats-the-best-way-to-bundle-static-resources-in-a-go-program)

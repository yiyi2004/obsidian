```shell
go run main.go 0 "C:\Users\zhang\workspace\packvirus\src\test\test2\inception5h" "C:\Users\zhang\workspace\packvirus\src\test\test2\inception5h\\imagenet_comp_graph_label_strings.txt"

go run main.go 0 C:\Users\zhang\workspace\packvirus\src\test\test2\inception5h\tensorflow_inception_graph.pb C:\Users\zhang\workspace\packvirus\src\test\test2\inception5h\imagenet_comp_graph_label_strings.txt opencv cpu

```

1. test your mnist model adn

## Reference

- [Go, OpenCV, Caffe, and Tensorflow: Putting It All Together With GoCV :: GoCV - Golang Computer Vision Using OpenCV 4](https://gocv.io/blog/2018-01-23-go-opencv-tensorflow-caffe/)
- [op package - github.com/tensorflow/tensorflow/tensorflow/go/op - Go Packages](https://pkg.go.dev/github.com/tensorflow/tensorflow@v2.12.0+incompatible/tensorflow/go/op)op 里面有很多操作值得学习，里面包括一些在 python 中 numpy 库提供的函数，padding 和 extend 函数
- [tensorflow/tensorflow: An Open Source Machine Learning Framework for Everyone (github.com)](https://github.com/tensorflow/tensorflow)
- [tensorflow的静态库编译踩坑记 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/91869397)
- [YohayAiTe/go-mtcnn: go-mtcnn is a go package for face detection in images. It uses https://github.com/ipazc/mtcnn as a reference implementation. It is based on the Zhang, K et al. (2016)](https://github.com/YohayAiTe/go-mtcnn/tree/main)

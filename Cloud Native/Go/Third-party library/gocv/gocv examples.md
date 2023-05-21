## basic-drawing

```shell
go run ./cmd/caffe-classifier/main.go 0 ~/Downloads/bvlc_googlenet.caffemodel ~/Downloads/bvlc_googlenet.prototxt ~/Downloads/classification_classes_ILSVRC2012.txt openvino fp16
```

## caffe-classifier 

加载并使用模型 Caffe-classifier 

```go
func main() {
	if len(os.Args) < 5 {
		fmt.Println("How to run:\ncaffe-classifier [camera ID] [modelfile] [configfile] [descriptionsfile] ([backend] [device])")
		return
	}

	// parse args
	deviceID := os.Args[1]
	model := os.Args[2]
	config := os.Args[3]
	descr := os.Args[4]
	descriptions, err := readDescriptions(descr)
	if err != nil {
		fmt.Printf("Error reading descriptions file: %v\n", descr)
		return
	}

	backend := gocv.NetBackendDefault
	if len(os.Args) > 5 {
		backend = gocv.ParseNetBackend(os.Args[5])
	}

	target := gocv.NetTargetCPU
	if len(os.Args) > 6 {
		target = gocv.ParseNetTarget(os.Args[6])
	}

	// open capture device
	webcam, err := gocv.OpenVideoCapture(deviceID)
	if err != nil {
		fmt.Printf("Error opening video capture device: %v\n", deviceID)
		return
	}
	defer webcam.Close()

	window := gocv.NewWindow("Caffe Classifier")
	defer window.Close()

	img := gocv.NewMat()
	defer img.Close()

	// open DNN classifier
	net := gocv.ReadNet(model, config)
	if net.Empty() {
		fmt.Printf("Error reading network model from : %v %v\n", model, config)
		return
	}
	defer net.Close()
	net.SetPreferableBackend(gocv.NetBackendType(backend))
	net.SetPreferableTarget(gocv.NetTargetType(target))

	status := "Ready"
	statusColor := color.RGBA{0, 255, 0, 0}
	fmt.Printf("Start reading device: %v\n", deviceID)

	for {
		if ok := webcam.Read(&img); !ok {
			fmt.Printf("Device closed: %v\n", deviceID)
			return
		}
		if img.Empty() {
			continue
		}

		// convert image Mat to 224x224 blob that the classifier can analyze
		blob := gocv.BlobFromImage(img, 1.0, image.Pt(224, 224), gocv.NewScalar(104, 117, 123, 0), false, false)

		// feed the blob into the classifier
		net.SetInput(blob, "")

		// run a forward pass thru the network
		prob := net.Forward("")

		// reshape the results into a 1x1000 matrix
		probMat := prob.Reshape(1, 1)

		// determine the most probable classification
		_, maxVal, _, maxLoc := gocv.MinMaxLoc(probMat)

		// display classification
		status = fmt.Sprintf("description: %v, maxVal: %v\n", descriptions[maxLoc.X], maxVal)
		gocv.PutText(&img, status, image.Pt(10, 20), gocv.FontHersheyPlain, 1.2, statusColor, 2)

		blob.Close()
		prob.Close()
		probMat.Close()

		window.IMShow(img)
		if window.WaitKey(1) >= 0 {
			break
		}
	}
}

// readDescriptions reads the descriptions from a file
// and returns a slice of its lines.
func readDescriptions(path string) ([]string, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines, scanner.Err()
}
```

## captest and capwindow

摄像头捕获图片

```go
//
// 		go run ./cmd/captest/main.go
//
func main() {
	if len(os.Args) < 2 {
		fmt.Println("How to run:\n\tcaptest [camera ID]")
		return
	}

	// parse args
	deviceID := os.Args[1]

	webcam, err := gocv.OpenVideoCapture(deviceID)
	if err != nil {
		fmt.Printf("Error opening videoacapture device: %v\n", deviceID)
		return
	}
	defer webcam.Close()

	// streaming, capture from webcam
	buf := gocv.NewMat()
	defer buf.Close()

	fmt.Printf("Start reading device: %v\n", deviceID)
	for i := 0; i < 100; i++ {
		if ok := webcam.Read(&buf); !ok {
			fmt.Printf("Device closed: %v\n", deviceID)
			return
		}
		if buf.Empty() {
			continue
		}
        // window.IMShow(img) 显示 windows
		fmt.Printf("Read frame %d\n", i+1)
	}

	fmt.Println("Done.")
}

```

## counter

This example tracks objects such as cars or people passing across a horizontal or vertical line by using the Moments method.The Moments algorithm is not that accurate for counting multiple objects, however it is execution efficient.

```go

//
// 		go run ./counter/main.go /path/to/video.avi 400 y 10
//
func main() {
	if len(os.Args) < 2 {
		fmt.Println("How to run:\n\tcounter [filename] [line] [axis (x/y)] [width]")
		return
	}

	// parse args
	file := os.Args[1]
	line, _ := strconv.Atoi(os.Args[2])
	axis := os.Args[3]
	width, _ := strconv.Atoi(os.Args[4])

	video, err := gocv.VideoCaptureFile(file)
	if err != nil {
		fmt.Printf("Error opening video capture file: %s\n", file)
		return
	}
	defer video.Close()

	window := gocv.NewWindow("Track Window")
	defer window.Close()

	img := gocv.NewMat()
	defer img.Close()

	imgFG := gocv.NewMat()
	defer imgFG.Close()

	imgCleaned := gocv.NewMat()
	defer imgCleaned.Close()

	mog2 := gocv.NewBackgroundSubtractorMOG2()
	defer mog2.Close()

	count := 0
	for {
		if ok := video.Read(&img); !ok {
			fmt.Printf("Device closed: %v\n", file)
			return
		}
		if img.Empty() {
			continue
		}

		// clean frame by removing background & eroding to eliminate artifacts
		mog2.Apply(img, &imgFG)
		kernel := gocv.GetStructuringElement(gocv.MorphRect, image.Pt(3, 3))
		gocv.Erode(imgFG, &imgCleaned, kernel)
		kernel.Close()

		// calculate the image moment based on the cleaned frame
		moments := gocv.Moments(imgCleaned, true)
		area := moments["m00"]
		if area >= 1 {
			x := int(moments["m10"] / area)
			y := int(moments["m01"] / area)

			if axis == "y" {
				if x > 0 && x < img.Cols() && y > line && y < line+width {
					count++
				}
				gocv.Line(&img, image.Pt(0, line), image.Pt(img.Cols(), line), color.RGBA{255, 0, 0, 0}, 2)
			}
			if axis == "x" {
				if y > 0 && y < img.Rows() && x > line && x < line+width {
					count++
				}
				gocv.Line(&img, image.Pt(line, 0), image.Pt(line, img.Rows()), color.RGBA{255, 0, 0, 0}, 2)
			}
		}

		gocv.PutText(&img, fmt.Sprintf("Count: %d", count), image.Pt(10, 20),
			gocv.FontHersheyPlain, 1.2, color.RGBA{0, 255, 0, 0}, 2)

		window.IMShow(img)
		if window.WaitKey(1) >= 0 {
			break
		}
	}
}

```

## cuda

```go
// What it does:
//
// 	This program outputs the current OpenCV library version and CUDA version the console.
//
// How to run:
//
// 		go run --tags cuda ./cmd/cuda/main.go
//
// +build cuda

package main

import (
	"fmt"

	"gocv.io/x/gocv"
	"gocv.io/x/gocv/cuda"
)

func main() {
	fmt.Printf("gocv version: %s\n", gocv.Version())
	fmt.Println("cuda information:")
	devices := cuda.GetCudaEnabledDeviceCount()
	for i := 0; i < devices; i++ {
		fmt.Print("  ")
		cuda.PrintShortCudaDeviceInfo(i)
	}
}
```

## dnn-detection

如果完全利用 `gocv` 加载模型，你就不要考虑静态编译 tensorflow 的问题了，

## dnn-pose-detection

今天已经学的不错了
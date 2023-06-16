- Time：2023-06-16 11:06
- Label： #go #third-repository #audio

## Abstract

- 在 Golang 中播放音频需要使用第三方库。目前最常用的音频库是 PortAudio 和 Beep。
- PortAudio 是跨平台的音频库，它支持许多不同的音频格式和设备。使用 PortAudio 可以非常方便地播放、录制和处理音频数据。

## Content

以下是一个简单的使用 PortAudio 播放音频的例子：

```go
package main

import (
	"fmt"
	"os"

	"github.com/gordonklaus/portaudio"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Println("Usage: play <filename>")
		return
	}

	filename := os.Args[1]

	portaudio.Initialize()
	defer portaudio.Terminate()

	stream, err := portaudio.OpenDefaultStream(0, 1, 44100, len(buffer), func(out []float32) {
		file, err := os.Open(filename)
		if err != nil {
			panic(err)
		}
		defer file.Close()

		buffer := make([]int16, len(out))
		err = binary.Read(file, binary.LittleEndian, &buffer)
		if err != nil {
			panic(err)
		}

		for i, _ := range out {
			out[i] = float32(buffer[i]) / 32768.0
		}
	})
	if err != nil {
		panic(err)
	}
	defer stream.Close()

	err = stream.Start()
	if err != nil {
		panic(err)
	}
	defer stream.Stop()

	fmt.Println("Playing... Press Ctrl-C to stop.")

	err = stream.Wait()
	if err != nil {
		panic(err)
	}
}

```

以上代码中，我们首先检查命令行参数，获取要播放的音频文件名。然后初始化 PortAudio，创建一个默认音频流，指定音频数据的格式和回调函数，回调函数读取音频文件的数据并将其转换为浮点数，然后将其写入输出缓冲区中。最后启动音频流，开始播放音频，并等待直到播放完成。

Beep 是一个简单的音频库，它只支持 Windows 平台。它提供了几个简单的 API 来播放音频。以下是一个使用 Beep 播放音频的例子：

```go
package main

import (
	"fmt"
	"os"
	"time"

	"github.com/faiface/beep"
	"github.com/faiface/beep/mp3"
	"github.com/faiface/beep/speaker"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Println("Usage: play <filename>")
		return
	}

	filename := os.Args[1]

	f, err := os.Open(filename)
	if err != nil {
		panic(err)
	}
	defer f.Close()

	streamer, format, err := mp3.Decode(f)
	if err != nil {
		panic(err)
	}
	defer streamer.Close()

	speaker.Init(format.SampleRate, format.SampleRate.N(time.Second/10))

	done := make(chan bool)
	speaker.Play(beep.Seq(streamer, beep.Callback(func() {
		done <- true
	})))

	fmt.Println("Playing... Press Ctrl-C to stop.")
	<-done
}

```

以上代码中，我们首先检查命令行参数，获取要播放的音频文件名。然后打开文件并将其解码为音频流。我们初始化扬声

## Reference

- [golang 播放音频-掘金 (juejin.cn)](https://juejin.cn/s/golang%20%E6%92%AD%E6%94%BE%E9%9F%B3%E9%A2%91)

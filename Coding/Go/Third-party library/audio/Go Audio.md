- Time：2023-06-16 11:06
- Label： #go #third-repository #audio

## Abstract

- 在 Golang 中播放音频需要使用第三方库。目前最常用的音频库是 PortAudio 和 Beep。
- PortAudio 是跨平台的音频库，它支持许多不同的音频格式和设备。使用 PortAudio 可以非常方便地播放、录制和处理音频数据。

## Content

### PortAudio & Beep

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

### go-audio/audio & go-audio/wav

要在 Golang 中读取并处理 WAV 文件，你可以使用第三方库 `go-audio/wav`。以下是一个基本的示例代码，演示了如何读取 WAV 文件的音频数据：

```go
package main

import (
	"fmt"
	"os"

	"github.com/go-audio/audio"
	"github.com/go-audio/wav"
)

func main() {
	// 打开 WAV 文件
	file, err := os.Open("audio.wav")
	if err != nil {
		fmt.Println("无法打开 WAV 文件:", err)
		return
	}
	defer file.Close()

	// 创建一个 WAV 解码器
	decoder := wav.NewDecoder(file)

	// 确保音频格式是 PCM
	if decoder.SampleFormat != audio.SampleFormatPCM {
		fmt.Println("不支持的音频格式")
		return
	}

	// 读取 WAV 文件的音频数据
	buf, err := decoder.FullPCMBuffer()
	if err != nil {
		fmt.Println("无法读取音频数据:", err)
		return
	}

	// 访问音频数据
	fmt.Println("采样率:", buf.Format.SampleRate)
	fmt.Println("声道数:", buf.Format.NumChannels)
	fmt.Println("采样位深:", buf.Format.BitDepth)
	fmt.Println("采样数:", buf.NumFrames())
	fmt.Println("音频数据:", buf.Data)
}
```

上述代码使用 `go-audio/wav` 库打开 WAV 文件并创建一个解码器对象。然后，通过解码器的 `FullPCMBuffer` 方法读取完整的音频数据。最后，你可以访问音频数据的各种属性，例如采样率、声道数、采样位深等，并对音频数据进行处理。

请确保在运行代码之前，你已经安装了 `go-audio/wav` 库，可以使用以下命令进行安装：

```
go get github.com/go-audio/audio
go get github.com/go-audio/wav
```

此外，你还需要准备一个名为 "audio.wav" 的 WAV 文件，将其放在代码所在的目录下，以便示例代码能够正确读取该文件的音频数据。

## Reference

- [golang 播放音频-掘金 (juejin.cn)](https://juejin.cn/s/golang%20%E6%92%AD%E6%94%BE%E9%9F%B3%E9%A2%91)
- [go-audio (github.com)](https://github.com/go-audio)

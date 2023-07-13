- Time：2023-07-13 09:54
- Label：

## Abstract

## Content

```go
package main

import (
	"fmt"
	"os"
	"os/signal"

	"github.com/go-audio/audio"
	"github.com/hajimehoshi/oto"
)

func main() {
	// 创建音频文件
	file, err := os.Create("output.wav")
	if err != nil {
		fmt.Println("无法创建文件:", err)
		return
	}
	defer file.Close()

	// 创建音频编码器
	enc := wav.NewEncoder(file, 44100, 16, 1, 1)

	// 创建音频播放器
	player, err := oto.NewPlayer(44100, 2, 2, 8192)
	if err != nil {
		fmt.Println("无法创建音频播放器:", err)
		return
	}
	defer player.Close()

	// 创建信号监听器以捕获中断信号
	sig := make(chan os.Signal, 1)
	signal.Notify(sig, os.Interrupt)

	// 读取麦克风的音频数据并写入文件
	fmt.Println("开始录制音频，请按 Ctrl+C 停止录制")
	for {
		select {
		case <-sig:
			// 接收到中断信号时停止录制
			fmt.Println("停止录制")
			return
		default:
			// 从音频播放器读取音频数据
			buf := make([]byte, 8192)
			player.Read(buf)

			// 写入音频数据到文件
			data := &audio.IntBuffer{
				Format: &audio.Format{
					SampleRate:  44100,
					NumChannels: 2,
				},
				Data: buf,
			}
			if err := enc.Write(data); err != nil {
				fmt.Println("无法写入音频数据到文件:", err)
				return
			}
		}
	}
}
```

## Reference

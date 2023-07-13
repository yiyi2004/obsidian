- Time：2023-07-13 09:02
- Label：

## Abstract

## Content

```go
//package main  
//  
//import (  
// "fmt"  
// "io"  
// "log"  
// "os"  
// "path"  
// "runtime"  
// "syscall"  
// "time"  
// "unsafe"  
//  
// wav "github.com/youpy/go-wav"  
//)  
//  
//var (  
// winmm = syscall.MustLoadDLL("winmm.dll")  
// mciSendString = winmm.MustFindProc("mciSendStringW")  
//)  
//  
//func MCIWorker(lpstrCommand string, lpstrReturnString string, uReturnLength int, hwndCallback int) uintptr {  
// i, _, _ := mciSendString.Call(uintptr(unsafe.Pointer(syscall.StringToUTF16Ptr(lpstrCommand))),  
// uintptr(unsafe.Pointer(syscall.StringToUTF16Ptr(lpstrReturnString))),  
// uintptr(uReturnLength), uintptr(hwndCallback))  
// return i  
//}  
//  
//func Record(duration time.Duration) {  
// fmt.Println("winmm.dll Record Audio to .wav file")  
//  
// i := MCIWorker("open new type waveaudio alias capture", "", 0, 0)  
// if i != 0 {  
// log.Fatal("Error Code A: ", i)  
// }  
//  
// i = MCIWorker("record capture", "", 0, 0)  
// if i != 0 {  
// log.Fatal("Error Code B: ", i)  
// }  
//  
// fmt.Println("Listening...")  
//  
// time.Sleep(duration)  
//  
// i = MCIWorker("save capture mic.wav", "", 0, 0)  
// if i != 0 {  
// log.Fatal("Error Code C: ", i)  
// }  
//  
// i = MCIWorker("close capture", "", 0, 0)  
// if i != 0 {  
// log.Fatal("Error Code D: ", i)  
// }  
//  
// fmt.Println("Audio saved to mic.wav")  
//}  
//  
//func main() {  
// file, err := fixtureFile("temp.wav")  
// if err != nil {  
// log.Println("Failed to open fixture file", err)  
// return  
// }  
//  
// all, _ := io.ReadAll(file)  
// fmt.Println(all[0:4])  
//  
// reader := wav.NewReader(file)  
//  
// samples, err := reader.ReadSamples(2)  
// if err != nil {  
// log.Println(err)  
// }  
// format, _ := reader.Format()  
//  
// // print the format info  
// fmt.Println(format.BlockAlign)  
// fmt.Println(format.NumChannels)  
// fmt.Println(format.BitsPerSample)  
// fmt.Println(format.AudioFormat)  
// fmt.Println(format.SampleRate)  
// fmt.Println(format.ByteRate)  
//  
// fmt.Println(samples)  
// floatVal1 := reader.FloatValue(samples[0], 0)  
// floatVal2 := reader.FloatValue(samples[1], 0)  
// fmt.Println("Float Value:", floatVal1)  
// fmt.Println("Float Value:", floatVal2)  
// fmt.Println("samples[0]", samples[0])  
// fmt.Println("samples[0]", samples[1])  
//}  
//  
//func fixture(basename string) string {  
// _, filename, _, _ := runtime.Caller(1)  
//  
// return path.Join(path.Dir(filename), "", basename)  
//}  
//  
//func fixtureFile(basename string) (file *os.File, err error) {  
// file, err = os.Open(fixture(basename))  
//  
// return  
//}  
//  
//package main  
//  
///*  
// #include <stdio.h>  
// #include <unistd.h>  
// #include <termios.h>  
// char getch(){  
// char ch = 0;  
// struct termios old = {0};  
// fflush(stdout);  
// if( tcgetattr(0, &old) < 0 ) perror("tcsetattr()");  
// old.c_lflag &= ~ICANON;  
// old.c_lflag &= ~ECHO;  
// old.c_cc[VMIN] = 1;  
// old.c_cc[VTIME] = 0;  
// if( tcsetattr(0, TCSANOW, &old) < 0 ) perror("tcsetattr ICANON");  
// if( read(0, &ch,1) < 0 ) perror("read()");  
// old.c_lflag |= ICANON;  
// old.c_lflag |= ECHO;  
// if(tcsetattr(0, TCSADRAIN, &old) < 0) perror("tcsetattr ~ICANON");  
// return ch;  
// }  
//*/  
//import "C"  
//  
//// stackoverflow.com/questions/14094190/golang-function-similar-to-getchar  
//  
//import (  
// "fmt"  
// "github.com/gordonklaus/portaudio"  
// wave "github.com/zenwerk/go-wave"  
// "math/rand"  
// "os"  
// "strings"  
// "time"  
//)  
//  
//func errCheck(err error) {  
//  
// if err != nil {  
// panic(err)  
// }  
//}  
//  
//func main() {  
//  
// if len(os.Args) != 2 {  
// fmt.Printf("Usage : %s <audiofilename.wav>\n", os.Args[0])  
// os.Exit(0)  
// }  
//  
// audioFileName := os.Args[1]  
//  
// fmt.Println("Recording. Press ESC to quit.")  
//  
// if !strings.HasSuffix(audioFileName, ".wav") {  
// audioFileName += ".wav"  
// }  
// waveFile, err := os.Create(audioFileName)  
// errCheck(err)  
//  
// // www.people.csail.mit.edu/hubert/pyaudio/ - under the Record tab  
// inputChannels := 1  
// outputChannels := 0  
// sampleRate := 16000  
// framesPerBuffer := make([]byte, 32)  
//  
// // init PortAudio  
//  
// portaudio.Initialize()  
// //defer portaudio.Terminate()  
//  
// stream, err := portaudio.OpenDefaultStream(inputChannels, outputChannels, float64(sampleRate), len(framesPerBuffer), framesPerBuffer)  
// errCheck(err)  
// //defer stream.Close()  
//  
// // setup Wave file writer  
//  
// param := wave.WriterParam{  
// Out: waveFile,  
// Channel: inputChannels,  
// SampleRate: sampleRate,  
// BitsPerSample: 8, // if 16, change to WriteSample16()  
// }  
//  
// waveWriter, err := wave.NewWriter(param)  
// errCheck(err)  
//  
// //defer waveWriter.Close()  
//  
// go func() {  
// key := C.getch()  
// fmt.Println()  
// fmt.Println("Cleaning up ...")  
// if key == 27 {  
// // better to control  
// // how we close then relying on defer  
// waveWriter.Close()  
// stream.Close()  
// portaudio.Terminate()  
// fmt.Println("Play", audioFileName, "with a audio player to hear the result.")  
// os.Exit(0)  
//  
// }  
//  
// }()  
//  
// // recording in progress ticker. From good old DOS days.  
// ticker := []string{  
// "-",  
// "\\",  
// "/",  
// "|",  
// }  
// rand.Seed(time.Now().UnixNano())  
//  
// // start reading from microphone  
// errCheck(stream.Start())  
// for {  
// errCheck(stream.Read())  
//  
// fmt.Printf("\rRecording is live now. Say something to your microphone! [%v]", ticker[rand.Intn(len(ticker)-1)])  
//  
// // write to wave file  
// _, err := waveWriter.Write([]byte(framesPerBuffer)) // WriteSample16 for 16 bits  
// errCheck(err)  
// }  
// errCheck(stream.Stop())  
//}
```

## Reference

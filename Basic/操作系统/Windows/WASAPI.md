- Time：2023-06-08 11:00
- Label：

## Abstract

- Windows 音频 API

## Content

Windows 音频会话 API (WASAPI) 使客户端应用程序能够管理应用程序和 [音频终结点设备之间的音频](https://learn.microsoft.com/zh-cn/windows/win32/coreaudio/audio-endpoint-devices) 数据流。

头文件 Audioclient.h 和 Audiopolicy.h 定义 WASAPI 接口。

每个音频流都是 [音频会话](https://learn.microsoft.com/zh-cn/windows/win32/coreaudio/audio-sessions) 的成员。 通过会话抽象，WASAPI 客户端可以将音频流标识为一组相关音频流的成员。 系统可以将会话中的所有流作为单个单元进行管理。

音频引擎是 [用户模式音频组件](https://learn.microsoft.com/zh-cn/windows/win32/coreaudio/user-mode-audio-components) ，应用程序通过该组件共享对音频终结点设备的访问。 音频引擎在终结点缓冲区和终结点设备之间传输音频数据。 若要通过呈现终结点设备播放音频流，应用程序会定期将音频数据写入呈现终结点缓冲区。 音频引擎混合来自各种应用程序的流。 若要从捕获终结点设备录制音频流，应用程序会定期从捕获终结点缓冲区读取音频数据。

WASAPI 由多个接口组成。 其中第一个是 [**IAudioClient**](https://learn.microsoft.com/zh-cn/windows/desktop/api/Audioclient/nn-audioclient-iaudioclient) 接口。 若要访问 WASAPI 接口，客户端首先通过调用 [**IMMDevice：：Activate**](https://learn.microsoft.com/zh-cn/windows/desktop/api/Mmdeviceapi/nf-mmdeviceapi-immdevice-activate) 方法（参数 _iid_ 设置为 **REFIID** IID_IAudioClient）来获取对音频终结点设备的 **IAudioClient** 接口的引用。 客户端调用 [**IAudioClient：：Initialize**](https://learn.microsoft.com/zh-cn/windows/desktop/api/Audioclient/nf-audioclient-iaudioclient-initialize) 方法来初始化终结点设备上的流。 初始化流后，客户端可以通过调用 [**IAudioClient：：GetService**](https://learn.microsoft.com/zh-cn/windows/desktop/api/Audioclient/nf-audioclient-iaudioclient-getservice) 方法获取对其他 WASAPI 接口的引用。

如果客户端应用程序使用的音频终结点设备无效，WASAPI 中的许多方法将返回错误代码 AUDCLNT_E_DEVICE_INVALIDATED。 应用程序通常可以从此错误中恢复。 有关详细信息，请参阅 [从Invalid-Device错误中恢复](https://learn.microsoft.com/zh-cn/windows/win32/coreaudio/recovering-from-an-invalid-device-error)。

## Reference

- [关于 WASAPI - Win32 apps | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/win32/coreaudio/wasapi)

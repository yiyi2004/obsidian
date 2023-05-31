[ChatGPT&WeChat](https://github.com/zhayujie/chatgpt-on-wechat)  
[海外短信](https://sms-activate.org/getNumber)  
https://arxiv.org/abs/2301.02074

- 中英文转换

```
I want you to act as an Chinese translator, spelling corrector and improver. I will speak to you in any language and you will detect the language, translate it and answer in the corrected and improved version of my text, in Chinese . I want you to replace my simplified A0-level words and sentences with more beautiful and elegant, upper level Chinese words and sentences. Keep the meaning same, but make them more literary. I want you to only reply the correction, the improvements and nothing else, do not write explanations. My first sentence is "istanbulu cok seviyom burada olmak cok guzel"
```

Visual ChatGPT  
https://github.com/microsoft/visual-chatgpt  
Visual ChatGPT connects ChatGPT and a series of Visual Foundation Models to enable sending and receiving images during chatting.  
See our paper: [Visual ChatGPT: Talking, Drawing and Editing with Visual Foundation Models](https://arxiv.org/abs/2303.04671)

- 隐私模式
- [futurepedia](https://www.futurepedia.io/)
- tome generative storytelling has arrived
- introducing notion ai
- merlin
- playground
- example
- [openai-tencent-proxy](https://github.com/Ice-Hazymoon/openai-scf-proxy)
- [腾讯云函数平台](https://console.cloud.tencent.com/scf/list)

```js
const express = require('express')
const {
  createProxyMiddleware
} = require('http-proxy-middleware');
const app = express()
const port = 9000
app.use('/', createProxyMiddleware({
  target: 'https://api.openai.com',
  changeOrigin: true,
  onProxyRes: function (proxyRes, req, res) {
    proxyRes.headers['Access-Control-Allow-Origin'] = '*';
  }
}));
app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})
```

- 可以去了解一下云函数，很不错的工具捏。

# Get
```java
/**
     * <p>Description: get方式请求接口
     * @param url            请求路径
     * @param UrlParams        url参数
     * @param HeadParams    http头参数
     */
	public static String sendJsonGet(String url, Map<String, String> UrlParams, Map<String, String> HeadParams) {
        String result = "";
        BufferedReader in = null;
        try {
            // 拼接参数,可以用URIBuilder,也可以直接拼接在?传值，拼**在url后面
             URIBuilder uriBuilder = new URIBuilder(url);
            if (null != UrlParams && !UrlParams.isEmpty()) {
                for (Map.Entry<String, String> entry : UrlParams.entrySet()) {
                    uriBuilder.addParameter(entry.getKey(), entry.getValue());
                }
            }
            URL realUrl = uriBuilder.build().toURL();
            // 打开和URL之间的连接
            URLConnection connection = realUrl.openConnection();
            // 获取请求头Map
            SapUtils http = new SapUtils();
            http.initailizeHeadMap();
            if (null != HeadParams && !HeadParams.isEmpty()) {
                http.headMap.putAll(HeadParams);
            }
            // 设置通用的请求属性
            connection.setRequestProperty("Content-type", "application/json; charset=UTF-8");
            for (Map.Entry<String, String> entry : (http.headMap).entrySet()) {
                connection.setRequestProperty(entry.getKey(), entry.getValue());
            }
            // 建立实际的连接
            connection.connect();
            // 定义 BufferedReader输入流来读取URL的响应
            in = new BufferedReader(new InputStreamReader(
                    connection.getInputStream(),"UTF-8"));
            String line;
            while ((line = in.readLine()) != null) {
                result += line;
            }
        } catch (Exception e) {
            log.error("发送GET请求出现异常！\r\n" + e);
            result = e.toString();
        }
        // 使用finally块来关闭输入流
        finally {
            try {
                if (in != null) {
                    in.close();
                }
            } catch (Exception e2) {
                log.error(e2);
            }
        }
        return result;
    }

    /**
     * 初始化http请求头
     */
    public void initailizeHeadMap() {
        headMap = new HashMap<String, String>();
        headMap.put("accept", "*/*");
        headMap.put("connection", "Keep-Alive");
        headMap.put("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
    }
}
```



# Reference
- [(90条消息) Java操作Elasticsearch的所有方法_水漾月的博客-CSDN博客_java操作elasticsearch](https://blog.csdn.net/weixin_39363116/article/details/123005394?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166838242216800182172511%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166838242216800182172511&biz_id=0&spm=1018.2226.3001.4187)
- [(90条消息) JAVA发送GET、POST请求，携带请求头，接收解析返回值(通过URL)_HezhezhiyuLe的博客-CSDN博客_java发送get请求](https://blog.csdn.net/HezhezhiyuLe/article/details/92395041)
- [Gson](https://github.com/google/gson)
- [Java 执行系统命令_51CTO博客_java执行linux命令](https://blog.51cto.com/u_5048284/3690638)

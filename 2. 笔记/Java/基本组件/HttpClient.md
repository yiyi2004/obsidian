# Simple Request
```java
HttpClient client = HttpClient.newHttpClient();

HttpRequest request = HttpRequest.newBuilder()
  .GET()
  .uri(new URI("https://postman-echo.com/get"))
  .build();

HttpResponse<String> response = client.send(request, BodyHandlers.ofString());

logger.info("Status {}", response.statusCode());
```

- get token
```java
    String command = "curl -u wazuh:zsnXilqESc1bAYDRD23dqB+*dM?oaIOZ -k -X GET \"https://192.168.184.128:55000/security/user/authenticate?raw=true\"";  
  
    Process p = Runtime.getRuntime().exec(command);  
  
    InputStream is = p.getInputStream();  
    BufferedReader reader = new BufferedReader(new InputStreamReader(is));  
    p.waitFor();  
    if (p.exitValue() != 0) {  
        //说明命令执行失败  
        //可以进入到错误处理步骤中  
    }  
  
    String s = null;  
    while ((s = reader.readLine()) != null) {  
        System.out.println(s);  
    }}
```

```shell
keytool -import -file 'C:\Users\zhang\Documents\GitHub\cert\wazuh-dashboard.crt' -storepass changeit '-keystore C:\Program Files\Java\jdk-17.0.5\jre\lib\security\cacerts' -alias mycert1
```


```java
package cn.isch.util;  
  
import java.io.BufferedReader;  
import java.io.IOException;  
import java.io.InputStream;  
import java.io.InputStreamReader;  
import java.net.Authenticator;  
import java.net.PasswordAuthentication;  
import java.net.URI;  
import java.net.URISyntaxException;  
import java.net.http.HttpClient;  
import java.net.http.HttpRequest;  
import java.net.http.HttpResponse;  
import java.util.Base64;  
  
public class Token {  
    private static final String getBasicAuthenticationHeader(String username, String password) {  
        String valueToEncode = username + ":" + password;  
        return "Basic " + Base64.getEncoder().encodeToString(valueToEncode.getBytes());  
    }  
    public static void main(String[] args) throws IOException, InterruptedException, URISyntaxException {  
        HttpClient client = HttpClient.newBuilder().authenticator(new Authenticator() {  
            @Override  
            protected PasswordAuthentication getPasswordAuthentication() {  
                return new PasswordAuthentication("wazuh", "22.y5v7WighQS9dhcrbpkuyYwCH2Fm+R".toCharArray());  
            }        }).build();  
  
  
        HttpRequest request = HttpRequest.newBuilder()  
                .GET()  
                .uri(new URI("https://192.168.184.128:9200/wazuh-alerts-4.x-*/_search"))  
                .build();  
  
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());  
  
        System.out.println(response.statusCode());  
  
  
//        String command = "curl -u wazuh:zsnXilqESc1bAYDRD23dqB+*dM?oaIOZ -k -X GET \"https://192.168.184.128:55000/security/user/authenticate?raw=true\"";  
//  
//        Process p = Runtime.getRuntime().exec(command);  
//  
//        InputStream is = p.getInputStream();  
//        BufferedReader reader = new BufferedReader(new InputStreamReader(is));  
//        p.waitFor();  
//        if (p.exitValue() != 0) {  
//            //说明命令执行失败  
//            //可以进入到错误处理步骤中  
//        }  
//  
//        String s = null;  
//        while ((s = reader.readLine()) != null) {  
//            System.out.println(s);  
//        }  
    }  
}
```


- set ssl
```java
package cn.isch.util;  
  
import java.security.cert.CertificateException;  
import java.security.cert.X509Certificate;  
import java.util.Base64;  
import javax.net.ssl.SSLContext;  
import javax.net.ssl.TrustManager;  
import javax.net.ssl.X509TrustManager;  
import org.apache.http.HttpResponse;  
import org.apache.http.client.HttpClient;  
import org.apache.http.client.methods.HttpGet;  
import org.apache.http.impl.client.CloseableHttpClient;  
import org.apache.http.impl.client.HttpClientBuilder;  
import org.apache.http.util.EntityUtils;  
  
/**  
 * @author shifengqiang 2022/3/15 6:03 PM  
 */public class Token {  
    private static SSLContext ctx;  
    static {  
        try {  
            ctx = SSLContext.getInstance("TLS");  
            X509TrustManager tm = new X509TrustManager() {  
                public X509Certificate[] getAcceptedIssuers() {  
                    return null;  
                }  
                public void checkClientTrusted(X509Certificate[] arg0,  
                                               String arg1) throws CertificateException {  
                }  
                public void checkServerTrusted(X509Certificate[] arg0,  
                                               String arg1) throws CertificateException {  
                }            };            ctx.init(null, new TrustManager[] { tm }, null);  
        } catch (Exception e) {  
            System.out.println(e);  
        }    }  
    private static String getBasicAuthenticationHeader(String username, String password) {  
        String valueToEncode = username + ":" + password;  
        return "Basic " + Base64.getEncoder().encodeToString(valueToEncode.getBytes());  
    }  
    public static void main(String[] args) {  
        // 在这儿加了 setSSLContext(ctx)        CloseableHttpClient httpClient = HttpClientBuilder.create().setSSLContext(ctx).build();  
        try {  
            String url = "https://usersystem-new.testd.huitong.com/ruok";  
            HttpGet get = new HttpGet(url);  
  
            HttpResponse response = httpClient.execute(get);  
            String result = EntityUtils.toString(response.getEntity(), "utf-8");  
            System.out.println(result);  
        } catch (Exception e) {  
            e.printStackTrace();  
  
        }  
    }}
```
```java
```
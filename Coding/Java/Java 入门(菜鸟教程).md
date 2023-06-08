- [Java 卸载](https://blog.csdn.net/m0_56022510/article/details/120180358?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166273042316800180691520%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166273042316800180691520&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-120180358-null-null.142^v47^pc_rank_34_default_23,201^v3^control_1&utm_term=%E5%8D%B8%E8%BD%BD%20java&spm=1018.2226.3001.4187)

## Java 基础语法

```java
public class HelloWorld{
	public static void main(String[] args){
		System.out.println("Hello World!");
	}
}
```

- 源文#件名必须与类名一致
- 数组是存储在堆上的对象 (**堆和栈的区别，分配云云**)

```java
class FreshJuice { 
	enum FreshJuiceSize{ SMALL, MEDIUM , LARGE } 
	FreshJuiceSize size; 
}

public class FreshJuiceTest { 
	public static void main(String[] args){ 
		FreshJuice juice = new FreshJuice(); 
		juice.size = FreshJuice.FreshJuiceSize.MEDIUM; 
	} 
}
```

需要注意的关键字

1. abstract
2. extends
3. final
4. implements
5. interface
6. **native**
7. new
8. **strictfp**
9. **synchronized**
10. **transient**
11. volatile
12. instanceof
13. assert
14. catch
15. finally
16. throw：抛出一个异常对象
17. throws：声明一个异常可能被抛出
18. try
19. byte
20. long
21. short
22. super
23. const 是关键字但是不能使用
- null 不是关键字，与 true 和 false 类似，是一个字面常量。

![[Snipaste/Pasted image 20220909202702.png]]

- 字节码程序？
- 可能涉及到 Java 虚拟机的问题。
- 一个源文件只能有一个 public 类，多个非 public 类
- **Package 的问题，如果一个类定义在某一个包里，那么 package 应该在源文件的首行。**
- 包主要用来对类和接口进行分类
- byte 类型用在大型数组中节约空间，主要代替整数，因为 byte 变量占用的空间只有 int 类型的四分之一。
- char 类型是一个单一的 16 位 Unicode 字符；
- String 的默认值是 null
- 对象、数组都是引用类型
- 所有引用类型的默认值都是 null
- 常量不能修改，用 final 修饰

```java
	final double PI = 3.14;
```

- 前缀 0 表示 8 进制，而前缀 0x 代表 16 进制

```java
	int decimal = 100;
	int octal = 0144;
	int hexa =  0x64;
```

- Unicode

```java
	char a = '\u0001';
	String a = "\u0001";
```

- 不能对 boolean 类型进行类型转换。
- 强制类型转换

```java
	byte b = (byte)i1;//强制类型转换为byte
```

- 局部变量分配在栈上
- **局部变量没有默认值，所以要初始化！**
- Java 修饰符
	- 访问修饰符
	- 非访问修饰符
- 访问修饰符  
![[Snipaste/Pasted image 20220910221530.png]]

- 访问控制和继承
	- father public. child public
	- father protected, child public or protected
	- father private, child die
- 非访问类修饰符
	- static
	- final
		- class 不能继承
		- method 不能被继承类重写
		- var ---> const
	- abstract：创建抽象类和抽象方法
	- synchronized、volatile：用于线程的变成
- 局部变量不能被 static 修饰
- 静态方法不能使用类的非静态变量
- static + final
- final 方法可以被继承，但是不能被重写
- 抽象类可以包含抽象方法和非抽象方法  
![[Snipaste/Pasted image 20220910223129.png]]
 - synchronized 关键字声明的方法同一时间只能被一个线程访问。synchronized 修饰符可以应用于四个访问修饰符 (public, private, protected, default)。
 - **transient**#
 - volatile 修饰的成员变量在每次被线程访问时，都强制从共享内存中重新读取该成员变量的值。而且，当成员变量发生变化时，会强制线程将变化值回写到共享内存。这样在任何时刻，两个不同的线程总是看到某个成员变量的同一个值。一个 volatile 对象引用可能是 null。

```java
public class MyRunnable implements Runnable{
	private volatile boolean active;
	public void run() { 
		active = true; 
		while (active){
			// code
		}// 第一行 
		 
		public void stop() { active = false;} // 第二行
}
```

- 通常情况下，在一个线程调用 run() 方法（在 Runnable 开启的线程），在另一个线程调用 stop() 方法。 如果第一行中缓冲区的 active 值被使用，那么在第二行的 active 值为 false 时循环不会停止。但是以上代码中我们使用了 volatile 修饰 active，所以该循环会停止。

![[Snipaste/Pasted image 20220910230546.png]]

- ?

```java
public class Test { 
	public static void main(String[] args){ 
		int a , b; a = 10; // 如果 a 等于 1 成立，则设置 b 为 20，否则为 30 
		b = (a == 1) ? 20 : 30; 
		System.out.println( "Value of b is : " + b ); 
		// 如果 a 等于 10 成立，则设置 b 为 20，否则为 30 
		b = (a == 10) ? 20 : 30; 
		System.out.println( "Value of b is : " + b ); 
	}
}
```

- instanceof

```java
	String name = "James";
	boolean result = name instanceof String; 
	// 由于 name 是 String 类型，所以返回真
```

- 增强 for 循环

```java
public class Test {
   public static void main(String[] args){
      int [] numbers = {10, 20, 30, 40, 50};
 
      for(int x : numbers ){
         System.out.print( x );
         System.out.print(",");
      }
      System.out.print("\n");
      String [] names ={"James", "Larry", "Tom", "Lacy"};
      for( String name : names ) {
         System.out.print( name );
         System.out.print(",");
      }
   }
}
```

- switch case break
- 如果 case 语句块中没有 break 语句时，匹配成功后，从当前 case 开始，后续所有 case 的值都会输出。

## Java Number & Math

- Boolean
- Byte
- Short
- Integer
- Long
- Character
- Float
- Double

![[Snipaste/Pasted image 20220911183807.png]]

- Number 属于 java.lang 包
- **装箱的概念**：应该不影响我编程
- floor, round, ceil
- [Number方法](https://www.runoob.com/java/java-number.html)

## Java Character

- 用于对单个字符进行操作
- [Character 方法](https://www.runoob.com/java/java-character.html)

## Java String

- String 创建的字符串存储在公共池中，而 new 创建的字符串对象在堆上：

```java
String s1 = "Runoob";              // String 直接创建
String s2 = "Runoob";              // String 直接创建
String s3 = s1;                    // 相同引用
String s4 = new String("Runoob");   // String 对象创建
String s5 = new String("Runoob");   // String 对象创建
```

![[Snipaste/Pasted image 20220911190037.png]]

- 一旦创建了 String 对象，那它的值就无法改变了
- 连接字符串 (两种 方法)

```java
str1.concat(str2);
"1".concal("str2");
"1" + "2" + "3";
```

- 格式化字符串
	- System.out.printf(); 占用符
	- String.format()
- [String 方法](https://www.runoob.com/java/java-string.html)

## Java String Buffer & String Builder

- 当你需要对字符串进行修改的额时候会用到 String Buffer 类。
- 不产生新的未使用对象  
![[Snipaste/Pasted image 20220911192814.png]]
- StringBuilder 不是线程安全的，但是有速度优势，推荐使用。

```java
public class RunoobTest{
    public static void main(String args[]){
        StringBuilder sb = new StringBuilder(10);
        sb.append("Runoob..");
        System.out.println(sb);  
        sb.append("!");
        System.out.println(sb); 
        sb.insert(8, "Java");
        System.out.println(sb); 
        sb.delete(5,8);
        System.out.println(sb);  
    }
}
```

![[Snipaste/Pasted image 20220911193046.png]]

- **如果要求是线程安全的，那么要求使用 StringBuffer。**
- [StringBuffer 方法](https://www.runoob.com/java/java-stringbuffer.html)

## Java 数组

```java
datatype[] array;
```

- 创建数据

```java
arrayRefVar = new dataType[arraySize];
```

- 上面语句干了两件事
	- 使用 datatype[arraySize] 创建了一个数组。
	- 把新创建的数组引用赋值给 arrayRefVar。
- 处理数组

```java
public class TestArray {
   public static void main(String[] args) {
      double[] myList = {1.9, 2.9, 3.4, 3.5};
 
      // 打印所有数组元素
      for (int i = 0; i < myList.length; i++) {
         System.out.println(myList[i] + " ");
      }
      // 计算所有元素的总和
      double total = 0;
      for (int i = 0; i < myList.length; i++) {
         total += myList[i];
      }
      System.out.println("Total is " + total);
      // 查找最大元素
      double max = myList[0];
      for (int i = 1; i < myList.length; i++) {
         if (myList[i] > max) max = myList[i];
      }
      System.out.println("Max is " + max);
   }
}
```

- for…each

```java
public class TestArray {
   public static void main(String[] args) {
      double[] myList = {1.9, 2.9, 3.4, 3.5};
 
      // 打印所有数组元素
      for (double element: myList) {
         System.out.println(element);
      }
   }
}
```

- 数组可以作为函数的参数或返回值
- 多维数组

```java
String[][] s = new String[2][];
s[0] = new String[2];
s[1] = new String[3];
s[0][0] = new String("Good");
s[0][1] = new String("Luck");
s[1][0] = new String("to");
s[1][1] = new String("you");
s[1][2] = new String("!");
```

### Arrays 类

- java.utils.Arrays 是为了方便对数据操作的，它的所有方法否是惊
1. binarySearch
2. equals
3. fill
4. sort

## Java 日期时间

- [Java 日期时间](https://www.runoob.com/java/java-date-time.html>)

## Java 正则表达式

- [Java 正则表达式](https://www.runoob.com/java/java-regular-expressions.html)

## Java 方法

![[Snipaste/Pasted image 20220911202546.png]]

- 重载：一个类有两个相同的函数名，但是函数有不同的参数列表
- 方法重载可以使代码更加清晰易读
- 命令行参数的使用

```java
public class CommandLine {
   public static void main(String[] args){ 
      for(int i=0; i<args.length; i++){
         System.out.println("args[" + i + "]: " + args[i]);
      }
   }
}
```

```shell
$ javac CommandLine.java 
$ java CommandLine this is a command line 200 -100
args[0]: this
args[1]: is
args[2]: a
args[3]: command
args[4]: line
args[5]: 200
args[6]: -100
```

- 可变参数

```java
public class VarargsDemo {
    public static void main(String[] args) {
        // 调用可变参数的方法
        printMax(34, 3, 3, 2, 56.5);
        printMax(new double[]{1, 2, 3});
    }
 
    public static void printMax( double... numbers) {
        if (numbers.length == 0) {
            System.out.println("No argument passed");
            return;
        }
 
        double result = numbers[0];
 
        for (int i = 1; i <  numbers.length; i++){
            if (numbers[i] >  result) {
                result = numbers[i];
            }
        }
        System.out.println("The max value is " + result);
    }
}
```

- finalize() 手动进行垃圾回收

```java
protected void finalize()
{
   // 在这里终结代码
}
```

- protected 确保该方法不会被类以外的代码调用

## Java Stream、File、IO

- 控制台输入由 System.in 实现

```java
BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
```

- 得到对象后用 read() 方法读取一个字符，用 readLine() 读取一行。

```java
//使用 BufferedReader 在控制台读取字符
 
import java.io.*;
 
public class BRRead {
    public static void main(String[] args) throws IOException {
        char c;
        // 使用 System.in 创建 BufferedReader
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        System.out.println("输入字符, 按下 'q' 键退出。");
        // 读取字符
        do {
            c = (char) br.read();
            System.out.println(c);
        } while (c != 'q');
    }
}
```

- Java5 之后我们使用 Scanner 读取输入
- 从控制台输出
- 读写数据  
![[Snipaste/Pasted image 20220912190157.png]]
- FileInputStream

```java
FileInputStream f = new FileInputStream("C:/Java");
```

![[Snipaste/Pasted image 20220912190726.png]]

- ByteArrayInputStream
- DataInputStream
- FileOutputStream

```java
OutputStream f = new FileOutputStream("C:/java/hello")
```

```java
File f = new File("C:/java/hello"); OutputStream fOut = new FileOutputStream(f);
```

![[Snipaste/Pasted image 20220912191309.png]]

- [ByteArrayOutputStream](https://www.runoob.com/java/java-bytearrayoutputstream.html)
- [DataOutputStream](https://www.runoob.com/java/java-dataoutputstream.html)

```JAVA
import java.io.*;
 
public class fileStreamTest {
    public static void main(String[] args) {
        try {
            byte bWrite[] = { 11, 21, 3, 40, 5 };
            OutputStream os = new FileOutputStream("test.txt");
            for (int x = 0; x < bWrite.length; x++) {
                os.write(bWrite[x]); // writes the bytes
            }
            os.close();
 
            InputStream is = new FileInputStream("test.txt");
            int size = is.available();
 
            for (int i = 0; i < size; i++) {
                System.out.print((char) is.read() + "  ");
            }
            is.close();
        } catch (IOException e) {
            System.out.print("Exception");
        }
    }
}
```

- **这段代码写的不错哦**

```java
//文件名 :fileStreamTest2.java
import java.io.*;
 
public class fileStreamTest2 {
    public static void main(String[] args) throws IOException {
 
        File f = new File("a.txt");
        FileOutputStream fop = new FileOutputStream(f);
        // 构建FileOutputStream对象,文件不存在会自动新建
 
        OutputStreamWriter writer = new OutputStreamWriter(fop, "UTF-8");
        // 构建OutputStreamWriter对象,参数可以指定编码,默认为操作系统默认编码,windows上是gbk
 
        writer.append("中文输入");
        // 写入到缓冲区
 
        writer.append("\r\n");
        // 换行
 
        writer.append("English");
        // 刷新缓存冲,写入到文件,如果下面已经没有写入的内容了,直接close也会写入
 
        writer.close();
        // 关闭写入流,同时会把缓冲区内容写入文件,所以上面的注释掉
 
        fop.close();
        // 关闭输出流,释放系统资源
 
        FileInputStream fip = new FileInputStream(f);
        // 构建FileInputStream对象
 
        InputStreamReader reader = new InputStreamReader(fip, "UTF-8");
        // 构建InputStreamReader对象,编码与写入相同
 
        StringBuffer sb = new StringBuffer();
        while (reader.ready()) {
            sb.append((char) reader.read());
            // 转成char加到StringBuffer对象中
        }
        System.out.println(sb.toString());
        reader.close();
        // 关闭读取流
 
        fip.close();
        // 关闭输入流,释放系统资源
 
    }
}
```

- 上面的代码也不错哦
- 文件和 IO
	- [File Class](https://www.runoob.com/java/java-file.html)
	- FileReader Class
	- FileWriter Class
- 创建目录

```java
import java.io.File;
 
public class CreateDir {
    public static void main(String[] args) {
        String dirname = "/tmp/user/java/bin";
        File d = new File(dirname);
        // 现在创建目录
        d.mkdirs();
    }
}
```

- 查看目录

```java
import java.io.File;
 
public class DirList {
    public static void main(String args[]) {
        String dirname = "/tmp";
        File f1 = new File(dirname);
        if (f1.isDirectory()) {
            System.out.println("目录 " + dirname);
            String s[] = f1.list();
            for (int i = 0; i < s.length; i++) {
                File f = new File(dirname + "/" + s[i]);
                if (f.isDirectory()) {
                    System.out.println(s[i] + " 是一个目录");
                } else {
                    System.out.println(s[i] + " 是一个文件");
                }
            }
        } else {
            System.out.println(dirname + " 不是一个目录");
        }
    }
}
```

- 递归删除目录及文件

```java
import java.io.File;
 
public class DeleteFileDemo {
    public static void main(String[] args) {
        // 这里修改为自己的测试目录
        File folder = new File("/tmp/java/");
        deleteFolder(folder);
    }
 
    // 删除文件及目录
    public static void deleteFolder(File folder) {
        File[] files = folder.listFiles();
        if (files != null) {
            for (File f : files) {
                if (f.isDirectory()) {
                    deleteFolder(f);
                } else {
                    f.delete();
                }
            }
        }
        folder.delete();
    }
}
```

## Java Scanner 类

```java
import java.util.Scanner;
 
public class ScannerDemo {
    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        // 从键盘接收数据
 
        // nextLine方式接收字符串
        System.out.println("nextLine方式接收：");
        // 判断是否还有输入
        if (scan.hasNextLine()) {
            String str2 = scan.nextLine();
            System.out.println("输入的数据为：" + str2);
        }
        scan.close();
    }
}
```

- **next 和 nextLine 的区别**
- 我认为在读取文件的时候可能会有所区别。  
![[Snipaste/Pasted image 20220912194537.png]]

- hasNextXxx

```java
import java.util.Scanner;
 
public class ScannerDemo {
    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        // 从键盘接收数据
        int i = 0;
        float f = 0.0f;
        System.out.print("输入整数：");
        if (scan.hasNextInt()) {
            // 判断输入的是否是整数
            i = scan.nextInt();
            // 接收整数
            System.out.println("整数数据：" + i);
        } else {
            // 输入错误的信息
            System.out.println("输入的不是整数！");
        }
        System.out.print("输入小数：");
        if (scan.hasNextFloat()) {
            // 判断输入的是否是小数
            f = scan.nextFloat();
            // 接收小数
            System.out.println("小数数据：" + f);
        } else {
            // 输入错误的信息
            System.out.println("输入的不是小数！");
        }
        scan.close();
    }
}
```

## 异常处理

- [异常处理在做羡慕的时候很有用，但是现在还用不到.jpg](https://www.runoob.com/java/java-exceptions.html)

## 重写和重载

![[Snipaste/Pasted image 20220912195604.png]]

## 问题解决

- Java18 汉字乱码那就换成 Java17

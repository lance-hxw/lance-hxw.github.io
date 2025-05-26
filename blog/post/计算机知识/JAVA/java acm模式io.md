# 使用juScanner输入
```java
Scanner scanner = new Scanner(System.in);

scanner.nextInt(); # 读一个整数
scanner.next(); # 读取一个单词, 按空格分割
scanner.nextLine(); # 读取一行字符串

scanner.close();
```
## 多组输入
```java
while(scanner.hasNextInt()){
	int num = scanner.nextInt();
	...
}
scanner.close();
```
# 使用Sout进行输出
```java
System.out.print("xxx"); # 不换行
System.out.println("xxx"); # 换行
System.out.printf("%d, %s",num, str); # 格式化
```

是一种特殊的类，用于定义一组固定的常量, 继承自Enum类
如：
```java
public enum Season {
	SPRING, SUMMER, AUTUMN, WINTER
}
```
可以带属性：
```java
public enum Color {
    RED(255, 0, 0),
    GREEN(0, 255, 0),
    BLUE(0, 0, 255);

    private final int r;
    private final int g;
    private final int b;

    Color(int r, int g, int b) {
        this.r = r;
        this.g = g;
        this.b = b;
    }

    public int getR() { return r; }
    public int getG() { return g; }
    public int getB() { return b; }
}
```
注意：
- 如果常量有内部属性， 就应该用带构造器的Enum
	- Enum构造器天生是private
- 可以在switch中使用，具有编译时类型检查
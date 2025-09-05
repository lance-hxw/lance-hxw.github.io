最重要的底层优化是使用了System.arraycopy这个本地方法， 用于在数组中批量复制元素

`System.arraycopy()` 为 Java 中的 ArrayList 带来了几个重要的性能优化：

## 1. 原生内存操作

`System.arraycopy()` 是一个原生方法（native method），直接调用底层 C/C++ 代码进行内存块复制，避免了 Java 层面的循环操作开销。这比手动的元素逐一复制快得多。

## 2. ArrayList 扩容优化

当 ArrayList 需要扩容时，会创建一个更大的数组，然后使用 `System.arraycopy()` 将原数组中的所有元素一次性复制到新数组中。这个操作的时间复杂度是 O(n)，但常数因子很小，比逐个元素复制效率高很多。

## 3. 元素移动优化

在 ArrayList 的以下操作中，`System.arraycopy()` 提供了显著的性能提升：

**插入操作**：当在中间位置插入元素时，需要将插入点后的所有元素向右移动一位。使用 `System.arraycopy()` 可以批量移动这些元素。

**删除操作**：删除中间位置的元素后，需要将后续元素向左移动填补空隙，同样通过批量复制实现。

## 4. 具体性能优势

- **减少方法调用开销**：避免了大量的数组访问和赋值操作
    
- **更好的内存局部性**：连续的内存复制对 CPU 缓存友好
    
- **JVM 优化**：现代 JVM 对 `System.arraycopy()` 有特殊优化，可能使用 SIMD 指令或其他硬件加速
    

## 5. 实际应用场景

```java
// ArrayList 扩容时的内部实现（简化版）
private void grow(int minCapacity) {
    int newCapacity = calculateNewCapacity(minCapacity);
    Object[] newArray = new Object[newCapacity];
    // 使用 System.arraycopy 批量复制
    System.arraycopy(elementData, 0, newArray, 0, size);
    elementData = newArray;
}
```

总的来说，`System.arraycopy()` 让 ArrayList 在处理大量数据时保持了相对较好的性能，特别是在扩容、插入和删除操作中，避免了性能瓶颈。
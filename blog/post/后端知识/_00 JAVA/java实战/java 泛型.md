# TypeReference
是Jackson的一个类，用于反序列化的时候应对泛型的类型擦除，告知反序列化器实际的类型
如：
```java
List<String> fruitList = objectMapper.readValue(json, new TypeReference<List<String>>(){});
```
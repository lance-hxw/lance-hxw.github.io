就是要用对象来表示关系, 从而用面向对象语言来操作关系型数据库, 即object/relational mapping
会进行这样的映射:
- 表(table)->class
- 记录(record)->对象
- 字段(field)-> 对象的属性
优点:
- 把数据库操作也写代码里了, 更方便维护和重用
- 有现成框架, 可以进行更多更方便的逻辑操作, 比如数据清洗和预处理
- 你必须使用mvc框架编写程序
- 减少sql
缺点:
- 不轻量化, 框架要学习
- 查询复杂后, 性能不好, 甚至不能表达(不够完备)
- 太抽象, 无法接触底层
## 规范
orm库种类繁多, 公认的规范是 Ruby的ActiveRecord规范, 有如下限制
- 一个类对应一个表, 类名单数首字母大写, 表名复数小写, Book->books
- 如果名字复数不规则, 类名按英语习惯, Person->people
- 名字是复合词, 类名用大驼峰, 表名用下划线, BookClub->book_clubs
- 每个表有一个主键, 一般是id,  外键字段约定为单数表名+下划线+id, 如item_id, 意思是items表的id字段
## 有哪些ORM框架, 
- Hibemate 最流行
- MyBatis 易用
- Spring Data JPA :spring框架提供
- SQLAlchemy
- Django ORM: python
## jdbc和多种orm的对比

|JDBC|Hibernate|JPA|MyBatis|
|---|---|---|---|
|DataSource|SessionFactory|EntityManagerFactory|SqlSessionFactory|
|Connection|Session|EntityManager|SqlSession|

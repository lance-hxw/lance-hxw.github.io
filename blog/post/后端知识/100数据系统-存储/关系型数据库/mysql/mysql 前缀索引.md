```SQL

CREATE INDEX idx_name ON table_name(column_name(length))
```

就会为字段的前n个字符创建索引

主要作用
- 显著减少全文索引的开销
- 针对特殊场景， 如url存储， 设置良好的前缀能明显提升效率

主要问题
- 不能排序
- 不能分组
- 无法覆盖查询， 所以会回表

## 范围查询和模式匹配如何应用前缀索引
```sql
-- 假设有前缀索引：CREATE INDEX idx_email ON users (email(10));

对于范围查询
-- ✅ 有效：前缀范围查询
SELECT * FROM users WHERE email >= 'abc' AND email < 'abd';

-- ✅ 有效：字典序范围查询
SELECT * FROM users WHERE email BETWEEN 'john@gmail' AND 'john@gmail z';

对于模式匹配
-- ✅ 最佳：前缀匹配
SELECT * FROM users WHERE email LIKE 'john@gmail%';

-- ✅ 有效：固定前缀 + 通配符
SELECT * FROM users WHERE email LIKE 'admin@company.%';

-- ✅ 部分有效：前缀在索引长度内
CREATE INDEX idx_url ON pages (url(20));
SELECT * FROM pages WHERE url LIKE 'https://example.com%';

-- 无效：
- 对前缀索引尝试用前缀模糊匹配
- 对前缀索引尝试匹配后缀
  
```

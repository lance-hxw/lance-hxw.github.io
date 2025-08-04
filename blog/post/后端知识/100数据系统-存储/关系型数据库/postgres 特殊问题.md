## 修改一个带默认值的列的类型
需要先去掉默认属性, 再改, 再加上
```sql
ALTER TABLE public.address_book ALTER COLUMN is_default DROP DEFAULT;
ALTER TABLE public.address_book ALTER COLUMN is_default TYPE INT USING is_default::int;
ALTER TABLE public.address_book ALTER COLUMN is_default SET DEFAULT 1;
```
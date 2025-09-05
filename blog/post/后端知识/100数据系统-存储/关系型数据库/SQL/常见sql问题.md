# 工资高于部门平均的员工

## 子查询
```SQL
select *
from employee as e
where salary > (
	select avg(salary)
	from employee
	where dep = e.dep
)
```

## 窗口函数（推荐）
```sql
select * , avg_salary
from (
	select * , avg(salary) over (partition by depart_id) as avg_salary from employees
) t
where salary > avg_salary
```
- 只扫表一次， 性能好， 不过有的老版本不支持
## join + group

```sql
select *
from employee e
join (
	select dep_id,  avg(salary) as avg_salary
	from employees
	group by dep_id
) dep_avg  on e.dep_id = dep_avg.dep_id
where e.salary > dep_avg.avg_salary;
```

# 每门课成绩最好的学生

```sql

select stu, sub, score
from (
	select stu, sub, score, RANK() OVER (
		PARTITION BY sub
		ORDER BY score desc
	) as rank
) t 
where rank = 1


select stu, sub, score
from scores a
where score = (
	select max(score)
	from scores b
	where a.sub = b.sub
)
这个嵌套性能很差


select a.stu, a.sub, a.score
from scores a
JOIN (
	select sub, MAX(socre) as highest
	from scores
	group by sub
) b
ON a.sub = b.sub AND a.score = b.highest

```
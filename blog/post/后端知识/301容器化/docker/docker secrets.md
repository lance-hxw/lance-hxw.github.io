用于存储key等敏感信息, 用于在docker swarm集群中安全存储和传递敏感信息
特点: 
- 加密
- 在集群中使用
- 访问控制: 只有授权的服务才可以访问指定的secrets, 也只会被容器内进程读取
- 自动轮换: 更新被自动推送
## 使用
docker secret create  name xxx
如:
```bash
echo "passwaord" | docker secret create my_secret -
```
从stdin 读取
然后在compose中
```yaml
services:
	db:
		secrets:
			- db_pwd

secrets:
	dp_pwd:
		external: true

```
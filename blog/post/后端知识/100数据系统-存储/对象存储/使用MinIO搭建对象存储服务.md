## 部署
首先pull minio/minio
然后运行
```bash
docker run -p 9000:9000 -p 9001:9001 -v volumn_name:/data minio/minio:latest server /data --console_address ":9001"
```
管理员账户是: minioadmin:minioadmin
## 使用
### 创建一个桶 
对象存储服务用桶来管理
- Versioning: 版本控制, 可以在同一个密钥下保存一个对象的多个版本
- Obj. Locking: 对象锁
- Quota: 限定容量

### 文件操作
在网页端随便操作但没啥用, minio支持S3 SDK, 可以直接用S3的API访问

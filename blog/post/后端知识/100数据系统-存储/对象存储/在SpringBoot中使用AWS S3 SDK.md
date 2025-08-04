我们会使用S3的SDK链接自己的minio服务, 并在Spring中建立一个MinioService
## 1. maven导入依赖
```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>com.amazonaws</groupId>
        <artifactId>aws-java-sdk-s3</artifactId>
        <version>1.12.261</version>
    </dependency>
</dependencies>
```
## 2. 在spring配置文件中写配置, 并使用配置类导入
```application.yml
spring:
  application:
    name: minio-demo

minio:
  endpoint: http://localhost:9000
  accessKey: minioadmin
  secretKey: minioadmin
  bucket: my-bucket
```

```java
@Configuration
public class MinioConfig {
    
    @Value("${minio.endpoint}")
    private String endpoint;
    
    @Value("${minio.accessKey}")
    private String accessKey;
    
    @Value("${minio.secretKey}")
    private String secretKey;
	/**  
	 * * 一个credentials, 创建一个client, 进行一定配置
	 * 
	 */
    @Bean // 需要提供一个S3 client
    public AmazonS3 amazonS3Client() {
        AWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);
        
        ClientConfiguration clientConfig = new ClientConfiguration();
        clientConfig.setSignerOverride("AWSS3V4SignerType");
        // 这个是为了兼容什么的
        return AmazonS3ClientBuilder.standard()
                .withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration(endpoint, Regions.US_EAST_1.getName()))
                .withPathStyleAccessEnabled(true)
                .withClientConfiguration(clientConfig)
                .withCredentials(new AWSStaticCredentialsProvider(credentials))
                .build();
    }
}
```

## 3. 编写相关服务的一个例子
```java
@Service  
@Slf4j  
public class MinioService {  
  
    @Value("${minio.bucket}")  
    private String bucketName;  
  
    @Autowired  
    private AmazonS3 amazonS3Client;  
  
    // 上传文件  
    public String uploadFile(MultipartFile file) throws IOException {  
        String fileName = UUID.randomUUID() + "_" + file.getOriginalFilename();  
          
        ObjectMetadata metadata = new ObjectMetadata();  
        metadata.setContentType(file.getContentType());  
        metadata.setContentLength(file.getSize());  
  
        amazonS3Client.putObject(bucketName, fileName, file.getInputStream(), metadata);  
          
        return fileName;  
    }  
  
    // 下载文件  
    public ResponseEntity<byte[]> downloadFile(String fileName) {  
        S3Object s3Object = amazonS3Client.getObject(bucketName, fileName);  
        S3ObjectInputStream inputStream = s3Object.getObjectContent();  
          
        try {  
            byte[] content = IOUtils.toByteArray(inputStream);  
            HttpHeaders headers = new HttpHeaders();  
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);  
            headers.setContentDisposition(ContentDisposition.attachment().filename(fileName).build());  
              
            return new ResponseEntity<>(content, headers, HttpStatus.OK);  
        } catch (IOException e) {  
            log.error("Error downloading file", e);  
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);  
        }  
    }  
  
    // 删除文件  
    public void deleteFile(String fileName) {  
        amazonS3Client.deleteObject(bucketName, fileName);  
    }  
  
    // 列出所有文件  
    public List<String> listFiles() {  
        ObjectListing objectListing = amazonS3Client.listObjects(bucketName);  
        return objectListing.getObjectSummaries().stream()  
                .map(S3ObjectSummary::getKey)  
                .collect(Collectors.toList());  
    }  
}
```

## 4. 相关设置

### Spring中设置MultpartFile的大小限制
```yaml
spring:
  servlet:
    multipart:
      max-file-size: 10MB
      max-request-size: 50MB

```
## 5. 常用API

### 处理bucket
- ListBuckets , 列出账户下所有桶
- CreateBucket, 创建一个桶
- DeleteBucket, 删除
### Object操作
- PutObject
- GetObject
- ListObjectsV2
...
### 权限和策略设置
...
### 生命周期和版本控制
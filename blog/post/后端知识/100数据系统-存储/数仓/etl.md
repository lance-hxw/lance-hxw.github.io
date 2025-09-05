extract， transform， load

即从其他数据系统抓取数据，清洗转换后， 写入数仓的处理流程

# 实时ETL的实现方式
## 基于mq/流处理平台

- 用kafka等作为数据总线
- flink， spark等作为实时流计算
- sink到数仓/数据湖（snowflake，iceberg。。。
## 基于cdc+流处理
- 用debezium， canal， goldengate等捕获变化
- 推送到流处理
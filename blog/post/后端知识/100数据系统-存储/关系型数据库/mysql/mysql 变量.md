在 MySQL 中，变量是用于存储配置参数和系统状态信息的值。通过查看变量，你可以了解到 MySQL 服务器当前的各种设置和运行状态，以便进行性能调优、故障排查等操作
可以用show variables显示系统变量和当前值
## innodb_file_per_table
使用show variables like 'innodb_file_per_table'可以查看innodb
是否为每个表建立单独的文件

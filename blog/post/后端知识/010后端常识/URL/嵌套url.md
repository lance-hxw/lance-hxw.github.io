如果需要拼接一个url
如xxx.com/abc?url=xx:/xxx.com/xxx?xxx=a&xx=b
此时需要对后面那个url做一个url.QueryEscape, 不然&参数会被解析到外层url上
然后生成的url就是:
- xxx. com/abc?url=xx%xA%2Fxxx%3.....%3Db, 让url是一个完整的值
需要的地方拿到url参数自己解析

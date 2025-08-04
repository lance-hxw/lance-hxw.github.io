MQTT是一种基于TCP的轻量级发布订阅协议

常用的有MQTT over ws, 也就是使用ws传递mqtt协议包, 之所以要这么做, 是因为mqtt是基于tcp的, 如果是和浏览器等client通讯(也就是c/b), 需要基于http通讯, 此时就无法使用更底层的tcp了. 所以可以基于http升级到ws, 然后在ws中双向通讯


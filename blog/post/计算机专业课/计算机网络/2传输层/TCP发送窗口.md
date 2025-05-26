在流量控制中，有一个接受窗口rwnd
自然就有逻辑上的swnd发送窗口，约等与rwnd
引入拥塞控制后，有cwnd
此时发送窗口就有：
swnd = min（cwnd，rwnd）
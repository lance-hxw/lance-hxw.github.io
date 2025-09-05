相当于  微服务的tcp/ip
# 服务间通讯方式演变

## 理想 版本
直接 a 到 b的连接， 隐藏所有细节

## 朴素实现

服务端业务逻辑+流量控制， 然后直接通过网络协议栈进行通讯

## 基于TCP

TCP控制流量， 所以变成业务逻辑+tcp/ip

## 初代微服务

应用中有通讯相关逻辑， 如负载均衡， 鉴权， 服务发现等

通讯基于tcp/ip协议栈

## 第二代微服务


随着微服务发展， 应用中， 非业务逻辑直接使用相关组件就行

## 初代service mesh
为了解决微服务的问题：
- 开发人员还是要关注相关组件的复杂度
- 开发框架/组件不是完全语言无关的
- 依赖复杂， 升级等变动牵扯很多

于是有了linkerd， envoy， nginxMesh等代理模式（sidecar）出现了

直接将相关的组件抽象到单独的一个sidecar中去， 作为单独一层， 从而与应用解耦

此时就形成了服务网格， 每个节点都有一个自己的sidecar， 用于与外界通讯， 原本应用的服务网格变成了sidecar的网格， 每个节点有不同的应用层逻辑

## 第二代Service Mesh

使用一个Istio等集中控制面板与单机的sidecar交互

至此， Service Mesh相当于定制化地嵌套在tcpip层上， 将更多公共逻辑组合进传输层。

# Ref.
[Pattern: Service Mesh](https://philcalcado.com/2017/08/03/pattern_service_mesh.html)

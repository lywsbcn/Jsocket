# Jsocket

[![CI Status](https://img.shields.io/travis/lywsbcn/Jsocket.svg?style=flat)](https://travis-ci.org/lywsbcn/Jsocket)
[![Version](https://img.shields.io/cocoapods/v/Jsocket.svg?style=flat)](https://cocoapods.org/pods/Jsocket)
[![License](https://img.shields.io/cocoapods/l/Jsocket.svg?style=flat)](https://cocoapods.org/pods/Jsocket)
[![Platform](https://img.shields.io/cocoapods/p/Jsocket.svg?style=flat)](https://cocoapods.org/pods/Jsocket)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Jsocket is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Jsocket'
```
## Use
```ruby
Jsocket * socket =[[Jsocket alloc]init];
OR

Jsocket * socket= [Jsocket instant].wsUrl=@"ws://1270.0.0.1:99";
设置webSocket 标识
socket.log.TAG = @"游戏服务器";
socket.open();

监听 连接打开
socket.event.ConnectAor(id target, ^(Jsocket *jscoket) {

});

发送并且回调
socket.send(self, req, ^(id response, NSInteger flag, NSString *msg, Jsocket *jscoket) {

});

添加监听回调
socket.event.ListenerAor(id action, id target, ^(id response, NSInteger flag, NSString *msg, Jsocket *jscoket) {

}, BOOL always);

移除监听回调
socket.event.remove(id target);
```

## Author

lywsbcn, 89324055@qq.com

## License

Jsocket is available under the MIT license. See the LICENSE file for more info.

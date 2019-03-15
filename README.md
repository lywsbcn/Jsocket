# Jsocket

[![CI Status](https://img.shields.io/travis/lywsbcn/Jsocket.svg?style=flat)](https://travis-ci.org/lywsbcn/Jsocket)
[![Version](https://img.shields.io/cocoapods/v/Jsocket.svg?style=flat)](https://cocoapods.org/pods/Jsocket)
[![License](https://img.shields.io/cocoapods/l/Jsocket.svg?style=flat)](https://cocoapods.org/pods/Jsocket)
[![Platform](https://img.shields.io/cocoapods/p/Jsocket.svg?style=flat)](https://cocoapods.org/pods/Jsocket)

## 安装
Jsocket 可以通过 CocoaPods 获得。要安装它，只需将以下一行添加到您的 Podfile
```
pod 'Jsocket'
```

#### 手动安装

把 `Jsocket/Jsocket/Classes/` 目录下的所有文件 拖入项目中

然后 `TARGETS -> Linked Frameworks and Libraries` 中添加 `libicucore.tbd`


## 使用
```
单例模式 - 如果我们的项目只有一个 websocket 连接时
Jsocket * socket = [Jsocket instant];
```
或者
```
实例化多个 - 当我们的项目需要连接多个不同的 websocket 服务器时
Jsocket * socket = [[Jsocket alloc]init];
```
设置
```
设置 websocket 连接地址
socket.wsUrl = @"ws://127.0.0.1:99";


设置 websocket 连接标识（当多个连接时，打印的 log 前会加上这个标识，以便区分是哪个连接的消息）
socket.log.TAG = @"游戏服务器"；


打开 websocket 连接(必须首先设置 连接地址)；
socket.open();


连接打开回调
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
范例

```objective-c

- (void)viewDidLoad {
    [super viewDidLoad];

    [Jsocket instant].wsUrl = @"ws://127.0.0.1:99";
    [Jsocket instant].log.TAG = @"游戏服务器"；
    [Jsocket instant].open();

    连接打开，握手或者登录
    [Jsocket instant].event.ConnectAor(self, ^(Jsocket *jscoket) {

		NSDictionary * loginReq = @{
			   @"action":@10001,
			   @"username":@"demo001",
			   @"password":@"123231"
			  };

		发送登录请求
		[Jsocket instant].send(self,loginReq,^(id response, NSInteger flag, NSString *msg, Jsocket *jscoket) {
			if(flag == 1){
				NSLog(@"登录成功")！
			}else{
				NSLog(@"登录失败")！
            }
        })；

    });
}

-(void)dealloc{
    [Jsocket instant].event.remove(self);
    NSLog(@"%@ 释放了~~~",[self class]);
}

```

## 更多说明

#### KEY 设置

在我们的系统中，是根据 `action` 跟服务端约定是什么请求
比如:
```
发送 {"action"："10000"}
回复 {"action": "10000" ,"flag":1 , "msg":"ok"}

发送 {"action"："10001"}
回复 {"action": "10001" ,"flag":2 , "msg":"错误"}
```
key 名称不一样怎么办？
```
发送 {"method"："10000"}
设置请求 action key 名称
socket.event.Raction = @"method";


回复 {"method": "10000" ,"code":1 , "message":"ok"}
设置回复 action key 名称
socket.event.Kaction = @"method";

socket.event.Kflag = @"code";

socket.event.Kmsg = @"message";
```



#### Log
```
用于区分 websocket 的标识
socket.log.TAG = @"";

是否打印日志log， 默认 YES
socket.log.showLog = YES;
```

#### 心跳
```
设置心跳 间隔时间
socket.hbInterval = 10;

设置心跳发送的数据
（注意：设置完就会开始定时发送心跳数据了。如果连接断开后，会自动停止心跳，需要重新设置 hbPacket）
//一般是在登录成功后，开始发送心跳的
socket.hbPacket = ^id{
        return @{
			@"action":@(500)
		};
    };
```

#### 重连

```
是否重连,默认为YES
socket.conn.isReConn = YES;

重连模式
socket.conn.pattern = JsocketConnPatternNormarl;

/*重连模式*/
typedef NS_ENUM(NSInteger,JsocketConnPattern) {
    JsocketConnPatternNormarl, //正常模式,每隔固定时长 重连一次
    JsocketConnPatternLoop     //倍数模式,每次重连的时间是上次重连时间 *2
};

重连次数,当重连次数超过该值是,不再连接.
无限重连 设置值为 0, 默认为0
socket.conn.number= 0;

重连间隔时间（秒）当pattern =JsocketConnPatternLoop 时, 
时间从 intervalMin ->intervalMax->intervalMin 循环
socket.conn.interval = 10;

重连间隔时间从intervalMin 开始
socket.conn.intervalMin = 2;

重连间隔时间大于intervalMax 时,下一次从intervalMin开始
socket.conn.intervalMax = 60;
```

#### 连接成功 回调
```
如果，websocket 已经连接，添加这个回调时，会马上调用一次
socket.event.ConnectAor(self, ^(Jsocket *jscoket) {
});

如果 block 为 nil 时，表示移除回调。实际上等于调用下面的移除
socket.event.ConnectAor(self,nil);

移除 连接成功回调，（只移除 self 中添加的监听）
socket.event.removeConnect(self);

要移除所有连接成功回调
socket.event.removeConnect(nil);
```
#### 连接断开 回调
```
添加 websocket 已经断开连接回调
socket.event.CloseAor(self, ^(Jsocket *jscoket) {
});

如果 block 为 nil 时，表示移除回调。实际上等于调用下面的移除
socket.event.CloseAor(self,nil);

移除 连接断开回调，（只移除 self 中添加的监听）
socket.event.removeClose(self);

要移除所有连接断开回调
socket.event.removeClose(nil);
```
#### 连接错误 回调
```
添加 websocket 已经连接错误回调
socket.event.ErrorAor(self, ^(Jsocket *jscoket) {
});

如果 block 为 nil 时，表示移除回调。实际上等于调用下面的移除
socket.event.ErrorAor(self,nil);

移除 连接错误回调，（只移除 self 中添加的监听）
socket.event.removeError(self);

要移除所有连接错误回调
socket.event.removeError(nil);
```
#### 消息监听
首先，消息监听被添加到2个 Dictionary 中，如下：
添加到 Listener 的回调 只能手动移除
添加到 Callback 的回调 在websocket回复中调用后移除。
也就是说 Callback中的一个 block 只能执行一次
```
/*回复 监听列表*/
@property(nonatomic,strong)NSMutableDictionary * Listener;

/*回复 回调列表*/
@property(nonatomic,strong)NSMutableDictionary * Callback;
```

------------


发送
```
发送请求，等待回复成功并调用这个回调，调用完成后删除这个回调
(注意：block 不要传 nil，否则将会执行删除操作)
socket.send(self,data,^(id response, NSInteger flag, NSString *msg, Jsocket *jscoket) {
})；
```

------------
监听

```
如果，消息是服务器主动推送下来的，或者我想监听 某个 `action` 值的消息
socket.event.ListenerAor(@"10000", self, ^(id response, NSInteger flag, NSString *msg, Jsocket *jscoket) {
}, YES);

(注意：最后一个参数 always 要设置为 YES，否则只会调用一次)
socket.send() 方法实际上就是调用 ListenerAor(action, target, callback, NO);

always==YES 时，回调是添加到 NSMutableDictionary * Listener; 中的

always==NO 时，回调是添加到 NSMutableDictionary * Callback; 中的
```

------------
移除
```
当 callback== nil 时,表示移除
socket.event.ListenerAor(@"10000", self, nil, YES);

上面的方法将 action=@"10000" && taget == self && always==YES 的回调移除
```

------------

```
移除 Listener 中 taget == self 的回调
socket.event.removeListener(self);

如果 taget == nil,清空 Listener
socket.event.removeListener(nil);

```

------------

```
移除 Callback 中 taget == self 的回调
socket.event,removeCallback(self);

如果 taget == nil,清空 Callback
socket.event.removeCallback(nil);
```

```
移除 Listener、Callback、连接监听、断开监听、错误监听
中 taget == self 的回调
socket.event.remove(self);


如果 taget == nil；表示清空所有回调
socket.event.remove(nil);
```

## Author

lywsbcn, 89324055@qq.com

## License

Jsocket is available under the MIT license. See the LICENSE file for more info.

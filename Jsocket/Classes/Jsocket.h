//
//  Jsocket.h
//  Jsocket
//
//  Created by w on 2019/1/10.
//  Copyright © 2019年 w. All rights reserved.
//

/*需要引入 libicucore.tbd*/
#import <UIKit/UIKit.h>
#import "YYModel.h"
#import "SRWebSocket.h"
#import "JsocketConn.h"
#import "JsocketLog.h"
#import "JsocketEvent.h"
#import "JsCallback.h"

@class Jsocket;
/*设置url*/
typedef Jsocket *(^JsBlockSetWsUrl)(NSString *host,NSString * port,BOOL upgroup);
/*发送消息*/
typedef Jsocket *(^JsBlockASend)(id target,id param,JsBlockMsgCallback callback,BOOL always);

typedef Jsocket *(^JsBlockSend)(id target,id param,JsBlockMsgCallback callback);
/*连接打开*/
typedef Jsocket *(^JsBlockOpen)(void);
/*连接关闭*/
typedef Jsocket *(^JsBlockClose)(void);
/*心跳包*/
typedef id(^JsBlockHbPacket) (void);
/*握手包*/
typedef id(^JsBlockHsPacket) (void);

/*WebSocket 封装类*/
@interface Jsocket : NSObject

+(instancetype)instant;

/*WebSocket url 可直接设置*/
@property(nonatomic,copy)NSString * wsUrl;

/*设置WebSocket Url*/
@property(nonatomic,copy)JsBlockSetWsUrl setWsUrl;

/*打开WebSocket连接*/
@property(nonatomic,copy,readonly)JsBlockOpen open;

/*关闭WebSocket连接*/
@property(nonatomic,copy,readonly)JsBlockClose close;

/*发送WebSoket请求*/
@property(nonatomic,copy,readonly)JsBlockSend send;
@property(nonatomic,copy,readonly)JsBlockASend asend;


/*重连相关*/
@property(nonatomic,strong,readonly)JsocketConn * conn;

/*控制台 打印相关*/
@property(nonatomic,strong,readonly)JsocketLog * log;

/*事件监听回调相关*/
@property(nonatomic,strong,readonly)JsocketEvent * event;


/*数据源*/
@property(nonatomic,assign)CGFloat hbInterval;

@property(nonatomic,strong)NSTimer * hbTimer;

@property(nonatomic,copy)JsBlockHbPacket hbPacket;

@property(nonatomic,copy)JsBlockHbPacket hsPacket;


@property(nonatomic,assign,readonly)SRReadyState  state;

@end

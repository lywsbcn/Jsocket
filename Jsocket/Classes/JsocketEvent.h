//
//  JsocketEvent.h
//  Jsocket
//
//  Created by w on 2019/1/10.
//  Copyright © 2019年 w. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsCallback.h"

/*请求回复监听*/
typedef void(^blockJseListener)(id action,id target,JsBlockMsgCallback callback,BOOL always);
/*握手监听*/
typedef void(^blockJseHandshake)(id target,JsBlockMsgCallback callback);
/*WebSocket监听*/
typedef void(^blockJseEvent)(id target,JsBlockEventCallback callback);
/*移除监听*/
typedef void(^blockJseRemove)(id target);

@class Jsocket;
@interface JsocketEvent : NSObject

-(instancetype)initWithJsocket:(Jsocket *)js;

/*action key*/
@property(nonatomic,copy)NSString * Kaction;

/*flag key*/
@property(nonatomic,copy)NSString * Kflag;

/*msg key*/
@property(nonatomic,copy)NSString * Kmsg;

/*连接成功 回调列表*/
@property(nonatomic,strong)NSMutableArray <JsEventCallback *>* ConnectList;

/*添加或者移除 连接成功回调
 当 callback 为false时,表示移除
 */
@property(nonatomic,copy,readonly)blockJseEvent ConnectAor;

/*移除 连接成功回调
 当 target ==false时
 移除所有连接成功的回调
 */
@property(nonatomic,copy,readonly)blockJseRemove removeConnect;

/*连接关闭 回调列表*/
@property(nonatomic,strong)NSMutableArray <JsEventCallback *>* CloseList;

/*添加或者移除 连接关闭回调
 当 callback 为false时,表示移除
 */
@property(nonatomic,copy,readonly)blockJseEvent CloseAor;

/*移除 连接失败回调
 当 target ==false时
 移除所有连接关闭的回调
 */
@property(nonatomic,copy,readonly)blockJseRemove removeClose;

/*连接错误 回调列表*/
@property(nonatomic,strong)NSMutableArray <JsEventCallback *>* ErrorList;

/*添加或者移除 连接错误回调
 当 callback 为false时,表示移除
 */
@property(nonatomic,copy,readonly)blockJseEvent ErrorAor;

/*移除 连接错误回调
 当 target ==false时
 移除所有连接错误的回调
 */
@property(nonatomic,copy,readonly)blockJseRemove removeError;

/*回复 监听列表*/
@property(nonatomic,strong)NSMutableDictionary * Listener;

/*回复 回调列表*/
@property(nonatomic,strong)NSMutableDictionary * Callback;

/*添加或者移除 监听回调
 当 callback 为false时,表示移除
 当 always == true 添加到 Listener
 当 always == false 添加到 Callback
 */
@property(nonatomic,copy,readonly)blockJseListener ListenerAor;

/*移除 监听
 当 target ==false时
 移除所有监听
 */
@property(nonatomic,copy,readonly)blockJseRemove removeListener;

/*移除 回调
 当 target ==false时
 移除所有 回复回调
 */
@property(nonatomic,copy,readonly)blockJseRemove removeCallback;

/*回复 握手回调列表*/
@property(nonatomic,strong)NSMutableArray <JsCallback *> * HandshakeList;

/*添加或者移除 握手回调
 当 callback 为false时,表示移除
 当 always == true 添加到 Listener
 当 always == false 添加到 Callback
 */
@property(nonatomic,copy,readonly)blockJseHandshake HandshakeAor;

/*移除 握手回调
 当 target ==false时
 移除所有握手的回调
 */
@property(nonatomic,copy,readonly)blockJseRemove removeHandshake;

/*移除 所有回调
 当 target ==false时
 移除所有的回调
 */
@property(nonatomic,copy,readonly)blockJseRemove remove;


@end

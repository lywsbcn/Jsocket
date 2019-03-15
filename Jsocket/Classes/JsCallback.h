//
//  JsCallback.h
//  Jsocket
//
//  Created by w on 2019/1/10.
//  Copyright © 2019年 w. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Jsocket;
/*消息回调*/
typedef void(^JsBlockMsgCallback)(id response,NSInteger flag,NSString * msg,Jsocket * jsocket);
/*事件回调,1.连接成功 2.连接错误 3.连接关闭*/
typedef void(^JsBlockEventCallback)(Jsocket * jsocket);

@interface JSCallbackBase :NSObject

@property(nonatomic,weak)id target;

@property(nonatomic,assign)BOOL always;

@end

@interface JsCallback : JSCallbackBase

@property(nonatomic,copy)JsBlockMsgCallback block;

@end

@interface JsEventCallback : JSCallbackBase

@property(nonatomic,copy)JsBlockEventCallback block;

@end

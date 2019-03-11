//
//  JsocketLog.h
//  Jsocket
//
//  Created by w on 2019/1/10.
//  Copyright © 2019年 w. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsocketLog : NSObject

/*WebSocket 标签*/
@property(nonatomic,copy)NSString * TAG;

/*是否打印Log,默认为true*/
@property(nonatomic,assign)BOOL showLog;

/*请求Log过滤器,
 添加reqeuestFiltter中 action 值不发送请求不打印Log
 */
@property(nonatomic,strong)NSMutableArray * reqeuestFiltter;

/*回复Log过滤器,
 添加responseFiltter中 action 值不收到回复不打印Log
 */
@property(nonatomic,strong)NSMutableArray * responseFiltter;

@end

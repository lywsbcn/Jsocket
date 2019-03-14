//
//  Jsocket.m
//  Jsocket
//
//  Created by w on 2019/1/10.
//  Copyright © 2019年 w. All rights reserved.
//

#import "Jsocket.h"
#ifndef NDEBUG
#define NLog(message, ...) printf("%s\n\n", [[NSString stringWithFormat:message, ##__VA_ARGS__] UTF8String])
#else
#define NLog(message, ...)
#endif

static Jsocket * jsocketManager = nil;
@interface Jsocket()<SRWebSocketDelegate>

@property(nonatomic,strong)SRWebSocket * ws;

@end

@implementation Jsocket

+(instancetype)instant{
    if(!jsocketManager){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            jsocketManager =[[Jsocket alloc]init];
        });        
    }
    return jsocketManager;
}

-(instancetype)init{
    if(self =[super init]){
        __weak typeof(self) wself = self;
        
        _hbInterval = 10;
        
        _log = [[JsocketLog alloc]init];
        
        _conn =[[JsocketConn alloc]init];
        
        _event=[[JsocketEvent alloc]initWithJsocket:self];
        
        
        /*设置 url*/
        _setWsUrl = ^Jsocket *(NSString *host, NSString * port, BOOL upgroup) {
            
            NSMutableString * protocol = [NSMutableString stringWithFormat:@"%@",upgroup ? @"wss://" : @"ws://"];
            
            [protocol appendFormat:@"%@",host];
            
            if(port.length >0){
                [protocol appendFormat:@":%@",port];
            }
            
            wself.wsUrl = protocol;
            
            return wself;
        };
        
        /*打开WebSocket*/
        _open = ^Jsocket * (void){
            [wself openWs];
            return wself;
        };
        
        /*关闭WebSocket*/
        _close=^Jsocket *(void){
            [wself closeWS];
            return wself;
        };
        
        /*发送WebSocket请求*/
        _send = ^Jsocket *(id target, id param, JsBlockMsgCallback callback) {
            return wself.asend(target,param,callback,NO);
        };
        
        _asend =^Jsocket *(id target, id param, JsBlockMsgCallback callback,BOOL always) {
            param = [param yy_modelToJSONObject];
            
            id action = [param objectForKey:wself.event.Raction];
            
            if(action){
                wself.event.ListenerAor(action, target, callback, always);
                [wself sendData:param action:action];
            }
            
            return wself;
        };
        
    }
    return self;
}

/*发送WebSocket请求*/
-(void)sendData:(id)param action:(id)action{
//    NSData *data=[NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
//
//    NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

    NSString * str =[param yy_modelToJSONString];
    
    if(self.log.showLog){
        BOOL have = NO;
        for(id ac in self.log.reqeuestFiltter){
            if([action isEqual:ac]){
                have = YES;
                break;
            }
        }
        if(!have) NLog(@"%@ 发送请求--%@",self.log.TAG,str);
    }
    
    if(self.ws && self.ws.readyState == SR_OPEN){
        [self.ws send:str];
    }
}

-(void)openWs{
    [self closeWS];
    
    NSURL * url = [NSURL URLWithString:self.wsUrl];
    self.ws = [[SRWebSocket alloc]initWithURLRequest:[[NSURLRequest alloc]initWithURL:url]];
    self.ws.delegate = self;
    [self.ws open];
    
    if(self.log.showLog){
        NLog(@"%@ 正在连接--%@",self.log.TAG,self.wsUrl);
    }
}

-(void)closeWS{
    if(self.ws.readyState == SR_OPEN){
        if(self.log.showLog){
            NLog(@"%@ 关闭连接--%@",self.log.TAG,self.wsUrl);
        }
        [self.ws close];
    }
    
    self.ws.delegate = nil;
    self.ws = nil;
    
    [self.hbTimer invalidate];
    self.hbTimer=nil;
    
    [self.conn.timer invalidate];
    self.conn.timer = nil;
}

-(void)handshakeResponse:(id)response flag:(NSInteger)flag msg:(NSString *)msg{
    for(JsCallback * jsc in self.event.HandshakeList){
        if(jsc.block){
            jsc.block(response, flag, msg, self);
        }
    }
}

#pragma mark -=====websocket代理=====

-(void)webSocketDidOpen:(SRWebSocket *)webSocket{
    if(self.log.showLog){
        NLog(@"%@ 连接成功",self.log.TAG);
    }
    
    for(JsEventCallback * jse in self.event.ConnectList){
        if(jse.block){
            jse.block(self);
        }
    }
    
    if(self.hsPacket){
        self.asend(@"handshake", self.hsPacket(), ^(id response, NSInteger flag, NSString *msg, Jsocket *jscoket) {
            [jscoket handshakeResponse:response flag:flag msg:msg];
        }, YES);
    }
}

-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    if(self.log.showLog){
        NLog(@"%@ 连接失败",self.log.TAG);
    }
    for (JsEventCallback* jse in self.event.ErrorList) {
        if(jse.block){
            jse.block(self);
        }
    }
    
    [self reConnect];
}

-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    if(self.log.showLog){
         NLog(@"%@ 连接断开  ",self.log.TAG);
    }
   
    for(JsEventCallback * jse in self.event.CloseList){
        if(jse.block){
            jse.block(self);
        }
    }
    
    
    if(code == 0){
        
    }else{
        [self reConnect];
    }
}
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    
}
-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    
    NSData *messageData =[message dataUsingEncoding:NSUTF8StringEncoding];
    id dic =[NSJSONSerialization JSONObjectWithData:messageData options:NSJSONReadingMutableContainers error:nil];
    
    id action = [dic objectForKey:self.event.Kaction];
    NSInteger flag = [[dic objectForKey:self.event.Kflag] integerValue];
    NSString * msg =[dic objectForKey:self.event.Kmsg];
    
    if(self.log.showLog){
        BOOL have = NO;
        for(id a in self.log.responseFiltter){
            if([a isEqual:action]){
                have = YES;
                break;
            }
        }
        if(!have) NLog(@"%@ 收到数据--- %@",self.log.TAG,message);
    }
    
    //遍历回调
    NSMutableArray <JsCallback*>* eventModel = [self.event.Callback objectForKey:action];
    
    for(JsCallback * jsc in eventModel){
        if(jsc.block){
            jsc.block(dic, flag, msg, self);
        }
        
        [eventModel removeObject:jsc];
    }
    
    if(eventModel && eventModel.count==0){
        [self.event.Callback removeObjectForKey:action];
    }
    
    //遍历监听
    eventModel = [self.event.Listener objectForKey:action];
    
    for(JsCallback * jsc in eventModel){
        if(jsc.block){
            jsc.block(dic, flag, msg, self);
        }
    }
}

/*重连*/
-(void)reConnect{
    [self closeWS];
    if(!self.conn.isReConn) return;
    if(self.conn.number>0 && self.conn.currNumber > self.conn.number) return;
    
    switch (self.conn.pattern) {
        case JsocketConnPatternNormarl:
            
            break;
        case JsocketConnPatternLoop:
            self.conn.interval *=2;
            break;
            
        default:
            break;
    }
    
    self.conn.timer =[NSTimer scheduledTimerWithTimeInterval:self.conn.interval target:self selector:@selector(reConnectAction) userInfo:nil repeats:NO];
}
-(void)reConnectAction{
    [self openWs];
}

-(void)setHbPacket:(id (^)(void))hbPacket{
    _hbPacket = hbPacket;
    
    if(self.hbTimer) return;
    self.hbTimer =[NSTimer scheduledTimerWithTimeInterval:self.hbInterval target:self selector:@selector(hbAction) userInfo:nil repeats:YES];
}
-(void)hbAction{
    self.asend(nil, self.hbPacket(), nil, NO);
}

-(SRReadyState )state{
    return self.ws.readyState;
}

-(void)dealloc{
    NSLog(@"%@ 释放啦~~~~",[self class]);
}

@end

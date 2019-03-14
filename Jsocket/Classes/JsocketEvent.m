//
//  JsocketEvent.m
//  Jsocket
//
//  Created by w on 2019/1/10.
//  Copyright © 2019年 w. All rights reserved.
//

#import "JsocketEvent.h"
#import "Jsocket.h"
@interface JsocketEvent()

//@property(nonatomic,weak)Jsocket * js;

@end

@implementation JsocketEvent

-(instancetype)initWithJsocket:(Jsocket *)js{
    if(self =[super init]){
//        _js = js;
        __weak typeof(self) wself = self;
        
        _Raction = @"action";
        _Kaction = @"action";
        _Kflag = @"flag";
        _Kmsg = @"msg";
        
        //添加或移除回调 到callbackList或 ListenerList
        _ListenerAor = ^(id action, id target, JsBlockMsgCallback callback, BOOL always) {
            JsCallback * jsc =[[JsCallback alloc]init];
            jsc.always = always;
            jsc.target = target;
            jsc.block = callback;
            
            NSMutableArray * list;
            if(always){
                list = [wself.Listener objectForKey:action];
                if(!list) {
                    list = [NSMutableArray array];
                    [wself.Listener setObject:list forKey:action];
                }
            }else{
                list = [wself.Callback objectForKey:action];
                if(!list){
                    list = [NSMutableArray array];
                    [wself.Callback setObject:list forKey:action];
                }
            }
            
            [wself Aor:jsc list:list];
            
//            if(always)
//                NSLog(@"ListenerList %@",wself.Listener);
//            else
//                NSLog(@"CallbackList %@",wself.Callback);
        };
    
        _removeListener = ^(id target) {
            if(!target){
                [wself.Listener removeAllObjects];
                return ;
            }
            for(id key in wself.Listener){
                NSMutableArray * list = [wself.Listener objectForKey:key];
                [wself removeAll:target list:list];
                if(list.count ==0) [wself.Listener removeObjectForKey:key];
            }
            
//            NSLog(@"ListenerList %@",wself.Listener);
        };
        
        _removeCallback = ^(id target) {
            if(!target){
                [wself.Callback removeAllObjects];
                return ;
            }
            
            for(id key in wself.Callback){
                NSMutableArray * list =[wself.Callback objectForKey:key];
                [wself removeAll:target list:list];
                if(list.count==0) [wself.Callback removeObjectForKey:key];
            }
            
//            NSLog(@"CallbackList %@",wself.Callback);
        };
        
        
        //添加回调到 HandshakeList
        _HandshakeAor = ^(id target, JsBlockMsgCallback callback) {
            JsCallback * jsc = [[JsCallback alloc]init];
            jsc.always = YES;
            jsc.target = target;
            jsc.block = callback;
            
            [wself Aor:jsc list:wself.HandshakeList];
            
//            NSLog(@"HandshakeList %@",wself.HandshakeList);
        };
        
        _removeHandshake = ^(id target) {
            [wself removeAll:target list:wself.HandshakeList];
//            NSLog(@"HandshakeList %@",wself.HandshakeList);
        };
        
        //添加回调到 ConnectList
        _ConnectAor = ^(id target, JsBlockEventCallback callback) {
            JsEventCallback * jsc =[[JsEventCallback alloc]init];
            jsc.always = YES;
            jsc.target = target;
            jsc.block = callback;
            
            [wself EventAor:jsc list:wself.ConnectList];
            
            if(js.state == SR_OPEN){
                jsc.block(js);
            }
            
//            NSLog(@"ConnectList %@",wself.ConnectList);
        };
        
        _removeConnect = ^(id target) {
            [wself removeAll:target list:wself.ConnectList];
//            NSLog(@"ConnectList %@",wself.ConnectList);
        };
        
        
         //添加回调到 CloseList
        _CloseAor = ^(id target, JsBlockEventCallback callback) {
            JsEventCallback * jsc =[[JsEventCallback alloc]init];
            jsc.always = YES;
            jsc.target = target;
            jsc.block = callback;
            
            [wself EventAor:jsc list:wself.CloseList];
//            NSLog(@"CloseList %@",wself.CloseList);
        };
        
        _removeClose = ^(id target) {
            [wself removeAll:target list:wself.CloseList];
//            NSLog(@"CloseList %@",wself.CloseList);
        };
        
         //添加回调到 ErrorList
        _ErrorAor = ^(id target, JsBlockEventCallback callback) {
            JsEventCallback * jsc =[[JsEventCallback alloc]init];
            jsc.always = YES;
            jsc.target = target;
            jsc.block = callback;
            
            [wself EventAor:jsc list:wself.ErrorList];
//            NSLog(@"ErrorList %@",wself.ErrorList);
        };
        
        _removeError = ^(id target) {
            [wself removeAll:target list:wself.ErrorList];
//            NSLog(@"ErrorList %@",wself.ErrorList);
        };
        
        
        _remove = ^(id target) {
            wself.removeListener(target);
            wself.removeCallback(target);
            wself.removeHandshake(target);
            wself.removeConnect(target);
            wself.removeClose(target);
            wself.removeError(target);
        };
        
    }
    return self;
}


-(void)Aor:(JsCallback *)jscm list:(NSMutableArray*)list{
    if(!jscm.target) return;
    
    if(!jscm.block){
        [self remove:jscm.target list:list];
        return;
    }
    
    for(JsCallback * jsc in list){
        if([self equal:jsc.target anOther:jscm.target] && [self equal:jsc.block anOther:jscm.block]){
            return;
        }
    }
    [list addObject:jscm];
    
    
}
-(void)EventAor:(JsEventCallback*)jscm list:(NSMutableArray*)list{
    if(!jscm.target) return;
    
    if(!jscm.block){
        [self remove:jscm.target list:list];
        return;
    }
    
    for(JsEventCallback * jsc in list){
        if([self equal:jsc.target anOther:jscm.target] && [self equal:jsc.block anOther:jscm.block]){
            return;
        }
    }
    [list addObject:jscm];
    
    
}


-(void)removeAll:(id)target list:(NSMutableArray*)list{
    if(!target){
        [list removeAllObjects];
        return ;
    }
    [self remove:target list:list];
}
-(void)remove:(id)target list:(NSMutableArray*)list{
    
    NSInteger i= list.count;
    while (i--) {
        JSCallbackBase * jsc = list[i];
        if(!jsc.target || [self equal:jsc.target anOther:target]){
            [list removeObject:jsc];
        }
    }
    
    
}


-(BOOL)equal:(id)object anOther:(id)anOtherObject{
    if([object isKindOfClass:[anOtherObject class]]){
        if([object isKindOfClass:[NSString class]]){
            return [object isEqualToString:anOtherObject];
        }
        return [object isEqual:anOtherObject];
    }
    return NO;
}

#pragma mark- 列表 GET
-(NSMutableArray<JsEventCallback *> *)ConnectList{
    if(!_ConnectList){
        _ConnectList =[NSMutableArray array];
    }
    return _ConnectList;
}
-(NSMutableArray<JsEventCallback *> *)CloseList{
    if(!_CloseList){
        _CloseList =[NSMutableArray array];
    }
    return _CloseList;
}
-(NSMutableArray<JsEventCallback *> *)ErrorList{
    if(!_ErrorList){
        _ErrorList =[NSMutableArray array];
    }
    return _ErrorList;
}
-(NSMutableArray<JsCallback *> *)HandshakeList{
    if(!_HandshakeList){
        _HandshakeList =[NSMutableArray array];
    }
    return _HandshakeList;
}
-(NSMutableDictionary *)Listener{
    if(!_Listener){
        _Listener =[NSMutableDictionary dictionary];
    }
    return _Listener;
}
-(NSMutableDictionary *)Callback{
    if(!_Callback){
        _Callback =[NSMutableDictionary dictionary];
    }
    return _Callback;
}



@end

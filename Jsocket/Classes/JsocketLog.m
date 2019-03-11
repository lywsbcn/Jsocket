//
//  JsocketLog.m
//  Jsocket
//
//  Created by w on 2019/1/10.
//  Copyright © 2019年 w. All rights reserved.
//

#import "JsocketLog.h"

@implementation JsocketLog

-(instancetype)init{
    if(self =[super init]){
        _showLog = YES;
    }
    return self;
}

-(NSMutableArray *)reqeuestFiltter{
    if(!_reqeuestFiltter){
        _reqeuestFiltter =[NSMutableArray array];
    }
    return _reqeuestFiltter;
}

-(NSMutableArray *)responseFiltter{
    if(!_responseFiltter){
        _responseFiltter=[NSMutableArray array];
    }
    return _responseFiltter;
}

@end

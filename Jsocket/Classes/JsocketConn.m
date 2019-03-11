//
//  JsocketConn.m
//  Jsocket
//
//  Created by w on 2019/1/10.
//  Copyright © 2019年 w. All rights reserved.
//

#import "JsocketConn.h"

@implementation JsocketConn

-(instancetype)init{
    if(self =[super init]){
        _isReConn = YES;
        _number = 10;
        _currNumber = 0;
        _interval = 10;
        _intervalMax = 60;
        _intervalMin = 2;
        
    }
    return self;
}

-(void)setPattern:(JsocketConnPattern)pattern{
    _pattern = pattern;
    if(pattern == JsocketConnPatternLoop){
        _interval = _intervalMin;
    }
}

-(void)setIntervalMax:(CGFloat)intervalMax{
    _intervalMax = intervalMax < _intervalMin ? _intervalMin: intervalMax;
}
-(void)setIntervalMin:(CGFloat)intervalMin{
    _intervalMin = intervalMin;
    _intervalMax = _intervalMax < intervalMin ? intervalMin : _intervalMax;
}

@end

//
//  JsocketConn.h
//  Jsocket
//
//  Created by w on 2019/1/10.
//  Copyright © 2019年 w. All rights reserved.
//

#import <UIKit/UIKit.h>
/*重连模式*/
typedef NS_ENUM(NSInteger,JsocketConnPattern) {
    JsocketConnPatternNormarl, //正常模式,每隔固定时长 重连一次
    JsocketConnPatternLoop     //倍数模式,每次重连的时间是上次重连时间 *2
};

@interface JsocketConn : NSObject

//是否重连,默认为true
@property(nonatomic,assign)BOOL isReConn;

//重连模式,默认为  JsocketConnPatternNormarl
@property(nonatomic,assign)JsocketConnPattern pattern;

/*重连次数,当重连次数超过该值是,不再连接.
  无限重连 设置值为 0, 默认为0
 */
@property(nonatomic,assign)NSInteger number;

/*当前重连次数 */
@property(nonatomic,assign)NSInteger currNumber;

/*重连时间(秒),当pattern =JsocketConnPatternLoop 时,
 时间从 intervalMin ->intervalMax->intervalMin 循环
 */
@property(nonatomic,assign)CGFloat interval;

/*当pattern =JsocketConnPatternLoop 时,
 重连间隔时间大于intervalMax 时,下一次从intervalMin开始
 */
@property(nonatomic,assign)CGFloat intervalMax;

/*当pattern =JsocketConnPatternLoop 时
 重连间隔时间从intervalMin 开始
 */
@property(nonatomic,assign)CGFloat intervalMin;

/*重连定时器*/
@property(nonatomic,strong)NSTimer * timer;

@end

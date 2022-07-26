//
//  NSString+Calculate.h
//  DLSmartInfo
//
//  Created by ltf on 2019/2/13.
//  Copyright © 2019 DFITC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Calculate)
//加
- (NSString *)calculateByAdding:(NSString *)stringNumer;
//减
- (NSString *)calculateBySubtracting:(NSString *)stringNumer;
//乘
- (NSString *)calculateByMultiplying:(NSString *)stringNumer;
//除
- (NSString *)calculateByDividing:(NSString *)stringNumer;
//幂运算
- (NSString *)calculateByRaising:(NSUInteger)power;
//四舍五入
- (NSString *)calculateByRounding:(NSUInteger)scale;

//是否相等
- (BOOL)calculateIsEqual:(NSString *)stringNumer;
//是否大于
- (BOOL)calculateIsGreaterThan:(NSString *)stringNumer;
//是否小于
- (BOOL)calculateIsLessThan:(NSString *)stringNumer;
//转成小数
- (double)calculateDoubleValue;
//double转换成string
+ (NSString *)formatByDoubleValue:(double)value;

//格式化按倍数
//tick整数倍
- (NSString *)formatMultipleByTick:(double)tick;

@end

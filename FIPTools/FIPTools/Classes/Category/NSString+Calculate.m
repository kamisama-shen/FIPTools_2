//
//  NSString+Calculate.m
//  DLSmartInfo
//
//  Created by ltf on 2019/2/13.
//  Copyright © 2019 DFITC. All rights reserved.
//

#import "NSString+Calculate.h"
@implementation NSString (Calculate)
//加
- (NSString *)calculateByAdding:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSDecimalNumber *addingNum = [num1 decimalNumberByAdding:num2];
    return [addingNum stringValue];
}
//减
- (NSString *)calculateBySubtracting:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSDecimalNumber *subtractingNum = [num1 decimalNumberBySubtracting:num2];
    return [subtractingNum stringValue];
}
//乘
- (NSString *)calculateByMultiplying:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSDecimalNumber *multiplyingNum = [num1 decimalNumberByMultiplyingBy:num2];
    return [multiplyingNum stringValue];
}
//除
- (NSString *)calculateByDividing:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSDecimalNumber *dividingNum = [num1 decimalNumberByDividingBy:num2];
    return [dividingNum stringValue];
    
}
//幂运算
- (NSString *)calculateByRaising:(NSUInteger)power
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *raisingNum = [num1 decimalNumberByRaisingToPower:power];
    return [raisingNum stringValue];
    
}
//四舍五入
- (NSString *)calculateByRounding:(NSUInteger)scale
{
    NSDecimalNumberHandler * handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundPlain scale:scale raiseOnExactness:NO raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *roundingNum = [num1 decimalNumberByRoundingAccordingToBehavior:handler];
    return [roundingNum stringValue];
}
//是否相等
- (BOOL)calculateIsEqual:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSComparisonResult result = [num1 compare:num2];
    if (result == NSOrderedSame) {
        return YES;
    }
    return NO;
}
//是否大于
- (BOOL)calculateIsGreaterThan:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSComparisonResult result = [num1 compare:num2];
    if (result == NSOrderedDescending) {
        return YES;
    }
    return NO;

}
//是否小于
- (BOOL)calculateIsLessThan:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSComparisonResult result = [num1 compare:num2];
    if (result == NSOrderedAscending) {
        return YES;
    }
    return NO;

}

//string转换double
- (double)calculateDoubleValue
{
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:self];
    return [num doubleValue];
}

//double转string
+ (NSString *)formatByDoubleValue:(double)value{
    NSString *dStr = [NSString stringWithFormat:@"%lf", value];
    NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
    return dn.stringValue;
}

- (NSString *)formatMultipleByTickStr:(NSString *)tick{
    
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:tick];
    if (num2.doubleValue == 0) {
        return nil;
    }
    // 向下取整
    NSDecimalNumberHandler *roundDown = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:0 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *dividingNum = [num1 decimalNumberByDividingBy:num2 withBehavior:roundDown];
    NSString *result = [dividingNum.stringValue calculateByMultiplying:tick];
    return result;
}

- (NSString *)formatMultipleByTick:(double)tick{
    NSString *tickStr = [NSString stringWithFormat:@"%lf",tick];
    NSString *result = [self formatMultipleByTickStr:tickStr];
    return result;
}
@end

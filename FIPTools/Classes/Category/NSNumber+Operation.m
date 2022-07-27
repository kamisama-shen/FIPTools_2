//
//  NSNumber+Operation.m
//  NSNumberOperation
//  https://github.com/YHQiu/NSNumberOperation
//  Created by 邱弘宇 on 2018/3/3.
//  Copyright © 2018年 邱弘宇. All rights reserved.
//

#import "NSNumber+Operation.h"
@interface NSNumber (Compare)

/**
 比较两个Number值

 @param parameter1 参数一
 @param parameter2 参数二
 @param scale 保留位数
 @return NSComparisonResult对象
 */
+ (NSComparisonResult)compareForNumberHandle:(NSNumber *)parameter1 withParameter:(NSNumber *)parameter2 withScale:(short)scale;

@end

@interface NSNumber (Operation)

+ (NSDecimalNumber *)accuracyLostWithNumberHandle:(NSNumber *)value;

+ (NSDecimalNumber *)accuracyLostWithNumberHandle:(NSNumber *)value withScale:(short)scale;

@end

@implementation NSNumber (Compare)

/**
 处理精度丢失

 @param value 数值
 @return 处理的字符串
 */
+ (NSDecimalNumber *)accuracyLostWithNumberHandle:(NSNumber *)value {
    return [self accuracyLostWithNumberHandle:value withScale:kPrecisionLength];
}

/**
 处理精度丢失

 @param value 数值
 @param scale 保留位数
 @return 处理的字符串
 */
+ (NSDecimalNumber *)accuracyLostWithNumberHandle:(NSNumber *)value withScale:(short)scale {
    if (value == nil) {
        return NSDecimalNumber.notANumber;
    }
    NSNumber *handleValue = value;
    if (![handleValue isKindOfClass:[NSNumber class]]) {
        if ([handleValue isKindOfClass:[NSString class]]) {
            handleValue = [NSNumber numberWithString:(NSString *)handleValue];
            if (handleValue == nil) {
                return NSDecimalNumber.notANumber;
            }
        } else {
            NSLog(@"Number Handle_1----____Warning %@,Please Check",handleValue);
            return NSDecimalNumber.notANumber;
        }
    }

    NSDecimalNumberHandler *roundBankers = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *mountDecimalNumber = [[NSDecimalNumber alloc] initWithDecimal:[handleValue ? : @(0)decimalValue]];
    NSDecimalNumber *dealDecimalNumber = [mountDecimalNumber decimalNumberByRoundingAccordingToBehavior:roundBankers];
    if ([dealDecimalNumber isEqualToNumber:NSDecimalNumber.notANumber]) {
        NSLog(@"Number Handle_2----____Warning %@,Please Check",handleValue);
    }
    return dealDecimalNumber;
}

/**
 比较两个Number值
 @param parameter1 参数一
 @param parameter2 参数二
 @param scale 保留位数
 @return NSComparisonResult对象
 */
+ (NSComparisonResult)compareForNumberHandle:(NSNumber *)parameter1 withParameter:(NSNumber *)parameter2 withScale:(short)scale {
    NSDecimalNumber *parameter1Number = [self accuracyLostWithNumberHandle:parameter1 withScale:scale];
    NSDecimalNumber *parameter2Number = [self accuracyLostWithNumberHandle:parameter2 withScale:scale];
    return [parameter1Number compare:parameter2Number];
}

+ (NSString *)stringByTrimWithString:(NSString *)str {
    if (nil == str) {
        return str;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [str stringByTrimmingCharactersInSet:set];
}

+ (NSNumber *)numberWithString:(NSString *)string {
    NSString *str = [[self stringByTrimWithString:string] lowercaseString];
    if (!str || !str.length) {
        return nil;
    }

    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{ @"true":   @(YES),
                 @"yes":    @(YES),
                 @"false":  @(NO),
                 @"no":     @(NO),
                 @"nil":    [NSNull null],
                 @"null":   [NSNull null],
                 @"<null>": [NSNull null] };
    });
    id num = dic[str];
    if (num) {
        if (num == [NSNull null]) return nil;
        return num;
    }

    // hex number
    int sign = 0;
    if ([str hasPrefix:@"0x"]) sign = 1;
    else if ([str hasPrefix:@"-0x"]) sign = -1;
    if (sign != 0) {
        NSScanner *scan = [NSScanner scannerWithString:str];
        unsigned num = -1;
        BOOL suc = [scan scanHexInt:&num];
        if (suc) return [NSNumber numberWithLong:((long)num * sign)];
        else return nil;
    }
    // normal number
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:string];
}

@end

@implementation NSDecimalNumber (Operation)

+ (NSDecimalNumber *)initWithT:(id)T {
    //异常统一转换为NSDecimalNumber的 notANumber 防止链式调用崩溃
    if(T==nil)return NSDecimalNumber.notANumber;
    NSDecimalNumber *rNum;
    if (T) {
        if ([T isKindOfClass:[NSNumber class]]) {
            NSNumber *num = T;
            rNum = [[NSDecimalNumber alloc]initWithDecimal:[num decimalValue]];
        } else if ([T isKindOfClass:[NSDecimalNumber class]]) {
            rNum = T;
        } else if ([T isKindOfClass:[NSString class]]) {
            //str = null/nil 转成number = nil 最终转成notANumber
            NSNumber *strNumber = [NSNumber numberWithString:T];
            if (strNumber == nil) {
                return NSDecimalNumber.notANumber;
            }
            //该方法会把nil 置成0 此时想要的是异常处理 所以上边转换为notANumber
            rNum = [NSDecimalNumber decimalNumberWithDecimal:[strNumber decimalValue]];
        }
    }

    if ([rNum isEqualToNumber:NSDecimalNumber.notANumber]) {
        NSLog(@"Number Create_----____Warning %@,Please Check",rNum);
    }
    return rNum;
}

- (BOOL (^)(NSNumber *))equal {
    return ^BOOL (NSNumber *value) {
               return [self equal:value];
    };
}

- (BOOL (^)(NSNumber *))lessThan {
    return ^BOOL (NSNumber *value) {
               return [self lessThan:value];
    };
}

- (BOOL (^)(NSNumber *))lessThanOrEqual {
    return ^BOOL (NSNumber *value) {
               return [self lessThanOrEqual:value];
    };
}

- (BOOL (^)(NSNumber *))greaterThan {
    return ^BOOL (NSNumber *value) {
               return [self greaterThan:value];
    };
}

- (BOOL (^)(NSNumber *))greaterThanOrEqual {
    return ^BOOL (NSNumber *value) {
               return [self greaterThanOrEqual:value];
    };
}

- (NSDecimalNumber * (^)(NSNumber *))mul {
    return ^NSDecimalNumber *(NSNumber *value) {
               return [self mul:value];
    };
}

- (NSDecimalNumber * (^)(NSNumber *))div {
    return ^NSDecimalNumber *(NSNumber *value) {
               return [self div:value];
    };
}

- (NSDecimalNumber * (^)(NSNumber *))add {
    return ^NSDecimalNumber *(NSNumber *value) {
               return [self add:value];
    };
}

- (NSDecimalNumber * (^)(NSNumber *))sub {
    return ^NSDecimalNumber *(NSNumber *value) {
               return [self sub:value];
    };
}

- (NSDecimalNumber* (^)(void))scale1 {
    return ^NSDecimalNumber *(void) {
               return [self scale:1 withRoundMode:NumRoundPlain];
    };
}

- (NSDecimalNumber * (^)(void))scale2 {
    return ^NSDecimalNumber *(void) {
               return [self scale:2 withRoundMode:NumRoundPlain];
    };
}

- (NSDecimalNumber * (^)(void))scale2Ignore {
    return ^NSDecimalNumber *(void) {
               return [self scale:2 withRoundMode:NumUnRound];
    };
}

- (NSDecimalNumber* (^)(void))scale3 {
    return ^NSDecimalNumber *(void) {
               return [self scale:3 withRoundMode:NumRoundPlain];
    };
}

- (NSDecimalNumber * (^)(int scalePoint, NumRoundingMode roundMode))scale {
    return ^NSDecimalNumber *(int scalePoint, NumRoundingMode roundMode) {
               return [self scale:scalePoint withRoundMode:roundMode];
    };
}

- (NSString *(^)(int scalePoint, bool formattedInteger))stringFormatterScale {
    return ^NSString *(int scalePoint, bool formattedInteger) {
               NSDecimalNumber *inputNumer = self;
               if([inputNumer isEqualToNumber:NSDecimalNumber.notANumber]) {
//                  NSLog(@"number is nan");
                   return @"-";
               }

               if (formattedInteger) {
                   NSMutableString *formatterString = [NSMutableString stringWithString:@"0."];
                   for (NSInteger i = 0; i < scalePoint; ++i) {
                       [formatterString appendString:@"0"];
                   }
                   NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                   [formatter setPositiveFormat:formatterString];
                   return [formatter stringFromNumber:inputNumer];
               } else {
                   if (![inputNumer isIntegerNumber]) {
                       //如果非整数 补齐scale小数位
                       NSMutableString *formatterString = [NSMutableString stringWithString:@"0."];
                       for (NSInteger i = 0; i < scalePoint; ++i) {
                           [formatterString appendString:@"0"];
                       }
                       NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                       [formatter setPositiveFormat:formatterString];
                       return [formatter stringFromNumber:inputNumer];
                   } else {
                       //如果是整数直接输出
                       return inputNumer.stringValue;
                   }
               }
    };
}

- (BOOL)equal:(NSNumber *)number {
    NSComparisonResult result = [NSNumber compareForNumberHandle:self withParameter:number withScale:kComparePrecisionLength];
    if (result == NSOrderedSame) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)lessThan:(NSNumber *)number {
    NSComparisonResult result = [NSNumber compareForNumberHandle:self withParameter:number withScale:kComparePrecisionLength];
    if (result == NSOrderedAscending) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)lessThanOrEqual:(NSNumber *)number {
    NSComparisonResult result = [NSNumber compareForNumberHandle:self withParameter:number withScale:kComparePrecisionLength];
    if (result == NSOrderedAscending || result == NSOrderedSame) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)greaterThan:(NSNumber *)number {
    NSComparisonResult result = [NSNumber compareForNumberHandle:self withParameter:number withScale:kComparePrecisionLength];
    if (result == NSOrderedDescending) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)greaterThanOrEqual:(NSNumber *)number {
    NSComparisonResult result = [NSNumber compareForNumberHandle:self withParameter:number withScale:kComparePrecisionLength];
    if (result == NSOrderedDescending || result == NSOrderedSame) {
        return YES;
    } else {
        return NO;
    }
}

/**
 Multiple
 */
- (NSDecimalNumber *)mul:(NSNumber *)number {
    NSDecimalNumber *number1 = [NSNumber accuracyLostWithNumberHandle:self];
    NSDecimalNumber *number2 = [NSNumber accuracyLostWithNumberHandle:number];
    //防止线上崩溃，忽略这些异常不处理
    NSDecimalNumberHandler *numberHandler = [NSDecimalNumberHandler
                                          decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                          scale:kPrecisionLength
                                          raiseOnExactness:NO
                                          raiseOnOverflow:NO
                                          raiseOnUnderflow:NO
                                          raiseOnDivideByZero:NO];
    
    NSDecimalNumber *dNum = [number1 decimalNumberByMultiplyingBy:number2 withBehavior:numberHandler];
    return [[NSDecimalNumber alloc]initWithDecimal:[dNum decimalValue]];
}

/**
 Div
 */
- (NSDecimalNumber *)div:(NSNumber *)number {
    NSDecimalNumber *number1 = [NSNumber accuracyLostWithNumberHandle:self];
    NSDecimalNumber *number2 = [NSNumber accuracyLostWithNumberHandle:number];
    
    if (number2.equal(@(0))) {
       
        NSLog(@"Number Handle_----____Warning,Please Check %@/%@", number1, number2);
#if DEBUG || TARGET_IPHONE_SIMULATOR
        NSAssert(0, @"Number Handle_----____Warning,Please Check %@/%@", number1, number2);
#endif
        //调试情况下 raiseOnDivideByZero 这个异常手动捕获处理 在debug模式下崩溃
        //NSAssert 只抛出除以0的崩溃 异常统一输出nan
        return NSDecimalNumber.notANumber;
    }
    //防止线上崩溃，忽略这些异常不处理
    NSDecimalNumberHandler *numberHandler = [NSDecimalNumberHandler
                                          decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                          scale:kPrecisionLength
                                          raiseOnExactness:NO
                                          raiseOnOverflow:NO
                                          raiseOnUnderflow:NO
                                          raiseOnDivideByZero:NO];
    NSDecimalNumber *dNum;
    dNum = [number1 decimalNumberByDividingBy:number2 withBehavior:numberHandler];
    return [[NSDecimalNumber alloc]initWithDecimal:[dNum decimalValue]];
}

/**
 Addional
 */
- (NSDecimalNumber *)add:(NSNumber *)number {
    NSDecimalNumber *number1 = [NSNumber accuracyLostWithNumberHandle:self];
    NSDecimalNumber *number2 = [NSNumber accuracyLostWithNumberHandle:number];
    //防止线上崩溃，忽略这些异常不处理
    NSDecimalNumberHandler *numberHandler = [NSDecimalNumberHandler
                                          decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                          scale:kPrecisionLength
                                          raiseOnExactness:NO
                                          raiseOnOverflow:NO
                                          raiseOnUnderflow:NO
                                          raiseOnDivideByZero:NO];
    
    NSDecimalNumber *dNum = [number1 decimalNumberByAdding:number2 withBehavior:numberHandler];
    return [[NSDecimalNumber alloc]initWithDecimal:[dNum decimalValue]];
}

/**
 Subtract
 */
- (NSDecimalNumber *)sub:(NSNumber *)number {
    NSDecimalNumber *number1 = [NSNumber accuracyLostWithNumberHandle:self];
    NSDecimalNumber *number2 = [NSNumber accuracyLostWithNumberHandle:number];
    
    //防止线上崩溃，忽略这些异常不处理
    NSDecimalNumberHandler *numberHandler = [NSDecimalNumberHandler
                                          decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                          scale:kPrecisionLength
                                          raiseOnExactness:NO
                                          raiseOnOverflow:NO
                                          raiseOnUnderflow:NO
                                          raiseOnDivideByZero:NO];
    
    NSDecimalNumber *dNum = [number1 decimalNumberBySubtracting:number2 withBehavior:numberHandler];
    return [[NSDecimalNumber alloc]initWithDecimal:[dNum decimalValue]];
}

-(BOOL)isIntegerNumber {
    NSDecimal value = [self decimalValue];
    if (NSDecimalIsNotANumber(&value)) return NO;
    NSDecimal rounded;
    NSDecimalRound(&rounded, &value, 0, NSRoundPlain);
    return NSDecimalCompare(&rounded, &value) == NSOrderedSame;
}


- (NSDecimalNumber *)scale:(int)scale withRoundMode:(NumRoundingMode)roundMode {
    NSDecimalNumber *inputNumber = self;
    NSDecimalNumber *resultNumber = nil;
    
    if (roundMode == NumRoundPlain || roundMode == NumRoundUp || roundMode == NumRoundDown || roundMode == NumRoundBankers) {
        NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:((NSRoundingMode)roundMode) scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        resultNumber = [inputNumber decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    }else if(roundMode == NumUnRound){
        if ([inputNumber greaterThanOrEqual:N(@0)]) {
            //如果是正数  NSRoundDown 舍弃scale后面小数
            NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
            resultNumber = [inputNumber decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
        }else{
            //如果是负数  NSRoundUp 舍弃scale后面小数
            NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
            resultNumber = [inputNumber decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
        }
    }
    return resultNumber;
}


@end

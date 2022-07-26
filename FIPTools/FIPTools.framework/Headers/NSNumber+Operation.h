//
//  NSNumber+Operation.h
//  NSNumberOperation
//  https://github.com/YHQiu/NSNumberOperation
//  Created by 邱弘宇 on 2018/3/3.
//  Copyright © 2018年 邱弘宇. All rights reserved.
//

/**
 * 1、适用于金融类APP等对计算精度要求的场合
 * 2、为方便代码阅读采用线性运算，不讲究运算优先级
 */

#import <Foundation/Foundation.h>

#ifndef __custom_nsnumber_operation_precisionlength_define__
/**
 目前服务端提供全是double类型，使用该类计算、比较，只能处理99.99%，不能100%排除
 float   字节长度4字节   非0开头包含整数 控制台最多显示9位
 double  字节长度8字节   非0开头包含整数控制台最多显示17位
 尾部位数处理待研究
 */
/**
 计算过程中的精度（小数位数） 默认规则都是四舍五入
 */
#define kPrecisionLength 16

/**
 比较过程中的精度（小数位数） 默认规则都是四舍五入  精度丢失的可能存在比较结果不准确
 */
#define kComparePrecisionLength 10

#endif

#ifndef __custom_nsnumber_operation_simple_define__
/**
 计算之前将NSNumber对象包装成NSDeciamlNumber
 如:N(@12).add(@12).div(@12).mul(@12).scale2();
 ((12+12)/12)*12再格式化为2位小数
 
 如下系统异常方法统一忽略，防止线上崩溃
 NSDecimalNumberHandler：
 如：第三个参数精度异常捕获(raiseOnExactness)，
 第四个参数为数值上溢异常捕获(raiseOnOverflow)，
 第五个参数为数值下溢异常捕获(raiseOnUnderflow)，
 最后一个参数为数值除数为零异常捕获(raiseOnDivideByZero)：

 
 
 手动处理以下异常
 1.针对除数为0手动捕获在，debug模式下NSAssert，非debug模式下防止崩溃，输出nan
 2.遇到非数字,如@"",0.0/0.0,dbl_value等，转换为nan,链式最终输出nan;
 3.nil.chain会崩溃，遇到nil，转换为nan，防止链式调用block崩溃，链式最终输出nan,需注意链式第一个不能用nil调用，
   链式过程中会自动处理nil变nan;
 4.num.stringFormatterScale格式化后 如为nan输出为“-”
 
 ----------
 测试代码
 ----------
 float a = 0.0/0.0;
 BOOL c = N(@(a)).equal(@(a));
 NSLog(@"----==%@",N(@(a)).add(@(a)).mul(@(a)).div(@(a)).scale2().stringFormatterScale(2,NO));
 BOOL g = N(@(a)).greaterThan(@(a));
 */
#define N(A) [NSDecimalNumber initWithT:A]
#endif

typedef NSArray<NSNumber *> NSNumberOperationType;
//注意正负数下规则是否理解正确！
typedef NS_ENUM(NSUInteger, NumRoundingMode) {
    NumRoundPlain = NSRoundPlain,   // Round up on a tie
    NumRoundDown = NSRoundDown,     // Always down == truncate
    NumRoundUp = NSRoundUp,         // Always up
    NumRoundBankers = NSRoundBankers,  // on a tie round so last digit is even //这种应该是精度最准确的
    
    /***********以上为系统定义方法********/
    
    NumUnRound = 100,       //直接舍弃scale后位数
};

@interface NSOperationNumber : NSNumber

@end

@interface NSDecimalNumber (Operation)

/**
 初始化为NSDecimal对象
 */
+ (NSDecimalNumber *)initWithT:(id)T;

/**
 等于
 */
- (BOOL (^)(NSNumber *))equal;

/**
 小于
 */
- (BOOL (^)(NSNumber *))lessThan;

/**
 小于等于
 */
- (BOOL (^)(NSNumber *))lessThanOrEqual;

/**
 大于
 */
- (BOOL (^)(NSNumber *))greaterThan;

/**
 大于等于
 */
- (BOOL (^)(NSNumber *))greaterThanOrEqual;

/**
 是否是整数
 */
- (BOOL)isIntegerNumber;

/**
 乘
 */
- (NSDecimalNumber* (^)(NSNumber *))mul;

/**
 除
 */
- (NSDecimalNumber* (^)(NSNumber *))div;

/**
 加
 */
- (NSDecimalNumber* (^)(NSNumber *))add;

/**
 减
 */
- (NSDecimalNumber* (^)(NSNumber *))sub;

/**
 保留小数点后1位数,四舍五入
 */
- (NSDecimalNumber* (^)(void))scale1;

/**
 保留小数点后2位数,四舍五入
 */
- (NSDecimalNumber* (^)(void))scale2;

/**
 保留小数点后2位数,后面直接舍弃忽略
 */
- (NSDecimalNumber* (^)(void))scale2Ignore;

/**
 保留小数点后3位数,四舍五入
 */
- (NSDecimalNumber* (^)(void))scale3;

/**
 保留指定小数点位数, NumRoundingMode 格式化规则
 */
- (NSDecimalNumber* (^)(int scalePoint,NumRoundingMode roundMode))scale;

/**
 保留指定小数点位数 格式化NSString到scalePoint补齐0 formattedInteger是否对整数补齐0
 格式化输出显示必须调用stringFormatterScale，内部统一转nan为’-‘
*/
- (NSString* (^)(int scalePoint, bool formattedInteger))stringFormatterScale;


@end



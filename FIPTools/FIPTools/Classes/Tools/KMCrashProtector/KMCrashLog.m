//
//  KMCrashLog.m
//  GridGovernance
//
//  Created by Kami on 2017/12/15.
//  Copyright © 2017年 . All rights reserved.
//

#import "KMCrashLog.h"

static const NSString *KMCrashSeparatorWithFlag = @"KMCrashProtector - Debug";

static const NSString *KMCrashSeparatorWithFlag_R = @"KMCrashProtector - Release";


@implementation KMCrashLog

- (void)getCrashMsg{
#ifdef DEBUG
    NSLog(@"CrashProtector:  %@",_crashMsg);

#else
    NSAssert(0,@"CrashProtector:  %@",_crashMsg);
#endif
}

+ (void)printCrashMsg:(NSString *)crashMsg {
#ifdef DEBUG
    NSLog(@"\n*****************\n\nCrashProtector:  %@\n\n*****************\n",crashMsg);

#else
    NSAssert(0,@"\n*****************\n\nCrashProtector:  %@\n\n*****************\n",crashMsg);
#endif
}

+ (void)km_noteErrorWithException:(NSException *)exception attachedTODO:(NSString *)todo {
    
    // 堆栈数据
    NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
    
    //获取在哪个类的哪个方法中实例化的数组  字符串格式 -[类名 方法名]  或者 +[类名 方法名]
    NSString *mainCallStackSymbolMsg = [self _getMainCallStackSymbolMessageWithCallStackSymbolStr:callStackSymbolsArr[2]];
    
    if (mainCallStackSymbolMsg == nil) {
        mainCallStackSymbolMsg = @"崩溃方法定位失败,请您查看函数调用栈来排查错误原因";
    }
    
    NSString *crashType = [NSString stringWithFormat:@">>>[Crash Type]: %@",exception.name];
    NSString *errorReason = [NSString stringWithFormat:@">>>[Crash Reason]: %@",exception.reason];;
    NSString *errorPlace = [NSString stringWithFormat:@">>>[Error Place]: %@",mainCallStackSymbolMsg];
    NSString *crashProtector = [NSString stringWithFormat:@">>>[Attached TODO]: %@",todo];
    NSString *logErrorMessage = [NSString stringWithFormat:@"\n\n%@\n\n%@\n%@\n%@\n%@\n%@\n",KMCrashSeparatorWithFlag, crashType, errorReason, errorPlace, crashProtector, exception.callStackSymbols];
#ifdef DEBUG
    NSAssert(0,@"%@", logErrorMessage);

#else
    NSString *logAssertMessage = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n",KMCrashSeparatorWithFlag_R, crashType, errorReason, errorPlace, crashProtector, exception.callStackSymbols];
    NSAssert(0, logAssertMessage);
#endif
}

/**
 *  获取堆栈主要崩溃精简化的信息<根据正则表达式匹配出来>
 *
 *  @param callStackSymbolStr 堆栈主要崩溃信息
 *
 *  @return 堆栈主要崩溃精简化的信息
 */
+ (NSString *)_getMainCallStackSymbolMessageWithCallStackSymbolStr:(NSString *)callStackSymbolStr {
    
    //正则表达式
    //http://www.jianshu.com/p/b25b05ef170d
    
    //mainCallStackSymbolMsg的格式为   +[类名 方法名]  或者 -[类名 方法名]
    __block NSString *mainCallStackSymbolMsg = nil;
    
    //匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";

    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    [regularExp enumerateMatchesInString:callStackSymbolStr options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbolStr.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result) {
            mainCallStackSymbolMsg = [callStackSymbolStr substringWithRange:result.range];
            *stop = YES;
        }
    }];
    
    return mainCallStackSymbolMsg;
}

@end

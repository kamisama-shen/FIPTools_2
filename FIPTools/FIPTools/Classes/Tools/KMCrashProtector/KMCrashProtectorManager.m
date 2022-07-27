//
//  KMCrashProtectorManager.m
//  GridGovernance
//
//  Created by Kami on 2017/12/14.
//  Copyright © 2017年 . All rights reserved.
//

#import "KMCrashProtectorManager.h"
#import "NSObject+SelectorCrash.h"
#import "NSObject+KVOCrash.h"
#import "NSObject+NSNotificationCrash.h"
#import "NSTimer+Crash.h"
#import "NSArray+KMCrash.h"
#import "NSMutableArray+KMCrash.h"
#import "NSDictionary+KMCrash.h"
#import "NSMutableDictionary+KMCrash.h"
#import "NSString+KMCrash.h"
#import "NSMutableString+KMCrash.h"
#import "NSAttributedString+KMCrash.h"
#import "NSMutableAttributedString+KMCrash.h"
#import "UIControl+Click.h"

@implementation KMCrashProtectorManager

+ (void)makeAllEffective {
//#ifdef DEBUG
//
//#else
    [self _startAllComponents];
//#endif
}

+ (void)configCrashProtectorService:(KMCrashProtectorStyle)protectorType {
   
    switch (protectorType) {
        case KMCrashProtectorNone:
            
            break;
        case KMCrashProtectorAll:
        {
            [self _startAllComponents];
        }
            break;
        case KMCrashProtectorUnrecognizedSelector:
            [NSObject km_enableSelectorProtector];
            break;
        case KMCrashProtectorKVO:
            [NSObject km_enableKVOProtector];
            break;
        case KMCrashProtectorNotification:
            [NSObject km_enableNotificationProtector];
            break;
        case KMCrashProtectorTimer:
            [NSTimer km_enableTimerProtector];
            break;
        case KMCrashProtectorContainer: {
            [NSArray km_enableArrayProtector];
            [NSMutableArray km_enableMutableArrayProtector];
            
            [NSDictionary km_enableDictionaryProtector];
            [NSMutableDictionary km_enableMutableDictionaryProtector];
        }
            break;
        case KMCrashProtectorString: {
            [NSString km_enableStringProtector];
            [NSMutableString km_enableMutableStringProtector];
            
            [NSAttributedString km_enableAttributedStringProtector];
            [NSMutableAttributedString km_enableMutableAttributedStringProtector];
        }
            break;
            
        default:
            break;
    }
}

//+ (void)configCrashProtectorServices:(NSArray *)protectorTypes {
//    
//    for (NSNumber *numb in protectorTypes) {
//        
//        [self configCrashProtectorService:[numb integerValue]];
//    }
//}

+ (void)_startAllComponents {
//    [NSObject km_enableSelectorProtector];
//    [NSObject km_enableKVOProtector];
//    [NSObject km_enableNotificationProtector]; // 可能会有性能问题，dealloc里面加了判断，系统的每个对象dealloc时都会调用
    [UIControl kk_exchangeClickMethod];
    [NSTimer km_enableTimerProtector];
    [NSArray km_enableArrayProtector];
    [NSMutableArray km_enableMutableArrayProtector];
    
    [NSDictionary km_enableDictionaryProtector];
    [NSMutableDictionary km_enableMutableDictionaryProtector];
    
    [NSString km_enableStringProtector];
    [NSMutableString km_enableMutableStringProtector];
    
    [NSAttributedString km_enableAttributedStringProtector];
    [NSMutableAttributedString km_enableMutableAttributedStringProtector];
}

@end

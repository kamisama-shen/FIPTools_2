//
//  NSObject+NSNotificationCrash.m
//  GridGovernance
//
//  Created by Kami on 2017/12/15.
//  Copyright © 2017年 . All rights reserved.
//

#import "NSObject+NSNotificationCrash.h"
#import "NSObject+KMSwizzle.h"

static const char *isNSNotification = "isNSNotification";

@implementation NSObject (NSNotificationCrash)

+ (void)km_enableNotificationProtector {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //    [self swizzlingInstance:objc_getClass("NSNotificationCenter") orginalMethod:NSSelectorFromString(@"addObserver:selector:name:object:") replaceMethod:NSSelectorFromString(@"qiye_addObserver:selector:name:object:")];
        
        NSObject *objc = [[NSObject alloc] init];
        [objc km_instanceSwizzleMethod:@selector(addObserver:selector:name:object:) replaceMethod:@selector(km_addObserver:selector:name:object:)];
        
        // 在ARC环境下不能显示的@selector dealloc。
        [objc km_instanceSwizzleMethod:NSSelectorFromString(@"dealloc") replaceMethod:NSSelectorFromString(@"km_dealloc")];
    });
}

- (void)km_addObserver:(id)observer selector:(SEL)aSelector name:(nullable NSNotificationName)aName object:(nullable id)anObject
{
    [observer setIsNSNotification:YES];
    [self km_addObserver:observer selector:aSelector name:aName object:anObject];
}

- (void)setIsNSNotification:(BOOL)yesOrNo
{
    objc_setAssociatedObject(self, isNSNotification, @(yesOrNo), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isNSNotification
{
    NSNumber *number = objc_getAssociatedObject(self, isNSNotification);;
    return  [number boolValue];
}

/**
 如果一个对象从来没有添加过通知，那就不要remove操作
 */
- (void)km_dealloc
{
    if ([self isNSNotification]) {
        NSLog(@"CrashProtector: %@ is dealloc，but NSNotificationCenter Also exsit",self);
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    [self km_dealloc];
}


@end

//
//  NSAttributedString+KMCrash.m
//  GridGovernance
//
//  Created by Kami on 2017/12/21.
//  Copyright © 2017年 . All rights reserved.
//

#import "NSAttributedString+KMCrash.h"
#import "NSObject+KMSwizzle.h"

@implementation NSAttributedString (KMCrash)

+ (void)km_enableAttributedStringProtector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class NSConcreteAttributedString = NSClassFromString(@"NSConcreteAttributedString");
        
        //initWithString:
        [self km_instanceSwizzleMethodWithClass:NSConcreteAttributedString orginalMethod:@selector(initWithString:) replaceMethod:@selector(km_initWithString:)];
        //initWithAttributedString
        [self km_instanceSwizzleMethodWithClass:NSConcreteAttributedString orginalMethod:@selector(initWithAttributedString:) replaceMethod:@selector(km_initWithAttributedString:)];

        //initWithString:attributes:
        [self km_instanceSwizzleMethodWithClass:NSConcreteAttributedString orginalMethod:@selector(initWithString:attributes:) replaceMethod:@selector(km_initWithString:attributes:)];
    });
}

- (instancetype)km_initWithString:(NSString *)str {
    id object = nil;
    
    @try {
        object = [self km_initWithString:str];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:KMCrashDefaultReturnNil];
    }
    @finally {
        return object;
    }
}

#pragma mark - initWithAttributedString
- (instancetype)km_initWithAttributedString:(NSAttributedString *)attrStr {
    id object = nil;
    
    @try {
        object = [self km_initWithAttributedString:attrStr];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:KMCrashDefaultReturnNil];
    }
    @finally {
        return object;
    }
}

#pragma mark - initWithString:attributes:

- (instancetype)km_initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs {
    id object = nil;
    
    @try {
        object = [self km_initWithString:str attributes:attrs];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:KMCrashDefaultReturnNil];
    }
    @finally {
        return object;
    }
}

@end

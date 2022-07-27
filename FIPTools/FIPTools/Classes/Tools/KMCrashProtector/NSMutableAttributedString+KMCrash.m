//
//  NSMutableAttributedString+KMCrash.m
//  GridGovernance
//
//  Created by Kami on 2017/12/21.
//  Copyright © 2017年 . All rights reserved.
//

#import "NSMutableAttributedString+KMCrash.h"
#import "NSObject+KMSwizzle.h"

@implementation NSMutableAttributedString (KMCrash)

+ (void)km_enableMutableAttributedStringProtector {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class NSConcreteMutableAttributedString = NSClassFromString(@"NSConcreteMutableAttributedString");
        
        //initWithString:
        [self km_instanceSwizzleMethodWithClass:NSConcreteMutableAttributedString orginalMethod:@selector(initWithString:) replaceMethod:@selector(km_initWithString:)];

        //initWithString:attributes:
        [self km_instanceSwizzleMethodWithClass:NSConcreteMutableAttributedString orginalMethod:@selector(initWithString:attributes:) replaceMethod:@selector(km_initWithString:attributes:)];
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

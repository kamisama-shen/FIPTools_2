//
//  NSMutableDictionary+KMCrash.m
//  GridGovernance
//
//  Created by Kami on 2017/12/21.
//  Copyright © 2017年 . All rights reserved.
//

#import "NSMutableDictionary+KMCrash.h"
#import "NSObject+KMSwizzle.h"

@implementation NSMutableDictionary (KMCrash)

+ (void)km_enableMutableDictionaryProtector {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class dictionaryM = NSClassFromString(@"__NSDictionaryM");
        
        //setObject:forKey:
        [self km_instanceSwizzleMethodWithClass:dictionaryM orginalMethod:@selector(setObject:forKey:) replaceMethod:@selector(km_setObject:forKey:)];
        
        // iOS11
        [self km_instanceSwizzleMethodWithClass:dictionaryM orginalMethod:@selector(setObject:forKeyedSubscript:) replaceMethod:@selector(km_setObject:forKeyedSubscript:)];

        
        //removeObjectForKey:
        [self km_instanceSwizzleMethodWithClass:dictionaryM orginalMethod:@selector(removeObjectForKey:) replaceMethod:@selector(km_removeObjectForKey:)];

    });
}

- (void)km_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    
    @try {
        [self km_setObject:anObject forKey:aKey];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
    }
}

- (void)km_setObject:(id)anObject forKeyedSubscript:(id<NSCopying>)aKey {
    
    @try {
        [self km_setObject:anObject forKeyedSubscript:aKey];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
    }
}

- (void)km_removeObjectForKey:(id)aKey {
    
    @try {
        [self km_removeObjectForKey:aKey];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
    }
}

@end

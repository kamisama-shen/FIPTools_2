//
//  NSMutableArray+KMCrash.m
//  GridGovernance
//
//  Created by Kami on 2017/12/19.
//  Copyright © 2017年 . All rights reserved.
//

#import "NSMutableArray+KMCrash.h"
#import "NSObject+KMSwizzle.h"

@implementation NSMutableArray (KMCrash)

+ (void)km_enableMutableArrayProtector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //====================
        //   instance method
        //====================
        Class __NSArrayM = NSClassFromString(@"__NSArrayM");

        
        // objectAtIndex:
        [self km_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(objectAtIndex:) replaceMethod:@selector(km_objectAtIndex:)]; 
        
        [self km_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(objectAtIndexedSubscript:) replaceMethod:@selector(km_objectAtIndexedSubscript:)];

        //insertObject:atIndex:
        [self km_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(insertObject:atIndex:) replaceMethod:@selector(km_insertObject:atIndex:)];

        //removeObjectAtIndex:
        [self km_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(removeObjectAtIndex:) replaceMethod:@selector(km_removeObjectAtIndex:)];

        //setObject:atIndexedSubscript:
        [self km_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(setObject:atIndexedSubscript:) replaceMethod:@selector(km_setObject:atIndexedSubscript:)];

        [self km_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(getObjects:range:) replaceMethod:@selector(km_getObjects:range:)];

    });
}

- (id)km_objectAtIndex:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self km_objectAtIndex:index];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        return object;
    }
}

- (id)km_objectAtIndexedSubscript:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self km_objectAtIndex:index];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        return object;
    }
}

- (void)km_insertObject:(id)anObject atIndex:(NSUInteger)index {
    @try {
        [self km_insertObject:anObject atIndex:index];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
    }
}

- (void)km_removeObjectAtIndex:(NSUInteger)index {
    @try {
        [self km_removeObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
    }
}

- (void)km_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    @try {
        [self km_setObject:obj atIndexedSubscript:idx];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
    }
}

- (void)km_getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    @try {
        [self km_getObjects:objects range:range];
    } @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:@""];
    } @finally {
    }
}

@end

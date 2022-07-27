//
//  NSArray+DeepCopy.m
//  DLSmartInfo
//
//  Created by 赵彦超 on 2018/10/8.
//  Copyright © 2018年 DFITC. All rights reserved.
//

#import "NSArray+DeepCopy.h"
#import <objc/message.h>


@implementation NSArray (DeepCopy)


- (NSArray*)deepCopy {
    NSUInteger count = [self count];
    id cArray[count];
    
    for (NSUInteger i = 0; i < count; ++i) {
        id obj = [self objectAtIndex:i];
        if ([obj respondsToSelector:@selector(deepCopy)]) {
            cArray[i] = [obj deepCopy];
        }
        else if ([obj respondsToSelector:@selector(copyWithZone:)]) {
            cArray[i] = [obj copy];
        }
        else {
            NSLog(@"********Error:NSArray DeepCopy Failed!!! ********");
            return nil;
        }
    }
    
    NSArray *ret = [NSArray arrayWithObjects:cArray count:count];
    
    return ret;
}

- (NSMutableArray*)mutableDeepCopy {
    NSUInteger count = [self count];
    id cArray[count];
    
    for (NSUInteger i = 0; i < count; ++i) {
        id obj = [self objectAtIndex:i];
        
        // Try to do a deep mutable copy, if this object supports it
        if ([obj respondsToSelector:@selector(mutableDeepCopy)]) {
            cArray[i] = [obj mutableDeepCopy];
        }
        // Then try a shallow mutable copy, if the object supports that
        else if ([obj respondsToSelector:@selector(mutableCopyWithZone:)]) {
            cArray[i] = [obj mutableCopy];
        }
        else if ([obj respondsToSelector:@selector(copyWithZone:)]) {
            cArray[i] = [obj copy];
        }
        else {
            NSLog(@"********Error:NSArray MutableDeepCopy Failed!!! ********");
            return nil;
        }
    }
    
    NSMutableArray *ret = [NSMutableArray arrayWithObjects:cArray count:count];
    
    return ret;
}

@end

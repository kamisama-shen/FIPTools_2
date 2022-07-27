//
//  NSPointerArray+Extensions.m
//  DLSmartInfo
//
//  Created by 黄睿 on 2019/1/23.
//  Copyright © 2019 DFITC. All rights reserved.
//

#import "NSPointerArray+Extensions.h"

@implementation NSPointerArray (Helpers)

- (void)addObject:(id)object
{
    [self addPointer:(__bridge void *)object];
}

- (BOOL)containsObject:(id)object
{
    void * objPtr = (__bridge void *)object;
    for (NSUInteger i = 0; i < [self count]; i++) {
        void * ptr = [self pointerAtIndex:i];
        
        if (ptr == objPtr) {
            return YES;
        }
    }
    
    return NO;
}

- (void)removeObject:(id)object
{
    void * objPtr = (__bridge void *)object;
    NSUInteger objIndex = NSNotFound;
    for (NSUInteger i = 0; i < [self count]; i++) {
        void * ptr = [self pointerAtIndex:i];
        
        if (ptr == objPtr) {
            objIndex = i;
            break;
        }
    }
    
    if (objIndex != NSNotFound && objIndex < [self count]) {
        [self removePointerAtIndex:objIndex];
    }
}

- (void)removeAllNulls
{
    for (NSInteger i = [self count]-1; i>=0; --i) {
        if (![self pointerAtIndex:i]) { 
            [self removePointerAtIndex:i];
        }
    }
}

@end

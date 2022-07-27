//
//  NSMutableString+KMCrash.m
//  GridGovernance
//
//  Created by Kami on 2017/12/21.
//  Copyright © 2017年 . All rights reserved.
//

#import "NSMutableString+KMCrash.h"
#import "NSObject+KMSwizzle.h"

@implementation NSMutableString (KMCrash)

+ (void)km_enableMutableStringProtector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class __NSCFString = NSClassFromString(@"__NSCFString");
        
        //replaceCharactersInRange
        [self km_instanceSwizzleMethodWithClass:__NSCFString orginalMethod:@selector(replaceCharactersInRange:withString:) replaceMethod:@selector(km_replaceCharactersInRange:withString:)];
        
        //insertString:atIndex:
        [self km_instanceSwizzleMethodWithClass:__NSCFString orginalMethod:@selector(insertString:atIndex:) replaceMethod:@selector(km_insertString:atIndex:)];

        //deleteCharactersInRange
        [self km_instanceSwizzleMethodWithClass:__NSCFString orginalMethod:@selector(deleteCharactersInRange:) replaceMethod:@selector(km_deleteCharactersInRange:)];
    });
}

#pragma mark - replaceCharactersInRange
- (void)km_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    @try {
        [self km_replaceCharactersInRange:range withString:aString];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:KMCrashDefaultReturnIgnore];
    }
    @finally {
    }
}

#pragma mark - insertString:atIndex:
- (void)km_insertString:(NSString *)aString atIndex:(NSUInteger)loc {
    
    @try {
        [self km_insertString:aString atIndex:loc];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:KMCrashDefaultReturnIgnore];
    }
    @finally {
    }
}

#pragma mark - deleteCharactersInRange

- (void)km_deleteCharactersInRange:(NSRange)range {
    
    @try {
        [self km_deleteCharactersInRange:range];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:KMCrashDefaultReturnIgnore];
    }
    @finally {
    }
}

@end

//
//  NSString+KMCrash.m
//  GridGovernance
//
//  Created by Kami on 2017/12/21.
//  Copyright © 2017年 . All rights reserved.
//

#import "NSString+KMCrash.h"
#import "NSObject+KMSwizzle.h"

@implementation NSString (KMCrash)

+ (void)km_enableStringProtector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSCFConstantString = NSClassFromString(@"__NSCFConstantString");
        
        //substringFromIndex
        [self km_instanceSwizzleMethodWithClass:__NSCFConstantString orginalMethod:@selector(substringFromIndex:) replaceMethod:@selector(km_substringFromIndex:)];
        
        //substringToIndex
        [self km_instanceSwizzleMethodWithClass:__NSCFConstantString orginalMethod:@selector(substringToIndex:) replaceMethod:@selector(km_substringToIndex:)];
        
        //substringWithRange:
        [self km_instanceSwizzleMethodWithClass:__NSCFConstantString orginalMethod:@selector(substringWithRange:) replaceMethod:@selector(km_substringWithRange:)];
        
        //characterAtIndex
        [self km_instanceSwizzleMethodWithClass:__NSCFConstantString orginalMethod:@selector(characterAtIndex:) replaceMethod:@selector(km_characterAtIndex:)];
        
        /* 注意swizzling先后顺序 👇： */
        //stringByReplacingOccurrencesOfString:withString:options:range:
        [self km_instanceSwizzleMethodWithClass:__NSCFConstantString orginalMethod:@selector(stringByReplacingOccurrencesOfString:withString:options:range:) replaceMethod:@selector(km_stringByReplacingOccurrencesOfString:withString:options:range:)];

        //stringByReplacingCharactersInRange:withString:
        [self km_instanceSwizzleMethodWithClass:__NSCFConstantString orginalMethod:@selector(stringByReplacingCharactersInRange:withString:) replaceMethod:@selector(km_stringByReplacingCharactersInRange:withString:)];
    });
}

//=================================================================
//                           characterAtIndex:
//=================================================================
#pragma mark - characterAtIndex:

- (unichar)km_characterAtIndex:(NSUInteger)index {
    
    unichar characteristic;
    @try {
        characteristic = [self km_characterAtIndex:index];
    }
    @catch (NSException *exception) {
        
        NSString *defaultToDo = @"This framework default is to return a without assign unichar.";
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:defaultToDo];
    }
    @finally {
        return characteristic;
    }
}

#pragma mark - substringFromIndex:

- (NSString *)km_substringFromIndex:(NSUInteger)from {
    
    NSString *subString = nil;
    
    @try {
        subString = [self km_substringFromIndex:from];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:KMCrashDefaultReturnNil];
        subString = nil;
    }
    @finally {
        return subString;
    }
}

#pragma mark - substringToIndex
- (NSString *)km_substringToIndex:(NSUInteger)index {
    
    NSString *subString = nil;
    
    @try {
        subString = [self km_substringToIndex:index];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:KMCrashDefaultReturnNil];
        subString = nil;
    }
    @finally {
        return subString;
    }
}

#pragma mark - stringByReplacingCharactersInRange:withString:

- (NSString *)km_stringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement {
    
    NSString *newStr = nil;
    
    @try {
        newStr = [self km_stringByReplacingCharactersInRange:range withString:replacement];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:KMCrashDefaultReturnNil];
        newStr = nil;
    }
    @finally {
        return newStr;
    }
}

- (NSString *)km_stringByReplacingOccurrencesOfString:(NSRange)range withString:(NSString *)replacement {
    
    NSString *newStr = nil;
    
    @try {
        newStr = [self km_stringByReplacingOccurrencesOfString:range withString:replacement];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:KMCrashDefaultReturnNil];
        newStr = nil;
    }
    @finally {
        return newStr;
    }
}

#pragma mark - stringByReplacingOccurrencesOfString:withString:options:range:

- (NSString *)km_stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange {
    
    NSString *newStr = nil;
    
    @try {
        newStr = [self km_stringByReplacingOccurrencesOfString:target withString:replacement options:options range:searchRange];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:KMCrashDefaultReturnNil];
        newStr = nil;
    }
    @finally {
        return newStr;
    }
}

#pragma mark - substringWithRange:
- (NSString *)km_substringWithRange:(NSRange)range {
    
    NSString *subString = nil;
    
    @try {
        subString = [self km_substringWithRange:range];
    }
    @catch (NSException *exception) {
        [KMCrashLog km_noteErrorWithException:exception attachedTODO:KMCrashDefaultReturnNil];
        subString = nil;
    }
    @finally {
        return subString;
    }
}

@end

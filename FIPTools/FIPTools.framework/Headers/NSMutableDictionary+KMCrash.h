//
//  NSMutableDictionary+KMCrash.h
//  GridGovernance
//
//  Created by Kami on 2017/12/21.
//  Copyright © 2017年 . All rights reserved.
//

/**
 * setValue forKey 的值可设置nil，不会crash
 *
 *  Can avoid crash method
 *
 *  1. - (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
 *  2. - (void)removeObjectForKey:(id)aKey
 *
 */
#import <Foundation/Foundation.h>

@interface NSMutableDictionary (KMCrash)

+ (void)km_enableMutableDictionaryProtector;

@end

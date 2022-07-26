//
//  NSDictionary+KMCrash.h
//  GridGovernance
//
//  Created by Kami on 2017/12/21.
//  Copyright © 2017年 . All rights reserved.
//


/**
 *  Can avoid crash method
 *
 *  1. NSDictionary的快速创建方式 NSDictionary *dict = @{@"frameWork" : @"AvoidCrash"}; //这种创建方式其实调用的是2中的方法
 *  2. +(instancetype)dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt
 *
 */
#import <Foundation/Foundation.h>

@interface NSDictionary (KMCrash)

+ (void)km_enableDictionaryProtector;

@end

//
//  NSMutableAttributedString+KMCrash.h
//  GridGovernance
//
//  Created by Kami on 2017/12/21.
//  Copyright © 2017年 . All rights reserved.
//

/**
 *  Can avoid crash method
 *
 *  1.- (instancetype)initWithString:(NSString *)str
 *  2.- (instancetype)initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs
 */
#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (KMCrash)

+ (void)km_enableMutableAttributedStringProtector;

@end

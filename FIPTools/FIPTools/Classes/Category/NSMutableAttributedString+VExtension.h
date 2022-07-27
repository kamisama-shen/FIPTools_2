//
//  NSMutableAttributedString+VExtension.h
//  DLSmartInfo
//
//  Created by LYL on 2018/3/22.
//  Copyright © 2018年 DFITC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (VExtension)

+ (NSMutableAttributedString *)stringWithString:(NSString *)content
                                           font:(CGFloat)font
                                          color:(UIColor *)color;


/*
 content：内容
 font：字体大小
 color：字体颜色
 wordSpace：字间距
 lineSpace：行间距
 */
+ (NSMutableAttributedString *)stringWithString:(NSString *)content
                                           font:(CGFloat)font
                                          color:(UIColor *)color
                                      wordSpace:(CGFloat)wordSpace
                                      lineSpace:(CGFloat)lineSpace;

@end

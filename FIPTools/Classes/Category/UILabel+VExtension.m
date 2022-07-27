//
//  UILabel+VExtension.m
//  DLSmartInfo
//
//  Created by LYL on 2017/11/9.
//  Copyright © 2017年 DFITC. All rights reserved.
//

#import "UILabel+VExtension.h"

@implementation UILabel (VExtension)

+ (UILabel *)labelShortWithColor:(UIColor *)color font:(CGFloat)font {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.numberOfLines = 1;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

+ (UILabel *)labelLongWithColor:(UIColor *)color font:(CGFloat)font {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

@end

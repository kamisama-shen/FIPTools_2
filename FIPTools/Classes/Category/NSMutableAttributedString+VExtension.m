//
//  NSMutableAttributedString+VExtension.m
//  DLSmartInfo
//
//  Created by LYL on 2018/3/22.
//  Copyright © 2018年 DFITC. All rights reserved.
//

#import "NSMutableAttributedString+VExtension.h"

@implementation NSMutableAttributedString (VExtension)

+ (NSMutableAttributedString *)stringWithString:(NSString *)content
                                           font:(CGFloat)font
                                          color:(UIColor *)color{
    
    NSMutableDictionary *attDic = [NSMutableDictionary dictionary];
    [attDic setValue:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    [attDic setValue:color forKey:NSForegroundColorAttributeName];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:content attributes:attDic];
    
    return attStr;
    
}

+ (NSMutableAttributedString *)stringWithString:(NSString *)content
                                           font:(CGFloat)font
                                          color:(UIColor *)color
                                      wordSpace:(CGFloat)wordSpace
                                      lineSpace:(CGFloat)lineSpace {
    
    NSMutableDictionary *attDic = [NSMutableDictionary dictionary];
    [attDic setValue:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    [attDic setValue:color forKey:NSForegroundColorAttributeName];
    [attDic setValue:@(wordSpace) forKey:NSKernAttributeName];                               //字间距
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:content attributes:attDic];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpace;                                                              //行间距
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range: NSMakeRange(0, content.length)];
    
    return attStr;
}

@end

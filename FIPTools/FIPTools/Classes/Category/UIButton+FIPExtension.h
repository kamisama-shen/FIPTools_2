//
//  UIButton+FIPExtension.h
//  DLConjunctrueSDK
//
//  Created by kk on 2022/7/6.
//  Copyright © 2022 DFITC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MKButtonEdgeInsetsStyle) {
    MKButtonEdgeInsetsStyleTop, // image在上，label在下
    MKButtonEdgeInsetsStyleLeft, // image在左，label在右
    MKButtonEdgeInsetsStyleBottom, // image在下，label在上
    MKButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (FIPExtension)

/**
 * 快速生成一个项目风格化的按钮
 *
 * @param titleStr 按钮标题
 */
+ (UIButton *)loginButtonWithTitle:(NSString *)titleStr;

/**
 *  设置 button 的 titleLabel 和 imageView 的布局样式以及间距
 *
 *  @param style titleLabel 和 imageView 的布局样式
 *  @param space titleLabel 和 imageView 的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END

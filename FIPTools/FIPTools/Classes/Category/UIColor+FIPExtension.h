//
//  UIColor+FIPExtension.h
//  DLConjunctrueSDK
//
//  Created by kk on 2022/7/6.
//  Copyright © 2022 DFITC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (FIPExtension)

/**
 * 根据16进制颜色码来提供一个对应颜色
 *
 * @param hexString 16进制颜色码，不区分大小写，例如：‘#000000’ 或者 ‘0xFFFFFF’ 或者 ‘0Xffffff’ 或者 ‘333333’
 * @param alpha 透明度
 */
+ (UIColor *)fip_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 * 同上，兼容项目老版本
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END

//
//  UIImage+BSKit.h
//  StarterKit
//
//  Created by LYL on 15/10/8.
//  Copyright © 2015年 LYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface UIImage (BSKit)


/**
 * Apply the alpha to the current image, return the new image
 *
 */
- (UIImage *)bs_imageByApplyingAlpha:(CGFloat)alpha;


/**
 *  压缩图片至目标尺寸
 *
 *  @param defineWidth 图片最终尺寸的宽
 *
 *  @return 返回按照源图片的宽、高比压缩至目标宽、高的图片
 */
-(UIImage *)bs_imageByScalingToWidth:(CGFloat)defineWidth;


/**
 压缩图片至指定大小
 
 @param oraImage 原始图片
 @param kbytes 指定大小(单位是kb)
 @return 压缩后图片(NSData)
 */
+ (NSData *)compressOriginalImage:(UIImage *)oraImage toMaxDataSizeKBytes:(CGFloat)kbytes;

/**
 压缩图片至指定大小
 
 @param oraImage 原始图片
 @param kbytes 指定大小(单位是kb)
 @return 压缩后图片(UIImage)
 */
+ (UIImage *)compresOriginalImage:(UIImage *)oraImage toMaxDataSizeKBytes:(CGFloat)kbytes;



/**
 压缩图片至指定大小---压缩质量

 @param maxLength 大小（单位是kb）
 @return 二进制
 */
- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength ;

/*
 * 1.白色,参数:
 * 透明度 0~1,  0为白,   1为深灰色
 * 半径:默认30,推荐值 3   半径值越大越模糊 ,值越小越清楚
 * 色彩饱和度(浓度)因子:  0是黑白灰, 9是浓彩色, 1是原色  默认1.8
 * “彩度”，英文是称Saturation，即饱和度。将无彩色的黑白灰定为0，最鲜艳定为9s，这样大致分成十阶段，让数值和人的感官直觉一致。
 */
- (UIImage *)imgWithLightAlpha:(CGFloat)alpha radius:(CGFloat)radius colorSaturationFactor:(CGFloat)colorSaturationFactor;
- (UIImage *)imgWithBlur;


/**
 *  生成纯色navigationbar背景图片
 *
 *  @param color 颜色hex值
 *
 *  @return UIImage
 */
+ (UIImage *)bs_imageWithColor:(UIColor *)color;

/**
 *  使用imagewithcontentsoffile加载图片
 *  目的用于去缓存
 *
 *  @param name 图片名称
 *
 *  @return UIImage
 */
+ (UIImage *)bs_imageNamed:(NSString *)name;

/**
 *  生成纯色背景图片
 *
 *  @param color 背景颜色
 *  @param alpha 透明度
 *  @param size  图片尺寸
 *
 *  @return 纯色图片
 */
+ (UIImage *)bs_createPureColorImageWithColor:(UIColor *)color alpha:(CGFloat)alpha size:(CGSize)size;

/**
 *  截取view生成image
 *  可用于截屏
 *
 *  @param theView 源view
 *
 *  @return 返回图片
 */
+ (UIImage *)bs_imageFromView:(UIView *)theView;
+ (UIImage *)bs_imageFromView:(UIView *)view withFrame:(CGRect)rect;
/**
 *  拼接图片生成image
 *  可用于合成
 *
 *  @param images image数组
 *
 *  @return 返回图片
 */
+ (UIImage *)bs_composeWithImages:(NSArray <UIImage *>*)images;

/**
 *  拉伸图片
 *
 *  @param img     源图片
 *  @param fullSize 目标尺寸
 *
 *  @return 返回图片
 */
+ (UIImage *)bs_imageResize:(UIImage*)img toFullSize:(CGSize)fullSize;


/**
 *  重构图片
 *
 *  @param img      源图片
 *  @param fitSize 目标尺寸 （原图在中间，边缘填充透明）
 *
 *  @return 返回图片
 */
+ (UIImage *)bs_imageResize:(UIImage*)img toFitSize:(CGSize)fitSize;

/**
 *  修复图片90度转向问题
 */
+ (UIImage *)bs_fixOrientation:(UIImage *)aImage;

//  根据路径获取视频的第一帧图片
+ (UIImage*) getVideoPreViewImageWithVideoPath:(NSURL *)videoPath ;

//  按比例缩放,size 是你要把图显示到 多大区域
+ (UIImage *) imageCompressFitSizeScale:(UIImage *)sourceImage targetSize:(CGSize)size;

/** 截取WkwebView生成image,此方法截图webview必须设置frame，不能通过设置约束设置大小
 @param webView webview
 @param completionHandler 回调生成的image
 */
+ (void)bs_snapshotForWKWebView:(WKWebView *)webView withCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler;
@end

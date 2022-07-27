//
//  UIImage+BSKit.m
//  StarterKit
//
//  Created by LYL on 15/10/8.
//  Copyright © 2015年 LYL. All rights reserved.
//

#import "UIImage+BSKit.h"
#import <Accelerate/Accelerate.h>
#import <AVFoundation/AVFoundation.h>


@implementation UIImage (BSKit)


- (UIImage *)bs_imageByApplyingAlpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


-(UIImage *)bs_imageByScalingToWidth:(CGFloat)defineWidth {
    UIImage *sourceImage = self;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}





+ (NSData *)compressOriginalImage:(UIImage *)oraImage toMaxDataSizeKBytes:(CGFloat)kbytes
{
    
    //照片大小单位为字节（b）
    NSData * data = UIImageJPEGRepresentation(oraImage, 1.0);
    //kb
    CGFloat dataKBytes = data.length/1000.0;
    
    CGFloat maxQuality = 0.9f;
    
    CGFloat lastData = dataKBytes;
    
    while (dataKBytes > kbytes && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(oraImage, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    
    return data;
}


+ (UIImage *)compresOriginalImage:(UIImage *)oraImage toMaxDataSizeKBytes:(CGFloat)kbytes
{
    //照片大小单位为字节（b）
    NSData * data = UIImageJPEGRepresentation(oraImage, 1.0);
    //kb
    CGFloat dataKBytes = data.length/1000.0;
    
    CGFloat maxQuality = 0.9f;
    
    CGFloat lastData = dataKBytes;
    
    while (dataKBytes > kbytes && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(oraImage, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    
    return [UIImage imageWithData:data];
    
}

/**
 压缩图片至指定大小---压缩质量
 
 @param maxLength 大小（单位是kb）
 @return 二进制
 */
- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength  {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}

#pragma mark - 毛玻璃
- (UIImage *)imgWithBlur {
    return [self imgWithLightAlpha:0.1 radius:10 colorSaturationFactor:1];
}

- (UIImage *)imgWithLightAlpha:(CGFloat)alpha radius:(CGFloat)radius colorSaturationFactor:(CGFloat)colorSaturationFactor {
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:alpha];
    return [self imgBluredWithRadius:radius tintColor:tintColor saturationDeltaFactor:colorSaturationFactor maskImage:nil];
}

// 内部方法,核心代码,封装了毛玻璃效果 参数:半径,颜色,色彩饱和度
- (UIImage *)imgBluredWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage {
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (int32_t)radius, (int32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (int32_t)radius, (int32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (int32_t)radius, (int32_t)radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // 开启上下文 用于输出图像
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // 开始画底图
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // 开始画模糊效果
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // 添加颜色渲染
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // 输出成品,并关闭上下文
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}



+ (UIImage *)bs_imageWithColor:(UIColor *)color {
    CGSize size=CGSizeMake(1, 64);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage* img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

// 生成纯色背景图
+ (UIImage *)bs_createPureColorImageWithColor:(UIColor *)color alpha:(CGFloat)alpha size:(CGSize)size {
    // 纯色的UIView
    UIView *pureColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    pureColorView.backgroundColor = color;
    pureColorView.alpha = alpha;
    
    // 由上下文获取UIImage
    UIGraphicsBeginImageContext(size);
    [pureColorView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *pureColorImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return pureColorImage;
}

+ (UIImage *)bs_imageFromView:(UIView *)theView {
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, theView.opaque, 0);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
    
}
//截取WkwebView整个网页生成image
+ (void)bs_snapshotForWKWebView:(WKWebView *)webView withCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler
{
    UIView *snapshotView = [webView snapshotViewAfterScreenUpdates:YES];
    snapshotView.frame = webView.frame;
    [webView.superview addSubview:snapshotView];

    CGPoint currentOffset = webView.scrollView.contentOffset;
    CGRect currentFrame = webView.frame;
    UIView *currentSuperView = webView.superview;
    NSUInteger currentIndex = [webView.superview.subviews indexOfObject:webView];

    UIView *containerView = [[UIView alloc] initWithFrame:webView.bounds];
    [webView removeFromSuperview];
    [containerView addSubview:webView];

    CGSize totalSize = webView.scrollView.contentSize;
    NSInteger page;
    if (containerView.bounds.size.height == 0) {
        page = 1;
    }else{
        page = ceil(totalSize.height / containerView.bounds.size.height);
    }

    webView.scrollView.contentOffset = CGPointZero;
    webView.frame = CGRectMake(0, 0, containerView.bounds.size.width,webView.scrollView.contentSize.height);

    UIGraphicsBeginImageContextWithOptions(totalSize, YES, UIScreen.mainScreen.scale);
    [self bs_drawContentPage:containerView webView:webView index:0 maxIndex:page completion:^{
        UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        [webView removeFromSuperview];
        [currentSuperView insertSubview:webView atIndex:currentIndex];
        webView.frame = currentFrame;
        webView.scrollView.contentOffset = currentOffset;
        [snapshotView removeFromSuperview];
        [containerView removeFromSuperview];
        
        completionHandler(snapshotImage);
    }];
}
+ (void)bs_drawContentPage:(UIView *)targetView webView:(WKWebView *)webView index:(NSInteger)index maxIndex:(NSInteger)maxIndex completion:(dispatch_block_t)completion
{
    CGRect splitFrame = CGRectMake(0, index * CGRectGetHeight(targetView.bounds), targetView.bounds.size.width, targetView.frame.size.height);
    CGRect myFrame = webView.frame;
    myFrame.origin.y = -(index * targetView.frame.size.height);
    webView.frame = myFrame;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [targetView drawViewHierarchyInRect:splitFrame afterScreenUpdates:YES];

        if (index < maxIndex) {
            [self bs_drawContentPage:targetView webView:webView index:index + 1 maxIndex:maxIndex completion:completion];
        } else {
            completion();
        }
    });
}

+ (UIImage *)bs_imageFromView:(UIView *)view withFrame:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(rect.size, view.opaque, 0);

    UIImage* image = nil;
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
    
        {
            CGPoint savedContentOffset = scrollView.contentOffset;
            CGRect savedFrame = scrollView.frame;
            CGSize contentSize = scrollView.contentSize;
            CGRect oldBounds = scrollView.layer.bounds;
            if(@available(iOS 13.0, *)){
                //iOS 13 系统截屏需要改变tableview layer的bounds
                [scrollView.layer setBounds:CGRectMake(oldBounds.origin.x, oldBounds.origin.y,
                                                       contentSize.width, contentSize.height)];
            }
            scrollView.contentOffset = CGPointZero;
            scrollView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
            
            [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
            if(@available(iOS 13.0, *)){
                [scrollView.layer setBounds:oldBounds];
            }
            image = UIGraphicsGetImageFromCurrentImageContext();
            
            scrollView.contentOffset = savedContentOffset;
            scrollView.frame = savedFrame;
        }
        
    }else{
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
   UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)bs_composeWithImages:(NSArray <UIImage *>*)images{
    CGFloat height = 0;
    CGFloat width = 0;
    for (UIImage *img in images) {
        width = img.size.width;
        height +=img.size.height;
    }
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    CGFloat y = 0;
    for (UIImage *img in images) {
       CGFloat w = img.size.width;
       CGFloat h =img.size.height;
        [img drawInRect:CGRectMake(  0,
                                    y,
                                    w,
                                    h)];
        y += h;

    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)bs_imageResize:(UIImage*)img toFullSize:(CGSize)fullSize {
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(fullSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,fullSize.width,fullSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)bs_imageResize:(UIImage*)img tofitSize:(CGSize)fitSize zoom:(CGFloat)zoom {
    //新建上下文
    UIGraphicsBeginImageContextWithOptions(fitSize, NO, 0.0);
    
    //图片原本size
    CGSize size_orignal = img.size;
    CGFloat sizeW = size_orignal.width * zoom;
    CGFloat sizeH = size_orignal.height * zoom;
    CGFloat x = (fitSize.width - sizeW) *.5f;
    CGFloat y = (fitSize.height - sizeH) * .5f;
    CGRect rect = CGRectMake(x, y, sizeW, sizeH);
    
    [img drawInRect:rect];
    
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)bs_imageResize:(UIImage*)img toFitSize:(CGSize)fitSize {
    return [self bs_imageResize:img tofitSize:fitSize zoom:1];
}

+ (UIImage *)bs_fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


+ (UIImage *)bs_imageNamed:(NSString *)name {
    if ([UIImage imageNamed:name]) {
        return [UIImage imageNamed:name];
    }
    
    if (name.length == 0 || [name hasSuffix:@"/"]) return nil;
        
    CGFloat screenScale = [UIScreen mainScreen].scale;
    NSString *imageScale = nil;
    if (screenScale <= 1) {
        imageScale = @"";
    }else if (screenScale <= 2) {
        imageScale = @"@2x";
    } else {
        imageScale = @"@3x";
    }
    NSString *imageNamed = [NSString stringWithFormat:@"%@%@", name, imageScale];
    NSArray *exts = @[@"", @"png", @"jpeg", @"jpg", @"gif", @"webp", @"apng"];
    NSString *path = nil;
    for (NSString *e in exts) {
        path = [[NSBundle mainBundle] pathForResource:imageNamed ofType:e];
        if (path) break;
    }
    if (path.length == 0) return nil;
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data.length == 0) return nil;
    
    return [[UIImage alloc] initWithData:data scale:screenScale];
}

//  根据路径获取视频的第一帧图片
//+ (UIImage*) getVideoPreViewImageWithVideoPath:(NSURL *)videoPath
//{
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
//    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//    
//    gen.appliesPreferredTrackTransform = YES;
//    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
//    NSError *error = nil;
//    CMTime actualTime;
//    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
//    UIImage *img = [[UIImage alloc] initWithCGImage:image];
//    CGImageRelease(image);
//    
//    return img;
//}

+ (UIImage*) getVideoPreViewImageWithVideoPath:(NSURL *)videoPath {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(0.0, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

//按比例缩放,size 是你要把图显示到 多大区域
+ (UIImage *) imageCompressFitSizeScale:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

@end

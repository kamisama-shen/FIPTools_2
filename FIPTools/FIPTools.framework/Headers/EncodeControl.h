//
//  Encode.h
//  Base64+rc4
//
//  Created by han on 2017/8/24.
//  Copyright © 2017年 han. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
UIKIT_EXTERN NSString *const kSecretKey;
@interface EncodeControl : NSObject
//编码
+ (NSString *)encode:(NSString *)data;
//解码
+ (NSString *)decode:(NSString *)data;
+ (NSString *)encode:(NSString *)data key:(NSString *)key;
+ (NSString *)decode:(NSString *)data key:(NSString *)key;
/** 解密数据 */
+(NSDictionary *)convertDataToDic:(NSString *)data;
/** 加密数据 */
+(NSString *)encodeData:(NSDictionary *)data;

@end


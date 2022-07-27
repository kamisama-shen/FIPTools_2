//
//  NSString+VExtension.m
//  DLSmartInfo
//
//  Created by LYL on 2018/3/27.
//  Copyright © 2018年 DFITC. All rights reserved.
//

#import "NSString+VExtension.h"

@implementation NSString (VExtension)

- (NSString *)phoneNumSecretFormat {
    if (self.length == 11) {
        return [NSString stringWithFormat:@"%@*****%@",[self substringToIndex:3],[self substringFromIndex:8]];
    }else{
        return self;
    }
}


#pragma mark - 正则相关
- (BOOL)isValidateByRegex:(NSString *)regex{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

+(BOOL)isPhoneNumber:(NSString *)patternStr{
    
    NSString *pattern = @"^1[34578]\\d{9}$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+(BOOL)detectionIsEmailQualified:(NSString *)patternStr{
    
    NSString *pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+(BOOL)detectionIsIdCardNumberQualified:(NSString *)patternStr{
    NSString *pattern = @"^\\d{15}|\\d{18}$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}
//%、#、！、*、-
+(BOOL)detectionIsPasswordQualified:(NSString *)patternStr{
//    NSString *pattern = @"^[a-zA-Z]\\w.{5,19}$";
    NSString *pattern = @"^[a-zA-Z0-9%#*！!-]{6,20}$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+ (BOOL)detectionIsIPAddress:(NSString *)patternStr
{
    
    NSString *pattern = @"((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+(BOOL)detectionIsAllNumber:(NSString *)patternStr{
    NSString *pattern = @"^[0-9]*$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+(BOOL)detectionIsEnglishAlphabet:(NSString *)patternStr{
    NSString *pattern = @"^[A-Za-z]+$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+(BOOL)detectionIsUrl:(NSString *)patternStr{
    NSString *pattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}
+(BOOL)detectionIsChinese:(NSString *)patternStr{
    NSString *pattern = @"[\u4e00-\u9fa5]+";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+(BOOL)detectionNormalText:(NSString *)normalStr WithHighLightText:(NSString *)HighLightStr{
    
    NSString *pattern = [NSString stringWithFormat:@"%@",HighLightStr];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:normalStr options:0 range:NSMakeRange(0, normalStr.length)];
    for (NSTextCheckingResult *resltText in results) {
        NSLog(@"----------------%zd",resltText.range.length);
    }
    return results.count > 0;
}


#pragma mark -

//此方法跟OTCDelivery库里的NSString分类方法重名，导致调用到了那个分类的方法，那个方法内就是注释掉的正则。
//手机号分服务商
- (BOOL)isMobileNumberClassification{

//    NSString * PHS = @"^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}$";
//
//    if ([self isValidateByRegex:PHS]){
//        return YES;
//    }else{
//        return NO;
//    }
    if (self.length >= 6) {
        return YES;
    }else {
        return NO;
    }
}

// 转码，中文
- (NSString *)encodeWithAllCharacter {
//    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"`#%^{}[]|\"<> "];
//    NSString *string = [self stringByAddingPercentEncodingWithAllowedCharacters:[characterSet invertedSet]];
    
    NSCharacterSet *characterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *string = [self stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
    
    return string;
}

@end

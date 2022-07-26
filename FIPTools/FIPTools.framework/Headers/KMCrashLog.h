//
//  KMCrashLog.h
//  GridGovernance
//
//  Created by Kami on 2017/12/15.
//  Copyright © 2017年 . All rights reserved.
//

#import <Foundation/Foundation.h>

//user can ignore below define
static NSString * _Nullable KMCrashDefaultReturnNil = @"This framework default is to return nil to avoid crash.";
static NSString * _Nullable KMCrashDefaultReturnIgnore  = @"This framework default is to ignore this operation to avoid crash.";

@interface KMCrashLog : NSObject

@property (nonatomic,copy) NSString * _Nullable crashMsg;

- (void)getCrashMsg;

+ (void)printCrashMsg:(NSString *_Nullable)crashMsg;

+ (void)km_noteErrorWithException:(NSException *_Nonnull)exception attachedTODO:(NSString *_Nullable)todo;

@end

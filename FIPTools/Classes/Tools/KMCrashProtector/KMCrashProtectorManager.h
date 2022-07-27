//
//  KMCrashProtectorManager.h
//  GridGovernance
//
//  Created by Kami on 2017/12/14.
//  Copyright © 2017年 . All rights reserved.
//

/**
 ** 建议实际开发的时候关闭该组件，以便及时发现crash bug，需要上架或者演示的时候开启crash防护组件。 **
 *  该组件会占用一定内存，不过正常情况下不影响性能
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KMCrashProtectorStyle) {
    KMCrashProtectorNone = 0,
    KMCrashProtectorAll ,
    KMCrashProtectorUnrecognizedSelector,
    KMCrashProtectorKVO ,
    KMCrashProtectorNotification ,
    KMCrashProtectorTimer ,
    KMCrashProtectorContainer ,
    KMCrashProtectorString ,
};

@interface KMCrashProtectorManager : NSObject

@property(nonatomic,assign) KMCrashProtectorStyle style;


/**
 启动所有组件
 */
+ (void)makeAllEffective;


/**
 单独启动组件

 @param protectorType 启动的组件类型
 */
+ (void)configCrashProtectorService:(KMCrashProtectorStyle)protectorType;



/**
 启动一组组件

 @param protectorTypes 启动的组件类型数组
 */
//+ (void)configCrashProtectorServices:(NSArray *)protectorTypes;

@end

//
//  NSObject+KVOCrash.h
//  GridGovernance
//
//  Created by Kami on 2017/12/14.
//  Copyright © 2017年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@class WOCPKVOInfo;

typedef void (^WOCPKVONotificationBlock)(id _Nullable observer, id _Nullable object, NSDictionary<NSKeyValueChangeKey, id> * _Nullable change);
/**
 KVO的管理者
 KVO Crash fix
 */
@interface KVOProxy :NSObject

- (BOOL)km_addObserver:(id _Nullable )object KVOinfo:(WOCPKVOInfo *_Nullable)KVOInfo;

- (void)km_removeObserver:(id _Nullable )object keyPath:(NSString *_Nullable)keyPath block:(void(^_Nullable)(void)) block;

- (void)km_removeAllObserver;

@end


/**
 KVO配置层
 */
@interface WOCPKVOInfo : NSObject

- (instancetype _Nullable )initWithKeyPath:(NSString *_Nullable)keyPath options:(NSKeyValueObservingOptions)options context:(void *_Nullable)context;

@end

@interface NSObject (KVOCrash)

@property (nonatomic, strong) KVOProxy * _Nullable KVOProxy;

+ (void)km_enableKVOProtector;

@end

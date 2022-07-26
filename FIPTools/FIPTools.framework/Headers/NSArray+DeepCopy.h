//
//  NSArray+DeepCopy.h
//  DLSmartInfo
//
//  Created by 赵彦超 on 2018/10/8.
//  Copyright © 2018年 DFITC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (DeepCopy)

- (NSArray*)deepCopy;
- (NSMutableArray*) mutableDeepCopy;

@end

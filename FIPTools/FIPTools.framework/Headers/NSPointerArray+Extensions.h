//
//  NSPointerArray+Extensions.h
//  DLSmartInfo
//
//  Created by 黄睿 on 2019/1/23.
//  Copyright © 2019 DFITC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSPointerArray (Helpers)

- (void)addObject:(id)object;

- (BOOL)containsObject:(id)object;

- (void)removeObject:(id)object;

- (void)removeAllNulls;

@end

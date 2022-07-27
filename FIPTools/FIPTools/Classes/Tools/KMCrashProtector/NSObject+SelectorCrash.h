//
//  NSObject+SelectorCrash.h
//  GridGovernance
//
//  Created by Kami on 2017/12/14.
//  Copyright © 2017年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOUnrecognizedSelectorSolveObject : NSObject

@property (nonatomic, weak) NSObject *objc;

@end

@interface NSObject (SelectorCrash)

+ (void)km_enableSelectorProtector;

@end

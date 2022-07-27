//
//  NSObject+LSDefaults.m
//  DLSmartInfo
//
//  Created by zhaoyanchao on 2019/12/2.
//  Copyright © 2019 DFITC. All rights reserved.
//

#import "NSObject+LSDefaults.h"
#import <objc/runtime.h>


@implementation NSObject (LSDefaults)


+ (void)load {
    
    SEL originalSelector = @selector(doesNotRecognizeSelector:);
    SEL swizzledSelector = @selector(sw_doesNotRecognizeSelector:);
    
    Method originalMethod = class_getClassMethod(self, originalSelector);
    Method swizzledMethod = class_getClassMethod(self, swizzledSelector);
    
    /*
     * OBJC_EXPORT BOOL class_addMethod(Class _Nullable cls, SEL _Nonnull name, IMP _Nonnull imp,  const char * _Nullable types)
     * 向具有给定名称和实现的类中添加新方法。
     * @param cls   要向其添加方法的类。
     * @param name  一个选择器，用于指定要添加的方法的名称。
     * @param imp   一个函数，它是新方法的实现。 该函数必须至少包含两个参数-self和_cmd。
     * @param types 一个字符数组，描述方法参数的类型。
     * @return      如果成功添加方法则为YES，否则为NO（例如，该类已经包含具有该名称的方法实现）。
     * @note        class_addMethod将添加超类实现的替代，但不会替代此类中的现有实现。要更改现有的实现， 请使用method_setImplementation。
     */
    if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
       /*
        * OBJC_EXPORT IMP _Nullable class_replaceMethod(Class _Nullable cls, SEL _Nonnull name, IMP _Nonnull imp, const char * _Nullable types)
        * 替换给定类的方法的实现。
        * @param cls   您要修改的类。
        * @param name  一个选择器，用于标识要替换其实现的方法。
        * @param imp   由cls标识的类的名称标识的方法的新实现。
        * @param types 一个字符数组，描述方法参数的类型。由于该函数必须至少接受两个参数-self和_cmd，所以第二个和第三个字符，必须为“ @：”（第一个字符为返回类型）。
        * @return
        */
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
 
+ (void)sw_doesNotRecognizeSelector:(SEL)aSelector {
    // 处理 _LSDefaults 崩溃问题
    if ([[self description] isEqualToString:@"_LSDefaults"] && (aSelector == NSSelectorFromString(@"sharedInstance"))) {
        return;
    }
    [self sw_doesNotRecognizeSelector:aSelector];
}

@end

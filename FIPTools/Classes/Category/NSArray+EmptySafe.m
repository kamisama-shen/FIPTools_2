//
//  NSArray+EmptySafe.m
//  DLSmartInfo
//
//  Created by 赵彦超 on 2018/10/8.
//  Copyright © 2018年 DFITC. All rights reserved.
//

#import "NSArray+EmptySafe.h"
#import <objc/runtime.h>


@implementation NSObject (Swizzling)
#ifdef DEBUG
#else
+ (BOOL)gl_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel {
    Method origMethod = class_getInstanceMethod(self, origSel);
    Method altMethod = class_getInstanceMethod(self, altSel);
    if (!origMethod || !altMethod) {
        return NO;
    }
    class_addMethod(self,
                    origSel,
                    class_getMethodImplementation(self, origSel),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel,
                    class_getMethodImplementation(self, altSel),
                    method_getTypeEncoding(altMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, origSel),
                                   class_getInstanceMethod(self, altSel));
    return YES;
}

+ (BOOL)gl_swizzleClassMethod:(SEL)origSel withMethod:(SEL)altSel {
    return [object_getClass((id)self) gl_swizzleMethod:origSel withMethod:altSel];
}
#endif
@end


@implementation NSArray (EmptySafe)
#ifdef DEBUG
#else

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // NSArray 是一个类簇,具体有三个子类__NSArray0,__NSSingleObjectArrayI,__NSArrayI,
        // 还有一个__NSPlaceholderArray是占位的,不实际使用
        
        // 对__NSArray0,__NSSingleObjectArrayI来说,下面三种调用的同一个方法objectAtIndex
        
        /** 对__NSArrayI,__NSArrayM来说,objectAtIndex 和 objectAtIndexedSubscript 有不同的实现,
         array[22]调用了objectAtIndexedSubscript */
        //        [array objectAtIndex:22];
        //        [array objectAtIndexedSubscript:22];
        //        array[22];
        
        [objc_getClass("__NSPlaceholderArray") gl_swizzleMethod:@selector(addObject:) withMethod:@selector(safeAddObject:)];
        [objc_getClass("__NSPlaceholderArray") gl_swizzleMethod:@selector(insertObject:atIndex:) withMethod:@selector(safeInsertObject:atIndex:)];

        [objc_getClass("__NSArray0") gl_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(emptyObjectIndex:)];
        [objc_getClass("__NSSingleObjectArrayI") gl_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(singleObjectIndex:)];
        
        [objc_getClass("__NSArrayI") gl_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safe_arrObjectIndex:)];
        [objc_getClass("__NSArrayI") gl_swizzleMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(safe_objectAtIndexedSubscript:)];
        
        
        [objc_getClass("__NSArrayM") gl_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safeObjectIndex:)];
        [objc_getClass("__NSArrayM") gl_swizzleMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(mutableArray_safe_objectAtIndexedSubscript:)];
        
        [objc_getClass("__NSArrayM") gl_swizzleMethod:@selector(insertObject:atIndex:) withMethod:@selector(safeInsertObject:atIndex:)];
        [objc_getClass("__NSArrayM") gl_swizzleMethod:@selector(addObject:) withMethod:@selector(safeAddObject:)];
        
        
    });
    
}


- (id)emptyObjectIndex:(NSInteger)index {
    NSLog(@"__NSArray0 取一个空数组 objectAtIndex , 崩溃") ;
    return nil;
}


- (id)singleObjectIndex:(NSInteger)index {
    if (index >= self.count || index < 0) {
        NSLog(@"__NSSingleObjectArrayI 取一个不可变单元素数组时越界 objectAtIndex , 崩溃") ;
        return nil;
    }
    return [self singleObjectIndex:index];
}


- (id)safe_arrObjectIndex:(NSInteger)index{
    
    if (index >= self.count || index < 0) {
        NSLog(@"__NSArrayI 取不可变数组时越界 objectAtIndex , 崩溃") ;
        return nil;
    }
    return [self safe_arrObjectIndex:index];
    
}


- (id)safe_objectAtIndexedSubscript:(NSInteger)index{
    
    if (index >= self.count || index < 0) {
        NSLog(@"__NSArrayI 取不可变数组时越界 objectAtIndexedSubscript , 崩溃") ;
        return nil;
    }
    return [self safe_objectAtIndexedSubscript:index];
    
}


- (id)mutableArray_safe_objectAtIndexedSubscript:(NSInteger)index{
    
    if (index >= self.count || index < 0) {
        NSLog(@"__NSArrayM 取可变数组时越界 objectAtIndexedSubscript , 崩溃") ;
        return nil;
    }
    return [self mutableArray_safe_objectAtIndexedSubscript:index];
    
}


- (id)safeObjectIndex:(NSInteger)index{
    
    if (index >= self.count || index < 0) {
        NSLog(@"__NSArrayM 取可变数组时越界 objectAtIndex , 崩溃") ;
        return nil;
    }
    return [self safeObjectIndex:index];
    
}


- (void)safeInsertObject:(id)object atIndex:(NSUInteger)index{
    
    if (index>self.count) {
        NSLog(@"__NSArrayM 添加元素越界 insertObject:atIndex: , 崩溃") ;
        return ;
    }
    if (object == nil) {
        NSLog(@"__NSArrayM 添加空元素 insertObject:atIndex: , 崩溃") ;
        return ;
    }
    
    [self safeInsertObject:object atIndex:index];
    
}


- (void)safeAddObject:(id)object {
    
    if (object == nil) {
        NSLog(@"__NSArrayM 添加空元素 addObject , 崩溃") ;
        return ;
    }
    
    [self safeAddObject:object];
    
}
#endif

@end

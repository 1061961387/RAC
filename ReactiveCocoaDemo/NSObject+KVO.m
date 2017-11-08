//
//  NSObject+KVO.m
//  ReactiveCocoaDemo
//
//  Created by 裕福 on 2017/11/8.
//  Copyright © 2017年 裕福. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/message.h>

@implementation NSObject (KVO)

-(void)WN_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    //1、创建子类
    NSString *oldName = NSStringFromClass([self class]);
    NSString *newName = [NSString stringWithFormat:@"WNKVO_%@",oldName];
    Class newClass = objc_allocateClassPair([self class], newName.UTF8String, 0);
    //2、注册子类
    objc_registerClassPair(newClass);
    //3、改变方法调用者的类型为子类
    object_setClass(self, newClass);
    //4、重写父类方法
    class_addMethod([self class], @selector(setName:), (IMP)setName, "");
    //5、绑定属性
    objc_setAssociatedObject(self, @"wn", observer, OBJC_ASSOCIATION_ASSIGN);
}

void setName(id self,SEL _cmd,NSString *newName){
    //1、保存子类
    id class = [self class];
    //2、获得观察者
    NSLog(@"self = %@",[self class]);
    id observer = objc_getAssociatedObject(self, @"wn");
    NSLog(@"observer = %@",observer);
    //3、改变方法调用者的类型为父类
    object_setClass(self, class_getSuperclass([self class]));
    
    NSLog(@"self1 = %@",[self class]);
    id observer1 = objc_getAssociatedObject(self, @"wn");
    NSLog(@"observer1 = %@",observer1);
    //4、调用父类set方法
    objc_msgSend(self, @selector(setName:),newName);
    
    //5、观察者发送观察消息
    objc_msgSend(observer, @selector(WN_observeValueForKeyPath:ofObject:change:context:),@"name",self,@{@"new":newName},nil);
    
    //6、再次改变方法调用者的类型为子类
    object_setClass(self, class);
}

@end

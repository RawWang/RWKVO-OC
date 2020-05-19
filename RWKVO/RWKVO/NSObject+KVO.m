//
//  NSObject+KVO.m
//  KVO
//
//  Created by Raw on 2018/5/19.
//  Copyright © 2018 Raw. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (KVO)

- (void)RW_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath callback:(KVOCallback)callback {
    Class class = object_getClass(self);
    NSString *className = NSStringFromClass(class);

    Class kvoClass = nil;
    //创建子类
    if (![className hasPrefix:@"RWKVO_"]) {
        //定义类的派生类的名字
        NSString *oldClassName = NSStringFromClass([self class]);
        NSString *newClassName = [@"RWKVO_" stringByAppendingString:oldClassName];

        //创建子类
        kvoClass = objc_allocateClassPair(self.class, newClassName.UTF8String, 0);

        //重写class方法，修改isa指针
        object_setClass(self, kvoClass);

        //注册子类
        objc_registerClassPair(kvoClass);
        
        //添加setter方法
        class_addMethod(kvoClass, [self setterSEL:keyPath], (IMP)rw_setterWithCallback, "v@:@");
    }
    

    //添加多个观察者到观察者列表中
    RWObserverInfo *info = [[RWObserverInfo alloc] initWithObserver:observer keyPath:keyPath callback:callback];
    NSMutableArray *observers = objc_getAssociatedObject(self, @"observer");

    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void *)@"observer", observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    [observers addObject:info];

}

- (void)RW_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {
    //定义类的派生类的名字
    NSString *oldClassName = NSStringFromClass([self class]);
    NSString *newClassName = [@"RWKVO_" stringByAppendingString:oldClassName];
    
    //创建子类
    Class kvoClass = objc_allocateClassPair(self.class, newClassName.UTF8String, 0);
    
    //添加setter方法
    class_addMethod(kvoClass, [self setterSEL:keyPath], (IMP)rw_setter, "v@:@");
    
    //重写class方法，修改isa指针
    object_setClass(self, kvoClass);
    
    //注册子类
    objc_registerClassPair(kvoClass);
    
    //保存观察者属性到子类中
    objc_setAssociatedObject(self, (__bridge const void *)@"observer", observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//重写父类Setter方法
void rw_setterWithCallback(id self, SEL _cmd, NSString *name) {
    // 保存当前KVO的类
    Class kvoClass = [self class];

    // 将self的isa指针指向父类Person，调用父类setter方法
    object_setClass(self, [self superclass]);

    //调用父类的getter方法获取变量值
    NSString *oldValue = objc_msgSend(self, [self getterSEL:_cmd]);
    
    //调用父类setter方法，重新给变量赋值
    objc_msgSend(self, _cmd, name);

    //找出观察者的数组, 调用对应对象的callback
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)@"observer");
    for (RWObserverInfo *info in observers) {
        //异步调用callback
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            info.callback(info.observer, info.keyPath, oldValue, name);
        });
    }

    // 重新修改为RWKVO_Person类
    object_setClass(self, kvoClass);
}

//重写父类Setter方法
void rw_setter(id self, SEL _cmd, NSString *name) {
    // 保存当前KVO的类
    Class kvoClass = [self class];
    
    // 将self的isa指针指向父类Person，调用父类setter方法
    object_setClass(self, [self superclass]);
    
    //调用父类的getter方法获取变量值
    NSString *oldValue = objc_msgSend(self, [self getterSEL:_cmd]);
    
    // 调用父类setter方法，重新给变量赋值
    objc_msgSend(self, _cmd, name);
    
    // 取出RWKVO_Person观察者
    id objc = objc_getAssociatedObject(self, (__bridge const void *)@"observer");

    //组装数据格式
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:1],@"kind", name, @"new", oldValue, @"old", nil];
    
    // 通知观察者，执行通知方法
    objc_msgSend(objc, @selector(observeValueForKeyPath:ofObject:change:context:), @"name", self, dic, nil);
    
    // 重新修改为RWKVO_Person类
    object_setClass(self, kvoClass);
}


#pragma mark - 私有方法
// name -> Name -> setName:
- (SEL)setterSEL:(NSString *)keyPath {
    return NSSelectorFromString([NSString stringWithFormat:@"set%@:", [keyPath capitalizedString]]);
}

// setName: -> Name -> name
- (SEL)getterSEL:(SEL)cmd {
    NSString *tmp = NSStringFromSelector(cmd);
    tmp = [tmp substringFromIndex:3];
    tmp = [tmp substringToIndex:tmp.length - 1];
    return NSSelectorFromString([tmp lowercaseString]);
}


@end

//
//  NSObject+KVO.h
//  KVO
//
//  Created by Raw on 2018/5/19.
//  Copyright © 2018 Raw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWObserverInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KVO)

- (void)RW_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;

- (void)RW_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath callback:(KVOCallback)callback;

@end

NS_ASSUME_NONNULL_END

//
//  RWKVOCallback.h
//  KVO
//
//  Created by Raw on 2018/5/19.
//  Copyright © 2018 Raw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^KVOCallback)(id observer, NSString *key, id oldValue, id newValue);

@interface RWObserverInfo : NSObject

//监听者
@property (nonatomic, weak) id observer;

//被监听的属性
@property (nonatomic, copy) NSString *keyPath;

//监听回调Block
@property (nonatomic, copy) KVOCallback callback;

- (instancetype)initWithObserver:(id)observer keyPath:(NSString *)keyPath callback:(KVOCallback)callback;

@end



NS_ASSUME_NONNULL_END

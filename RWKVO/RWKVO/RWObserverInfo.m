//
//  RWKVOCallback.m
//  KVO
//
//  Created by Raw on 2018/5/19.
//  Copyright © 2018 Raw. All rights reserved.
//

#import "RWObserverInfo.h"

@implementation RWObserverInfo

- (instancetype)initWithObserver:(id)observer keyPath:(NSString *)keyPath callback:(KVOCallback)callback {
    if (self = [super init]) {
        _observer = observer;
        _keyPath = keyPath;
        _callback = callback;
    }
    
    return self;
}


@end

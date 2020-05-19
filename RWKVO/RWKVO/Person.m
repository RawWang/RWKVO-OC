//
//  Person.m
//  KVO
//
//  Created by Raw on 2018/5/19.
//  Copyright © 2018 Raw. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)init
{
    self = [super init];
    if (self) {
        _age = @"18";
        _gender = @"Male";
        _name = @"Tom";
    }
    return self;
}

@end

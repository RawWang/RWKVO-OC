//
//  ViewController.m
//  KVO
//
//  Created by Raw on 2018/5/19.
//  Copyright © 2018 Raw. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+KVO.h"

@interface ViewController ()

@property(strong) Person *person;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.person = [Person new];
        
    [self.person RW_addObserver:self forKeyPath:@"age" callback:^(id  _Nonnull observer, NSString * _Nonnull key, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSLog(@"key: %@, oldValue: %@, newValue: %@", key, oldValue, newValue);
    }];

    [self.person RW_addObserver:self forKeyPath:@"gender" callback:^(id  _Nonnull observer, NSString * _Nonnull key, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSLog(@"key: %@, oldValue: %@, newValue: %@", key, oldValue, newValue);
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.person setGender:@"Female"];
    [self.person setAge:@"20"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"%@", change);
}

- (void)dealloc{
    [self.person removeObserver:self forKeyPath:@"name"];
}

@end

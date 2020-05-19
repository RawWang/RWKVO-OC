# 手动实现KVO

```Objective C 
- (void)RW_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;
```
调用方式
```Objective C 
#import "NSObject+KVO.h"

[self.person RW_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"%@", change);
}
```


# 实现带有Block的KVO

```Objective C 
- (void)RW_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath callback:(KVOCallback)callback;
```
调用方式
```Objective C 
#import "NSObject+KVO.h"

[self.person RW_addObserver:self forKeyPath:@"age" callback:^(id  _Nonnull observer, NSString * _Nonnull key, id  _Nonnull oldValue, id  _Nonnull newValue) {
    NSLog(@"key: %@, oldValue: %@, newValue: %@", key, oldValue, newValue);
}];

[self.person RW_addObserver:self forKeyPath:@"gender" callback:^(id  _Nonnull observer, NSString * _Nonnull key, id  _Nonnull oldValue, id  _Nonnull newValue) {
   NSLog(@"key: %@, oldValue: %@, newValue: %@", key, oldValue, newValue);
}];
```

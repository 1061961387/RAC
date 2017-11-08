//
//  NSObject+WNKeyValueObserving.h
//  ReactiveCocoaDemo
//
//  Created by 裕福 on 2017/11/8.
//  Copyright © 2017年 裕福. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WNKeyValueObserving)

- (void)WN_observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context;

@end

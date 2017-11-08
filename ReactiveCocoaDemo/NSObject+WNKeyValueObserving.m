//
//  NSObject+WNKeyValueObserving.m
//  ReactiveCocoaDemo
//
//  Created by 裕福 on 2017/11/8.
//  Copyright © 2017年 裕福. All rights reserved.
//

#import "NSObject+WNKeyValueObserving.h"

@implementation NSObject (WNKeyValueObserving)

- (void)WN_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    [self doesNotRecognizeSelector:_cmd];
}
@end

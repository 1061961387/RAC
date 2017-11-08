//
//  NSObject+KVO.h
//  ReactiveCocoaDemo
//
//  Created by 裕福 on 2017/11/8.
//  Copyright © 2017年 裕福. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+WNKeyValueObserving.h"

@interface NSObject (KVO)

- (void)WN_addObserver:(NSObject *_Nullable)observer forKeyPath:(NSString *_Nonnull)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;

@end

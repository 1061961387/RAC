//
//  BlockTest.m
//  ReactiveCocoaDemo
//
//  Created by 裕福 on 2017/8/25.
//  Copyright © 2017年 裕福. All rights reserved.
//

#import "BlockTest.h"

@implementation BlockTest

+ (void)load
{
//    foo_();
}

void foo_(){
    int i = 2;
    NSNumber *num = @3;
    
    long (^myBlock)(void) = ^long() {
        return i * num.intValue;
    };
    
    long r = myBlock();
    NSLog(@"%ld",r);
}

@end

//
//  Caculator.m
//  RAC
//
//  Created by 裕福 on 2017/6/28.
//  Copyright © 2017年 裕福. All rights reserved.
//

#import "Caculator.h"

@implementation Caculator

- (Caculator *)caculator:(int (^)(int))caculator
{
    NSLog(@"caculator 0 self.result = %d",self.result);
    _result = caculator(_result);
    NSLog(@"caculator 3 self.result = %d",self.result);
    return self;
}

- (Caculator *)equle:(BOOL (^)(int result))operation{
    NSLog(@"caculator 4 self.result = %d",self.result);
    _isEqule = operation(_result);
    NSLog(@"caculator 6 self.result = %d",self.result);
    return self;
}

@end

//
//  HKView.m
//  ReactiveCocoaDemo
//
//  Created by 裕福 on 2017/11/6.
//  Copyright © 2017年 裕福. All rights reserved.
//

#import "HKView.h"

@implementation HKView

- (RACSubject *)btnClickSignal
{
    if (!_btnClickSignal) {
        _btnClickSignal = [RACSubject subject];
    }
    return _btnClickSignal;
}

- (IBAction)btnClick:(id)sender{
    [self.btnClickSignal sendNext:self.backgroundColor];
    
    [self come:@"here"];
}

- (void)come:(NSString *)str
{
    NSLog(@"come");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

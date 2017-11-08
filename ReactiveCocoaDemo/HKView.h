//
//  HKView.h
//  ReactiveCocoaDemo
//
//  Created by 裕福 on 2017/11/6.
//  Copyright © 2017年 裕福. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface HKView : UIView

@property (strong, nonatomic) RACSubject *btnClickSignal;

- (void)come:(NSString *)str;

@end

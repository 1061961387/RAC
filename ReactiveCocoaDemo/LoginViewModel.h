//
//  LoginViewModel.h
//  ReactiveCocoaDemo
//
//  Created by 楠王 on 2017/11/9.
//  Copyright © 2017年 裕福. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface LoginViewModel : NSObject

@property (strong, nonatomic) NSString *account;

@property (strong, nonatomic) NSString *pwd;

@property (strong, nonatomic) RACSignal *loginSignal;

@property (strong, nonatomic) RACCommand *loginCommand;

@end

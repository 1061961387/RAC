//
//  LoginViewModel.m
//  ReactiveCocoaDemo
//
//  Created by 楠王 on 2017/11/9.
//  Copyright © 2017年 裕福. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (instancetype)init
{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    [self.loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"获取请求数据 = %@",x);
    }];
    
    [[self.loginCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            NSLog(@"加载菊花");
        }else{
            NSLog(@"干掉菊花");
        }
    }];
}

- (RACSignal *)loginSignal
{
    if (!_loginSignal) {
        _loginSignal = [RACSignal combineLatest:@[RACObserve(self, account),RACObserve(self, pwd)] reduce:^id _Nullable(NSString *account, NSString *pwd){
            NSLog(@"1  %@  %@",account,pwd);
            NSLog(@"2  %@  %@",_account,_pwd);
            return @(_account.length && _pwd.length);
        }];
    }
    return _loginSignal;
}

- (RACCommand *)loginCommand
{
    if (!_loginCommand) {
        _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            NSLog(@"input = %@",input);
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSString *string = [NSString stringWithFormat:@"帐号为%@密码为%@，请求得到了结果",_account,_pwd];
                [subscriber sendNext:string];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _loginCommand;
}

@end

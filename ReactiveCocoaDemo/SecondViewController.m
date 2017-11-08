//
//  SecondViewController.m
//  ReactiveCocoaDemo
//
//  Created by 裕福 on 2017/11/7.
//  Copyright © 2017年 裕福. All rights reserved.
//

#import "SecondViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

typedef void(^runloopBlock)(void);
@interface SecondViewController ()

@property (strong, nonatomic) NSMutableArray *tasks;

@property (strong, nonatomic) RACSignal *signal;

@end

@implementation SecondViewController

- (void)dealloc
{
    NSLog(@"SecondViewController dealloc");
}

- (void)timerMethod
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self demo];
    
    [self lifeRecycle];
}

- (void)lifeRecycle
{
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        NSLog(@"%@",self);
        [subscriber sendNext:@"send data"];
        return nil;
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    _signal = signal;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)demo{
    [NSTimer scheduledTimerWithTimeInterval:0.00001 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    
    _tasks = [NSMutableArray array];
    
    [self addRunLoopObserver];
}

- (void)addTask:(runloopBlock)block
{
    [self.tasks addObject:block];
    if (self.tasks.count > 18) {
        [self.tasks removeObjectAtIndex:0];
    }
}

- (void)addRunLoopObserver
{
    //获取runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    
    //定义观察者
    static CFRunLoopObserverRef runloopObserver;
    
    //上下文
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)self,
        &CFRetain,
        &CFRelease,
    };
    
    //创建观察者
    runloopObserver = CFRunLoopObserverCreate(nil, kCFRunLoopBeforeWaiting, YES, 0, &callBack, &context);
    
    //添加到runloop
    CFRunLoopAddObserver(runloop, runloopObserver, kCFRunLoopDefaultMode);
}

static void callBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    SecondViewController *vc = (__bridge SecondViewController *)info;
    if (vc.tasks.count == 0) {
        return;
    }
    runloopBlock task = vc.tasks.firstObject;
    task();
    [vc.tasks removeObjectAtIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

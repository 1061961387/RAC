//
//  SecondViewController.m
//  ReactiveCocoaDemo
//
//  Created by 裕福 on 2017/11/7.
//  Copyright © 2017年 裕福. All rights reserved.
//

#import "SecondViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "ContainerViewController.h"

typedef void(^runloopBlock)(void);
@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *tasks;

@property (strong, nonatomic) RACSignal *signal;

@property (strong, nonatomic) ContainerViewController *containerVC;

@property (assign, nonatomic) BOOL finishedAnimation;

@end

@implementation SecondViewController

- (void)dealloc
{
    NSLog(@"SecondViewController dealloc");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue.identifier = %@",segue.identifier);
    ContainerViewController *vc = [segue destinationViewController];
    self.containerVC = vc;
    NSLog(@"sender = %@",sender);
}

- (void)timerMethod
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self demo];
    
//    [self lifeRecycle];
    
    self.containerVC.label.text = @"abc";
    self.containerVC.view.backgroundColor = [UIColor redColor];
    NSLog(@"abc");
    
//    [self animation];
    
    self.mTableView.backgroundColor = [UIColor grayColor];
    self.mTableView.tableHeaderView.backgroundColor = [UIColor yellowColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//     NSLog(@"willDisplayCell");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self smallAnimation];
    }else if (indexPath.row == 1) {
        [self bigAnimation];
    }
}

- (void)smallAnimation
{
    self.mTableView.tableHeaderView.backgroundColor = [UIColor yellowColor];
    [UIView animateWithDuration:1 animations:^{
        CGRect frame = self.mTableView.tableHeaderView.frame;
        frame.size.height -= 100;
        self.mTableView.tableHeaderView.frame = frame;
        
        for (int i=0; i<3; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [self.mTableView cellForRowAtIndexPath:indexPath];
            CGRect cellFrame = cell.frame;
            NSLog(@"before %d cellFrame = %@",i,NSStringFromCGRect(cellFrame));
            cellFrame.origin.y -= 100;
            cell.frame = frame;
            NSLog(@"after %d cellFrame = %@",i,NSStringFromCGRect(cellFrame));
        }

    } completion:^(BOOL finished) {
        self.mTableView.tableHeaderView.backgroundColor = [UIColor greenColor];
        [self.mTableView reloadData];
        NSLog(@"smallAnimation");
    }];
}

- (void)bigAnimation
{
    self.mTableView.tableHeaderView.backgroundColor = [UIColor greenColor];
    [UIView animateWithDuration:1 animations:^{
        CGRect frame = self.mTableView.tableHeaderView.frame;
        frame.size.height += 100;
        self.mTableView.tableHeaderView.frame = frame;
        for (int i=0; i<3; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [self.mTableView cellForRowAtIndexPath:indexPath];
            CGRect cellFrame = cell.frame;
            cellFrame.origin.y += 100;
            cell.frame = frame;
        }
    } completion:^(BOOL finished) {
        self.mTableView.tableHeaderView.backgroundColor = [UIColor yellowColor];
        [self.mTableView reloadData];
        NSLog(@"bigAnimation");
    }];
}

- (void)animation{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.5 animations:^{
            NSLog(@"%@",[NSThread currentThread]);
            CGRect frame = self.containerVC.view.frame;
            frame.size.height =70;
            self.containerVC.view.frame = frame;
        } completion:^(BOOL finished) {
            NSLog(@"%@",finished?@YES:@NO);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1 animations:^{
                    CGRect frame = self.containerVC.view.frame;
                    frame.size.height = 200;
                    self.containerVC.view.frame = frame;
                } completion:^(BOOL finished) {
                    if (!self.finishedAnimation) {
                        [self animation];
                    }
                }];
            });
        }];
    });
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
    self.finishedAnimation = YES;
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
    
    //释放
    CFRelease(runloopObserver);
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

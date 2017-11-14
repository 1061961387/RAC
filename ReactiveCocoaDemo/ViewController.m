//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by 裕福 on 2017/7/24.
//  Copyright © 2017年 裕福. All rights reserved.
//

#import "ViewController.h"
#import "Caculator.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/NSObject+RACKVOWrapper.h>
#import "HKView.h"
#import "KFC.h"
#import "HKThread.h"
#import "Person.h"
#import "NSObject+KVO.h"
#import <ReactiveObjC/RACReturnSignal.h>
#import "LoginViewModel.h"
#import <pthread.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet HKView *hkView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) HKThread *thread;
@property (assign, nonatomic) BOOL finished;

@property (strong, nonatomic) Person *p;

@property (strong, nonatomic)id<RACSubscriber>  _Nonnull subscriber;

@property (strong, nonatomic) LoginViewModel *loginVM;

@end

@implementation ViewController
- (IBAction)loginEvent:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self caculator];
    
//    [self creatSignal];
    
//    [self signal];
    
//    [self subject];
    
//    [self btnClick];
    
//    [self tuple];
    
//    [self sequence];
    
//    [self kfc];
    
//    [self signalForSelector];
    
//    [self kvo];
    
//    [self event];
    
//    [self notif];
    
//    [self textField];
    
//    [self timer];
    
//    [self customerKVO];
    
//    [self liftSelector];
    
//    [self micro];
    
//    [self racObserver];
    
//    [self racTuplePack];
    
//    [self racMulticastConnection];
    
//    [self racCommand];
    
//    [self bindSignal];
    
//    [self flattenMap];
    
//    [self map];
    
//    [self signalOfSignal];
    
//    [self flattenMapSignal];
    
//    [self concat];
    
//    [self then];
    
//    [self merge];
    
//    [self zipWith];
    
//    [self combineLatest];
    
//    [self filter];
    
//    [self ignore];
    
//    [self take];
    
//    [self distinctUntilChanged];
    
//    [self skip];
    
//    [self loginingWithRAC];
    
//    [self mvvm];
    
//    [self threadDemo];
    
//    [self gcdSync];
    
//    [self gcdAsync];
    
//    [self serialSync];
    
//    [self serialAsync];
    
//    [self concurrentsync];
    
//    [self concurrentAsync];
    
//    [self gcdDemo1];
    
    [self gcdDemo2];
}

- (void)caculator
{
    Caculator *c = [[Caculator alloc] init];
    
    BOOL isEqule = [[[c caculator:^int(int result) {
        NSLog(@"caculator 1 c.result = %d",c.result);
        result += 2;
        result *= 5;
        NSLog(@"caculator 2 c.result = %d",c.result);
        return result;
    }] equle:^BOOL(int result) {
        NSLog(@"caculator 5 c.result = %d",c.result);
        return result == 10;
    }] isEqule];
    
    NSLog(@"isEqule = %d",isEqule);
}

- (void)creatSignal
{
    // 1.创建信号
    
    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // block调用时刻：每当有订阅者订阅信号，就会调用block。
        
        // 2.发送信号
        [subscriber sendNext:@1];
        
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            
            // 执行完Block后，当前信号就不在被订阅了。
            
            NSLog(@"信号被销毁");
            
        }];
    }];
    
    // 3.订阅信号,才会激活信号.
    [siganl subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据:%@",x);
    }];
}

- (void)signal
{
    //1.创建信号（冷信号）
    //didSubscribe调用:只要信号被订阅就会调用
    //didSubscribe作用:利用subscriber发送数据。
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //3.发送信号
        [subscriber sendNext:@"hehe"];
        self.subscriber = subscriber;
        return [RACDisposable disposableWithBlock:^{
            //只要信号取消订阅就会来这里
            NSLog(@"cancel");
        }];
    }];
    
    //2.订阅信号（热信号）
    //nextBlock调用:订阅者发送数据就会调用
    //nextBlock作用:处理数据
    RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
        //x:信号发送的内容
        NSLog(@"%@",x);
    }];
    
    [disposable dispose];
//    [self.subscriber sendNext:@"haha"];
    //默认信号发送完就会取消订阅，只要订阅者在就不会取消订阅。
}

- (void)subject{
    //面向协议开发
    //1、创建信号
    RACSubject *subject = [RACSubject subject];
    
    //2.订阅信号
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"1 = %@",x);
    }];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"2 = %@",x);
    }];
    
    //3、发送数据
    [subject sendNext:@"heee"];
}

- (void)btnClick
{
    [_hkView.btnClickSignal subscribeNext:^(id  _Nullable x) {
        self.view.backgroundColor = x;
    }];
}

- (void)tuple
{
    //元祖
    RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[@"aaa",@"123",@"a2d"]];
    NSString *str = tuple[0];
    NSLog(@"%@",str);
}

- (void)sequence
{
    //代替NSArray,NSDictionary,快速遍历，字典转模型
    NSArray *arr = @[@"123",@"aaa",@123];
    
//    RACSequence *sequence = arr.rac_sequence;
//    RACSignal *signal = sequence.signal;
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
    [arr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    NSDictionary *dict = @{@"name":@"hank",@"age":@"18",@"sex":@"man"};
    
    [dict.rac_sequence.signal subscribeNext:^(RACTuple * x) {
//        NSString *key = x[0];
//        NSString *value = x[1];
//        NSLog(@"%@ = %@",key,value);
//        NSLog(@"%@",x);
        
        //解析元祖
        RACTupleUnpack(NSString *key1, NSString *value1) = x;
        NSLog(@"%@ = %@",key1, value1);
    }];
}

- (void)kfc
{
    NSArray *array = @[@{@"name":@"1",@"icon":@"4"},
                       @{@"name":@"2",@"icon":@"5"},
                       @{@"name":@"3",@"icon":@"6"}];
    
   NSArray *arr = [[array.rac_sequence map:^id _Nullable(NSDictionary *  _Nullable value) {
        return [KFC kfcWithDict:value];
    }] array];
    NSLog(@"%@",arr);
}

- (void)signalForSelector{
//    [[_hkView rac_signalForSelector:@selector(btnClick)] subscribeNext:^(RACTuple * _Nullable x) {
//        NSLog(@"点击");
//    }];
    
    [[_hkView rac_signalForSelector:@selector(come:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"aaa = %@",x);
    }];
}

- (void)kvo{
    [_hkView rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew observer:self block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        //回调
        NSLog(@"value = %@ change = %@",value,change);
    }];
    
//    [[_hkView rac_valuesForKeyPath:@"frame" observer:self] subscribeNext:^(id  _Nullable x) {
//        //x修改了
//        NSLog(@"修改了 = %@",x);
//    }];
}

- (void)event
{
    //监听事件
    [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)notif{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)textField{
    [[_tf rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)timer{
    //Source  Observer  Timer
    //Runloop会优先处理UI模式下的事件
    //UITrackingRunLoopModeUI模式 只能够被UI事件所唤醒
    //NSDefaultRunLoopMode默认模式
    //NSRunLoopCommonModes占位模式（默认&&UI）
    //每个线程都有一个runloop，默认不开启
    
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];

    //用Strong，NSThread存在，但是线程已经不存在了。
    //
    _finished = NO;
    HKThread * thread = [[HKThread alloc] initWithBlock:^{
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        
//        while (true) {
//            //从事件队列中拿出事件来执行。
//        }
        //每条线程中都有一个Runoop，在第一次获取Runloop时创建。
        //RunLoop被创建出来后并不会执行，需手动run
//        [[NSRunLoop currentRunLoop] run];//死循环
        while (!_finished) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];
        }
        
        NSLog(@"NSRunLoop = %@",[NSThread currentThread]);
        NSLog(@"come");
    }];
    
    NSLog(@"timer = %@",[NSThread currentThread]);
    [thread start];
}

- (void)timerAction{
    NSLog(@"here");
    [NSThread sleepForTimeInterval:1];
    NSLog(@"timerAction = %@",[NSThread currentThread]);
}

- (void)customerKVO
{
    Person *p = [[Person alloc] init];
    [p WN_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    _p = p;
    
//    [_p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"old object = %@ -- change = %@",object,change);
}

- (void)WN_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"new object = %@ -- change = %@",object,change);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan = %@",[NSThread currentThread]);
//    [NSThread exit];
    _finished = YES;
    static int x = 50;
    x++;
    _hkView.frame = CGRectMake(x, 50, 200, 200);
    
    _p.name = [NSString stringWithFormat:@"name%d",x];
    
    [self pthread];
}

- (void)liftSelector
{
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"请求网络数据1");
        [subscriber sendNext:@"数据来了1"];
        return nil;
    }];
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"请求网络数据2");
        [subscriber sendNext:@"数据来了2"];
        return nil;
    }];

    
    //数组存放信号
    //当数组中所有信号都发送了数据才会执行Selector
    //方法的参数：必须和数组的信号一一对应
    //方法的参数：就是每一个信号发送的数据
    //多个请求全部回来，才调用方法。
    [self rac_liftSelector:@selector(updateUIWithOneData:TwoData:) withSignalsFromArray:@[signal1,signal2]];
}

- (void)updateUIWithOneData:(id)oneData TwoData:(id)twoData{
    NSLog(@"%@ -- %@",oneData,twoData);
}

- (void)micro{
//    [[_tf rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"%@",x);
//        _label.text = x;
//    }];
    
    //给某个对象的某个属性绑定信号,一旦信号产生数据，就会将内容赋值给属性
    RAC(_label,text) = _tf.rac_textSignal;
}

- (void)racObserver
{
    RAC(self.label,text) = _tf.rac_textSignal;
    
    //只要这个对象的属性发生变化，就发送信号
    [RACObserve(self.label, text) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)racTuplePack{
    //包装元祖
    RACTuple *tuple = RACTuplePack(@1,@2);
    NSLog(@"%@",tuple);
    
    //解包
    //RACTupleUnpack();
}

- (void)racMulticastConnection
{
    //连接类
    //用于当一个信号被多次订阅的时候，避免多次创建信号的block
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送请求
        NSLog(@"send data");
        [subscriber sendNext:@"data"];
        return nil;
    }];
    RACMulticastConnection *connection = [signal publish];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"a = %@",x);
    }];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"b = %@",x);
    }];
    
    //连接
    [connection connect];
}

- (void)racCommand
{
    //创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"input = %@",input);
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"执行完后产生的数据"];
            
            //命令执行完了，需要调用sendCompleted
            //发送完成
            [subscriber sendCompleted];
            return nil;
        }];
        NSLog(@"signal = %@",signal);
        return signal;
    }];
    
    //执行信号
    //信号源，发送信号的信号
//    [command.executionSignals subscribeNext:^(RACSignal * x) {
//        NSLog(@"1 = %@",x);
//        [x subscribeNext:^(id  _Nullable x) {
//            NSLog(@"2 = %@",x);
//        }];
//    }];
    
    //最新的信号
//    RACSignal *signalLatest = command.executionSignals.switchToLatest;
//    NSLog(@"signalLatest = %@",signalLatest);
//    [signalLatest subscribeNext:^(id  _Nullable x) {
//        NSLog(@"switchToLatest = %@",x);
//    }];
    
    [command.executing subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            NSLog(@"正在执行");
        }else{
            NSLog(@"执行完毕&&未执行");
        }
    }];
    
    //执行命令
    RACSignal *signal = [command execute:@"执行命令"];
    NSLog(@"signal 0 = %@",signal);
    
    //订阅信号
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)bindSignal{
    RACSubject *subject = [RACSubject subject];
    //将subject信号绑定到bindSignal
    RACSignal *bindSignal = [subject bind:^RACSignalBindBlock _Nonnull{
        //只要源信号发送数据，就会调用bindBlock
        //作用：字典转模型  中间步骤可以处理数据
        //value源信号发送的内容
        return ^RACSignal * (id _Nullable value, BOOL *stop){
            NSString *ret = [NSString stringWithFormat:@"%@%@",value,value];
            //返回信号不能传nil
            return [RACReturnSignal return:ret];
        };
    }];
    
    //订阅信号
    //bindSignal接收到subject发送的信号
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅%@",x);
    }];
    
    //通过subject发送信号
    [subject sendNext:@"发送bind信号"];
}

- (void)flattenMap
{
    RACSubject *subject = [RACSubject subject];
    
    [[subject flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return [RACReturnSignal return:value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
    [subject sendNext:@"123"];
}

- (void)map{
    RACSubject *subject = [RACSubject subject];
    [[subject map:^id _Nullable(id  _Nullable value) {
        NSLog(@"value = %@",value);
        return value;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"456"];
}

- (void)signalOfSignal
{
    RACSubject *signalOfSignal = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    
//    [signalOfSignal subscribeNext:^(id  _Nullable x) {
//        [x subscribeNext:^(id  _Nullable x) {
//            NSLog(@"%@",x);
//        }];
//    }];
    
    [signalOfSignal.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [signalOfSignal sendNext:signal];
    [signal sendNext:@"1234"];
}

- (void)flattenMapSignal
{
    RACSubject *signalOfSignal = [RACSubject subject];
    RACSubject *subject = [RACSubject subject];
    [[signalOfSignal flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return value;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [signalOfSignal sendNext:subject];
    [subject sendNext:@"12345"];
}

#pragma mark 组合

- (void)concat{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"A"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"B"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signalC = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"C"];
        return nil;
    }];
    
    //concat按顺序组合
    //创建组合信号
//    RACSignal *concatSignal = [[signalA concat:signalB] concat:signalC];
    
    ///<NSFastEnumeration>
    RACSignal *concatSignal = [RACSignal concat:@[signalA,signalB,signalC]];
    //订阅组合信号
    [concatSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)then{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送请求A");
        [subscriber sendNext:@"A"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送请求B");
        [subscriber sendNext:@"B"];
        [subscriber sendCompleted];
        return nil;
    }];

    //then当A发送完毕，忽略A所有值，发送B
    RACSignal *thenSignal = [signalA then:^RACSignal * _Nonnull{
        return signalB;
    }];
    
    [thenSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)merge{
    //来一个处理一个
    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACSubject subject];
    RACSubject *subjectC = [RACSubject subject];

//    RACSignal *mergeSignal = [[subjectA merge:subjectB] merge:subjectC];
    RACSignal *mergeSignal = [RACSignal merge:@[subjectA,subjectB,subjectC]];
    
    //根据情况发送数据
    [mergeSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subjectA sendNext:@"A"];
    [subjectB sendNext:@"B"];
    [subjectC sendNext:@"C"];
}

- (void)zipWith
{
    //两个信号压缩！只有当两个信号同时发出信号内容，并且将内容合并成为一个元祖给你
    
    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACSubject subject];
    
    RACSignal *zipSignal = [subjectA zipWith:subjectB];
    
    //接收数据和发送顺序无关，只和压缩顺序有关
    [zipSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subjectA sendNext:@"A"];
    [subjectB sendNext:@"B"];
    [subjectA sendNext:@"A1"];
    [subjectB sendNext:@"B1"];
    [subjectA sendNext:@"A2"];
    [subjectB sendNext:@"B2"];
}

#pragma mark 组合运用

- (void)combineLatest
{
    //reduceBlock 参数：根据组合的信号关联的  必须一一对应。
    RACSignal *signal = [RACSignal combineLatest:@[_tf.rac_textSignal,_pwdTF.rac_textSignal] reduce:^id _Nullable (NSString *account, NSString *pwd){
        NSLog(@"account = %@ -- pwd = %@",account,pwd);
        return @(account.length && pwd.length);
    }];
    
//    [signal subscribeNext:^(id  _Nullable x) {
//        _loginBtn.enabled = [x boolValue];
//    }];
    
    RAC(_loginBtn, enabled) = signal;
}

#pragma mark 过滤

- (void)filter
{
    [[_tf.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        NSLog(@"value = %@",value);
        return value.length > 5;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark 忽略
- (void)ignore{
    RACSubject *subject = [RACSubject subject];
    
    //忽略所有值
//    [subject ignoreValues];
    [[[subject ignore:@"1"] ignore:@"3"] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"1"];
    [subject sendNext:@"3"];
    [subject sendNext:@"123"];
    [subject sendNext:@"13"];
}

- (void)take{
    RACSubject *subject = [RACSubject subject];
    //专门做一个标记信号
    RACSubject *tagSubject = [RACSubject subject];
    //指定拿前面的哪几个数据，从前往后
//    [[subject take:2] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
    //指定拿后的哪几个数据，从后往前(一定要写结束)
//    [[subject takeLast:3] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
    //直到标记信号发送数据结束
    [[subject takeUntil:tagSubject] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"1"];
    [tagSubject sendNext:@".."];//或 [tagSubject sendCompleted];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
    [subject sendNext:@"4"];
    [subject sendCompleted];
}

- (void)distinctUntilChanged{
    //忽略掉重复信号
    RACSubject *subject = [RACSubject subject];
    
    [[subject distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"1"];
    [subject sendNext:@"1"];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
}

- (void)skip
{
    RACSubject *subject = [RACSubject subject];
    
    //跳过前几个信号
    [[subject skip:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
    [subject sendNext:@"4"];
}

#pragma mark 登录练习

- (void)loginingWithRAC
{
    RACSignal *loginSignal = [RACSignal combineLatest:@[_tf.rac_textSignal,_pwdTF.rac_textSignal] reduce:^id _Nullable(NSString *account, NSString *pwd){
        return @(account.length && pwd.length);
    }];

    RAC(_loginBtn, enabled) = loginSignal;
    
    //创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"拿到%@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"发送用户数据"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    //获取命令中的信号源
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"获取信号 %@",x);
    }];
    
    //监听命令
    //设置菊花
    [[command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            NSLog(@"加载菊花");
        }else{
            NSLog(@"干掉菊花");
        }
    }];
    
    //登录
    [[_loginBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [command execute:@"帐号密码"];
    }];
}

- (LoginViewModel *)loginVM
{
    if (!_loginVM) {
        _loginVM = [[LoginViewModel alloc] init];
    }
    return _loginVM;
}

- (void)mvvm{
    RAC(self.loginVM, account) = _tf.rac_textSignal;
    RAC(self.loginVM, pwd) = _pwdTF.rac_textSignal;
    RAC(self.loginBtn, enabled) = self.loginVM.loginSignal;
    
    [[_loginBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        [self.loginVM.loginCommand execute:@"zhanghaomima"];
        [self.loginVM.loginCommand execute:nil];
    }];
}

#pragma mark pthread

- (void)pthread
{
    NSString *str = @"hello";
    
    pthread_t threadId;
    int result = pthread_create(&threadId, NULL, &demo, (__bridge void *)(str));
    
    if (result == 0) {
        NSLog(@"ok");
    }else{
        NSLog(@"error");
    }
}

void *demo (void *para){
    NSLog(@"%@ = %@",para,[NSThread currentThread]);
    return nil;
}

#pragma mark NSThread
- (void)threadDemo{
    [[_btn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self creatThread];
    }];
}

- (void)creatThread{
    //创建线程
    NSLog(@"A----");
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadMethod:) object:@"thread"];
//    //启动线程
//    [thread start];
    
    //分离
//    [NSThread detachNewThreadSelector:@selector(threadMethod:) toTarget:self withObject:@"detach"];
    
    //后台，子线程
    [self performSelectorInBackground:@selector(threadMethod:) withObject:@"background"];
    
    for (int i=0; i<10; i++) {
        NSLog(@"%d",i);
    }
    NSLog(@"B----");
}

- (void)threadMethod:(id)obj
{
    for (int i=0; i<2; i++) {
        NSLog(@"%d %@ == %@",i,obj,[NSThread currentThread]);
    }
}

#pragma mark GCD
- (void)gcdSync
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_sync(queue, ^{
        NSLog(@"同步执行%@",[NSThread currentThread]);
    });
}

- (void)gcdAsync
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"异步执行%@",[NSThread currentThread]);
    });
}

//串行队列，同步执行
//顺序执行,不会开启线程 在主线程
- (void)serialSync
{
    //1.队列名称
    //2.队列属性
    dispatch_queue_t queqe = dispatch_queue_create("com.ios.wn", DISPATCH_QUEUE_SERIAL);
    for (int i=0; i<10; i++) {
        dispatch_sync(queqe, ^{
            NSLog(@"%@ %d",[NSThread currentThread],i);
        });
    }
    NSLog(@"come here = %@",[NSThread currentThread]);
}

//串行队列，异步执行
//顺序执行,会开启线程  在子线程
- (void)serialAsync
{
    //1.队列名称
    //2.队列属性
    dispatch_queue_t queqe = dispatch_queue_create("com.ios.wn", DISPATCH_QUEUE_SERIAL);
    for (int i=0; i<10; i++) {
        NSLog(@"--------%d",i);
        dispatch_async(queqe, ^{
            NSLog(@"%@ %d",[NSThread currentThread],i);
        });
    }
    NSLog(@"come here = %@",[NSThread currentThread]);
}

//并发队列，同步执行
//顺序执行,不会开启线程  在主线程
- (void)concurrentsync{
    dispatch_queue_t queqe = dispatch_queue_create("com.ios.wn", DISPATCH_QUEUE_CONCURRENT);
    for (int i=0; i<10; i++) {
        NSLog(@"--------%d",i);
        dispatch_sync(queqe, ^{
            NSLog(@"%@ %d",[NSThread currentThread],i);
        });
    }
    NSLog(@"come here = %@",[NSThread currentThread]);
}

//并发队列，异步执行
//不一定顺序执行,会开启线程  在子线程
- (void)concurrentAsync{
    dispatch_queue_t queqe = dispatch_queue_create("com.ios.wn", DISPATCH_QUEUE_CONCURRENT);
    for (int i=0; i<10; i++) {
        NSLog(@"--------%d",i);
        dispatch_async(queqe, ^{
            NSLog(@"%@ %d",[NSThread currentThread],i);
        });
    }
    NSLog(@"come here = %@",[NSThread currentThread]);
}

- (void)gcdDemo1
{
    dispatch_queue_t q = dispatch_queue_create("com.ios.wn", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(q, ^{
        NSLog(@"登录 = %@",[NSThread currentThread]);
    });
    dispatch_async(q, ^{
        NSLog(@"支付 = %@",[NSThread currentThread]);
    });
    NSLog(@"1");
    dispatch_async(q, ^{
        NSLog(@"下载 = %@",[NSThread currentThread]);
    });
    NSLog(@"2");
    NSLog(@"come here");
}

//增强同步
- (void)gcdDemo2
{
    dispatch_queue_t q = dispatch_queue_create("com.ios.wn", DISPATCH_QUEUE_CONCURRENT);
    void (^task)() = ^{
        dispatch_sync(q, ^{
            NSLog(@"登录 = %@",[NSThread currentThread]);
        });
        dispatch_async(q, ^{
            NSLog(@"支付 = %@",[NSThread currentThread]);
        });
        NSLog(@"1");
        dispatch_async(q, ^{
            NSLog(@"下载 = %@",[NSThread currentThread]);
        });
        NSLog(@"come here");
        
    };
    
    dispatch_async(q, task);
}

@end

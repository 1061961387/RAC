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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet HKView *hkView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (strong, nonatomic) HKThread *thread;
@property (assign, nonatomic) BOOL finished;

@property (strong, nonatomic) Person *p;

@property (strong, nonatomic)id<RACSubscriber>  _Nonnull subscriber;

@end

@implementation ViewController

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
    
    [self racMulticastConnection];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

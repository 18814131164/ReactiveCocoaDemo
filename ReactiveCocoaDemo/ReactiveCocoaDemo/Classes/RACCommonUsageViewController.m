//
//  RACCommonUsageViewController.m
//  ReactiveCocoaDemo
//
//  Created by 众网合一 on 16/8/3.
//  Copyright © 2016年 iOSlyon. All rights reserved.
//

#import "RACCommonUsageViewController.h"

@interface RACCommonUsageViewController ()

@property (nonatomic , weak) UIView *redV;

@end

@implementation RACCommonUsageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor];

#pragma mark - RAC常见宏定义
    
//－－－－>  8.1 RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定。
    
    UILabel *labelView = [[UILabel alloc]init];
    labelView.frame = CGRectMake(0, 104, self.view.frame.size.width, 40);
    labelView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:labelView];
    
    UITextField *_textField = [[UITextField alloc]init];
    _textField.frame = CGRectMake(0, 64, self.view.frame.size.width, 40);
    _textField.borderStyle = UITextBorderStyleBezel;
    [self.view addSubview:_textField];
    // 只要文本框文字改变，就会修改label的文字
    RAC(labelView,text) = _textField.rac_textSignal;
    
    
//－－－－>  8.2 RACObserve(self, name):监听某个对象的某个属性,返回的是信号。
 
    
    [RACObserve(self.view, center) subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
 
    
//－－－－>  8.3  @weakify(Obj)和@strongify(Obj),一般两个都是配套使用,在主头文件(ReactiveCocoa.h)中并没有导入，需要自己手动导入，RACEXTScope.h才可以使用。但是每次导入都非常麻烦，只需要在主头文件自己导入就好了。
   
    
//－－－－>  8.4 RACTuplePack：把数据包装成RACTuple（元组类）
 
    // 把参数中的数据包装成元组
    RACTuple *tuple = RACTuplePack(@"xmg",@20);
    
    // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
    // name = @"xmg" age = @20
    RACTupleUnpack(NSString *name,NSNumber *age) = tuple;
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _redV.center = CGPointMake(200, 250);
}

#pragma mark - RAC开发中常见用法

- (void)commonUsage
{
    UIView *redV = [[UIView alloc]init];
    redV.frame = CGRectMake(0, 168, 40, 40);
    redV.backgroundColor = [UIColor redColor];
    [self.view addSubview:redV];
    _redV = redV;

//－－－－> 1.代替代理
    
    // 需求：自定义redView,监听红色view中按钮点击
    // 之前都是需要通过代理监听，给红色View添加一个代理属性，点击按钮的时候，通知代理做事情
    // rac_signalForSelector:把调用某个对象的方法的信息转换成信号，就要调用这个方法，就会发送信号。
    // 这里表示只要redV调用btnClick:,就会发出信号，订阅就好了。
    [[redV rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"点击红色按钮");
    }];
    
    
//－－－－> 2.KVO
    
    // 把监听redV的center属性改变转换成信号，只要值改变就会发送信号
    // observer:可以传入nil
    
    [[redV rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        NSLog(@"%@ : %@",key,value);
        
    }];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor brownColor];
    [button setFrame:CGRectMake(0, 104, self.view.frame.size.width, 40)];
    [button setTitle:@"这是一个按钮" forState:0];
    [self.view addSubview:button];
    
    
//－－－－> 3.监听事件
    
    // 把按钮点击事件转换为信号，点击按钮，就会发送信号
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"按钮被点击了%@--- %@",button ,x);
    }];
    
    
//－－－－> 4.代替通知
    
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        
        NSLog(@"键盘弹出 = %@",x);
        NSLog(@"%@",[x performSelector:NSSelectorFromString(@"userInfo")]);
    }];
    
    
    
    
//－－－－> 5.监听文本框的文字改变
    
    UITextField *_textField = [[UITextField alloc]init];
    _textField.frame = CGRectMake(0, 64, self.view.frame.size.width, 40);
    _textField.borderStyle = UITextBorderStyleBezel;
    [self.view addSubview:_textField];
    
    [_textField.rac_textSignal subscribeNext:^(id x) {
        
        NSLog(@"文字改变了%@",x);
    }];
    
    
//－－－－> 6.处理多个请求，都返回结果的时候，统一做处理.
    
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];
}

// 更新UI
- (void)updateUIWithR1:(id)data r2:(id)data1
{
    NSLog(@"更新UI%@  %@",data,data1);
}

@end

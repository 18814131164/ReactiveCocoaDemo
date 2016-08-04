
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////

#import "RACMainViewController.h"
#import "RACNextViewController.h"
#import "RACCommonUsageViewController.h"
#import "FlagItem.h"

@interface RACMainViewController ()

@property (nonatomic, copy)NSMutableArray *flags;
@property (nonatomic, strong)RACCommand *command;
@end

@implementation RACMainViewController

- (NSMutableArray *)flags{
    if (!_flags) {
        _flags = [NSMutableArray array];
    }
    return _flags;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /////////////////////////////////////////////
    //// 点击按钮 ---> ReactiveCocoa的常见用法和常见宏>>>>>>
    /////////////////////////////////////////////
    UIButton *commonUsageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commonUsageButton.backgroundColor = [UIColor grayColor];
    [commonUsageButton setTitle:@"ReactiveCocoa的常见用法" forState:0];
    [commonUsageButton setFrame:CGRectMake(0, 64,self.view.frame.size.width, 40)];
    [self.view addSubview:commonUsageButton];
    [[commonUsageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        RACCommonUsageViewController *commonUsage = [[RACCommonUsageViewController alloc]init];
        [self.navigationController pushViewController:commonUsage animated:YES];
    }];
    
}


///////////////////////////////////
/////// RACSubject 替换代理 ////////
///////////////////////////////////

- (void)subjectReplaceDelegate
{
    RACNextViewController *next = [[RACNextViewController alloc]init];
    next.delegateSignal = [RACSubject subject];
    [next.delegateSignal subscribeNext:^(id x) {
        NSLog(@"第二个页面点击了按钮");
    }];
    [self.navigationController pushViewController:next animated:YES];
}

///////////////////////////////////////////
///////// RAC 中的数组、字典、遍历 ///////////
////////////////////////////////////////////

- (void)tupleAndSequence
{
    /*
     RACTuple:元组类,类似NSArray,用来包装值.
     RACSequence:RAC中的集合类，用于代替NSArray, NSDictionary,可以使用它来快速遍历数组和字典。
     */
    
#pragma mark - 1.遍历数组
    
    NSArray *numbers = @[@1,@2,@3,@4];
    
    /*
     这里其实是三步
     ------------
     第一步: 把数组转换成集合RACSequence numbers.rac_sequence
     第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
     第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
     */
    
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
 
#pragma mark - 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    
    NSDictionary *dict = @{@"name":@"xmg",@"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        // 相当于以下写法
        // NSString *key = x[0];
        // NSString *value = x[1];
        
        NSLog(@"%@ %@",key,value);
        
    }];
    
 
#pragma mark - 3.字典转模型
#pragma mark 3.1 RAC写法
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    
    // rac_sequence注意点：调用subscribeNext，并不会马上执行nextBlock，而是会等一会。
    [dictArr.rac_sequence.signal subscribeNext:^(id x) {
        // 运用RAC遍历字典，x：字典

        FlagItem *item = [FlagItem flagWithDict:x];

        [self.flags addObject:item];

    }];

 
#pragma mark 3.2 RAC高级写法:
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
    NSArray *flags = [[dictArr.rac_sequence map:^id(id value) {
        
        return [FlagItem flagWithDict:value];
        
    }] array];
}


///////////////////////////////////////////
///////// RACCommand 不知道如何使用 /////////
///////////////////////////////////////////

- (void)usageCommand{
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        
        NSLog(@"执行命令 - %@",input);
        
        // 创建空信号,必须返回信号,不能传nil
        //        return [RACSignal empty];
        
        // 2.创建信号,用来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"请求数据"];
            
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            
            return nil;
        }];
        
    }];
    
    // 强引用命令，不要被销毁，否则接收不到数据
    _command = command;
    
    
    // 3.执行命令
    [self.command execute:@"哇哈哈哈哈"];
    
    // 4.订阅RACCommand中的信号
    [command.executionSignals subscribeNext:^(id x) {
        
        NSLog(@" ============= %@",x);
        
        [x subscribeNext:^(id x) {
            
            NSLog(@"------- %@",x);
        }];
        
    }];
    
    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 5.监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:1] subscribeNext:^(id x) {
        
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
            
        }else{
            // 执行完成
            NSLog(@"执行完成");
        }
        
    }];
}

/////////////////////////////////////////////////////
//// RACMulticastConnection : 解决重复请求问题 /////////
/////////////////////////////////////////////////////

- (void)RACMulticastConnection
{
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"发送请求");
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    // 2.创建连接
    RACMulticastConnection *connect = [signal publish];
    
    // 3.订阅信号，
    // 注意：订阅信号，也不能激活信号，只是保存订阅者到数组，必须通过连接,当调用连接，就会一次性调用所有订阅者的sendNext:
    [connect.signal subscribeNext:^(id x) {
        
        NSLog(@"订阅者一信号");
        
    }];
    
    [connect.signal subscribeNext:^(id x) {
        
        NSLog(@"订阅者二信号");
        
    }];
    
    // 4.连接,激活信号
    [connect connect];
}

@end

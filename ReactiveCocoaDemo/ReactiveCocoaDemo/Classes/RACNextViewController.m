//
//  RACNextViewController.m
//  ReactiveCocoaDemo
//
//  Created by 众网合一 on 16/8/3.
//  Copyright © 2016年 iOSlyon. All rights reserved.
//

#import "RACNextViewController.h"

@interface RACNextViewController ()

@end

@implementation RACNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 通知代理
    // 判断代理信号是否有值
    if (self.delegateSignal) {
        // 有值，才需要通知
        [self.delegateSignal sendNext:nil];
    }
}

@end

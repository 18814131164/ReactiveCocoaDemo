//
//  RACNextViewController.h
//  ReactiveCocoaDemo
//
//  Created by 众网合一 on 16/8/3.
//  Copyright © 2016年 iOSlyon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RACNextViewController : UIViewController

/** 信号*/
@property (nonatomic, strong) RACSignal *siganl;
@property (nonatomic, strong) RACReplaySubject *replaySubject;
/** RACSubject替换代理*/
@property (nonatomic, strong) RACSubject *delegateSignal;

@end

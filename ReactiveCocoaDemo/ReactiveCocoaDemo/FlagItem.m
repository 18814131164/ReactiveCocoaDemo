//
//  FlagItem.m
//  ReactiveCocoa
//
//  Created by 刘智援 on 16/5/15.
//  Copyright © 2016年 Lyon Liu. All rights reserved.
//

#import "FlagItem.h"

@implementation FlagItem

+(instancetype)flagWithDict:(NSDictionary *)dict
{
    FlagItem *item = [[self alloc]init];
    item.icon = dict[@"icon"];
    item.name = dict[@"name"];
    return item;
}

-(void)setArrays:(NSArray *)arrays
{
    _arrays = arrays;
    
    NSLog(@"%p ,%p",_arrays ,arrays);
}
@end

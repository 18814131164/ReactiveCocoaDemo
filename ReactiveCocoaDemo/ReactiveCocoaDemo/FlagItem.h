//
//  FlagItem.h
//  ReactiveCocoa
//
//  Created by 刘智援 on 16/5/15.
//  Copyright © 2016年 Lyon Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlagItem : NSObject
@property (nonatomic ,copy) NSString*icon;
@property (nonatomic ,copy) NSString*name;
@property (nonatomic ,strong) NSArray *arrays;
+(instancetype)flagWithDict:(NSDictionary *)dict;
@end

//
//  SLCharList.m
//  MGBEB
//
//  Created by 李博涛 on 2018/10/31.
//  Copyright © 2018 surge. All rights reserved.
//

#import "SLCharList.h"

@implementation SLCharList

// 特殊字段处理
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idstr" : @"id"};
}

@end

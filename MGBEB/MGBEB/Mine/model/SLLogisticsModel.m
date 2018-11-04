//
//  SLLogisticsModel.m
//  MGBEB
//
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLLogisticsModel.h"

@implementation SLLogisticsModel

// 特殊字段处理
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idstr" : @"id"};
}

@end

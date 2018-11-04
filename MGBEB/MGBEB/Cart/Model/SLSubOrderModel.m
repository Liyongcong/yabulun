//
//  SLSubProductModel.m
//  MGBEB
//
//  Created by SurgeLee on 2018/6/28.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLSubOrderModel.h"

@implementation SLSubOrderModel

// 特殊字段处理
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idstr" : @"id"};
}

@end

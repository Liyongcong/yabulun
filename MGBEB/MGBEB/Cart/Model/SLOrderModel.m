//
//  SLOrderModel.m
//  MGBEB
//
//  Created by SurgeLee on 2018/7/6.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLOrderModel.h"

@implementation SLOrderModel

// 特殊字段处理
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idstr" : @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
     return @{@"products":[SLSubOrderModel class]};
}

@end

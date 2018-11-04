//
//  SLAddressModel.m
//  MGBEB
//
//  Created by SurgeLee on 2018/7/6.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLAddressModel.h"

@implementation SLAddressModel

// 特殊字段处理
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idstr" : @"id"};
}

@end

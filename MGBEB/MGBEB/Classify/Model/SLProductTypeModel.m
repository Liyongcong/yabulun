//
//  SLProductTypeModel.m
//  MGBEB
//
//  Created by SurgeLee on 2018/6/21.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLProductTypeModel.h"

@implementation SLProductTypeModel

// 特殊字段处理
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idstr" : @"id"};
}

@end

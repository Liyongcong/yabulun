//
//  SLActivityModel.m
//  MGBEB
//
//  Created by SurgeLee on 2018/6/20.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLActivityModel.h"

@implementation SLActivityModel

// 特殊字段处理
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idstr" : @"id"};
}

/**
 *  归档，将对象元素进行归档
 */
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
}

/**
 *  解码是调用，生成对象
 */
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super init]) {
        
    }
    return self;
}

@end

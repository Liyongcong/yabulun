//
//  OrderUtils.m
//  MGBEB
//
//  Created by SurgeLee on 2018/7/7.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "OrderUtils.h"

@implementation OrderUtils

// 获取状态
+ (NSString*)statusWithValue:(NSInteger)value {
    NSString *status = @"待支付";
    switch (value) {
        case 0: status = @"待支付"; break;
        case 1: status = @"未配送"; break;
        case 2: status = @"配送中"; break;
        case 3: status = @"完成"; break;
        default: break;
    }
    return status;
}

// 获取状态
+ (NSString*)statusWithValue:(NSInteger)value type:(NSInteger)type{
    NSString *status = @"待支付";
    if (type == 2) {
        switch (value) {
            case 0: status = @"用户提交"; break;
            case 1: status = @"支付完成"; break;
            case 2: status = @"配送中"; break;
            case 3: status = @"订单完成"; break;
            case 4: status = @"审核通过"; break;
            default: break;
        }
    } else {
        switch (value) {
            case 0: status = @"待支付"; break;
            case 1: status = @"未配送"; break;
            case 2: status = @"配送中"; break;
            case 3: status = @"完成"; break;
            default: break;
        }
    }
    return status;
}

// 获取状态
+ (NSString*)refundWithValue:(NSInteger)value {
    NSString *status = @"退款申请";
    switch (value) {
        case 0: status = @"退款申请"; break;
        case 1: status = @"已申请"; break;
        case 2: status = @"未通过"; break;
        case 3: status = @"已退款"; break;
        default: break;
    }
    return status;
}

@end

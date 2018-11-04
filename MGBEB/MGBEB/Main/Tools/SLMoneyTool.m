//
//  SLMoneyTool.m
//
//  Created by SurgeLee on 2018/6/29.
//  Copyright © 2018年 mgood. All rights reserved.
//

#import "SLMoneyTool.h"

@implementation SLMoneyTool

// 大金额格式化
+ (NSString *)moneyWithNSString:(NSString *)money{
    NSString *reMoney;
    // 格式转换
    CGFloat moneyF = [money floatValue];
    // 格式化
    reMoney = [self moneyWithFormat:moneyF];
    return reMoney;
}

+ (NSString *)moneyWithFormat:(CGFloat)money{
    NSString *reMoney;
    if (money > 10000) {
        reMoney = [NSString stringWithFormat:@"%.02f万", money/10000];
    } else {
        reMoney = [NSString stringWithFormat:@"%.02f", money];
    }
    return reMoney;
}


// 详细金额格式化
+ (NSString *)moneyFormatWithNSString:(NSString *)money {
    // 格式转换
    CGFloat moneyF = [money floatValue];
    return [self moneyFormatWithCGFloat:moneyF];
}

+ (NSString *)moneyFormatWithCGFloat:(CGFloat)money {
    return [NSString stringWithFormat:@"%.02f", money];
}


@end

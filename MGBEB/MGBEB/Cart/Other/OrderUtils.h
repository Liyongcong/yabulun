//
//  OrderUtils.h
//  MGBEB
//
//  Created by SurgeLee on 2018/7/7.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderUtils : NSObject

// 订单状态
+ (NSString*)statusWithValue:(NSInteger)value;

+ (NSString*)statusWithValue:(NSInteger)value type:(NSInteger)type;

// 退款状态
+ (NSString*)refundWithValue:(NSInteger)value;

@end

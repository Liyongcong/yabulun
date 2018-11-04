//
//  SLOrderModel.h
//  MGBEB
//
//  Created by SurgeLee on 2018/7/6.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLSubProductModel.h"
#import "SLSubOrderModel.h"

@interface SLOrderModel : NSObject

// id
@property (nonatomic, copy) NSString *idstr;
// 订单
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, assign) NSInteger fkSupplierManageId;
@property (nonatomic, copy) NSString *fkSupplierManageName;
@property (nonatomic, copy) NSString *fkSupplierManageCode;
@property (nonatomic, assign) NSInteger orderStatus;
@property (nonatomic, copy) NSString *clientName;
@property (nonatomic, copy) NSString *clientCode;
@property (nonatomic, strong) NSNumber *orderMoney;

@property (nonatomic, copy) NSString *receivingPerson;
@property (nonatomic, copy) NSString *clientPhone;
@property (nonatomic, copy) NSString *dispatchingAddress;

@property (nonatomic, strong) NSDate *orderDate;
@property (nonatomic, copy) NSString *logisticsInfo;
@property (nonatomic, copy) NSString *deleteFlag;
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger refundStatus; // 退款状态

// 产品信息
@property (strong, nonatomic) NSArray *products;

// 环信账号
@property (nonatomic, copy) NSString *emAccount;

@end

//
//  SLSubProductModel.h
//  MGBEB
//
//  Created by SurgeLee on 2018/6/28.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLSubProductModel : NSObject

// id
@property (nonatomic, copy) NSString *idstr;

@property (nonatomic, assign) NSInteger fkOrderManage;
//@property (nonatomic, assign) NSInteger fkProductManageMainId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productNameCode;
@property (nonatomic, assign) NSInteger fkProductManageSub;
@property (nonatomic, copy) NSString *secondName;
//@property (nonatomic, copy) NSString *secondCode;
//@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, strong) NSNumber *totalPrie;

// 商品型号
@property (nonatomic, copy) NSString *secondLevelName;
@property (nonatomic, copy) NSString *secondCode;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger fkProductManageMainId;

// 订单中产品图片
@property (nonatomic, copy) NSString *productImg;

// 订单中信息
@property (nonatomic, assign) NSInteger fkSupplierManageId;
@property (nonatomic, copy) NSString *fkSupplierManageName;
@property (nonatomic, copy) NSString *fkSupplierManageCode;

// 购物车
@property (nonatomic, assign) NSInteger fkCartManage;

@end

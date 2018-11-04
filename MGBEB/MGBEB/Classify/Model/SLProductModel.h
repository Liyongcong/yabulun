//
//  SLProductModel.h
//  MGBEB
//
//  Created by SurgeLee on 2018/6/25.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLProductModel : NSObject

// id
@property (nonatomic, copy) NSString *idstr;
// 产品
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productCode;
@property (nonatomic, assign) NSInteger fkSupplierManageId;
@property (nonatomic, assign) NSInteger productStatus;
@property (nonatomic, strong) NSDate *addTime;
@property (nonatomic, assign) NSInteger fkBaseGoodsType;
@property (nonatomic, strong) NSNumber *appListPrice;
@property (nonatomic, assign) NSInteger appIndexTag;
@property (nonatomic, assign) NSInteger isSecKill;
@property (nonatomic, copy) NSString *productImg;
@property (nonatomic, copy) NSString *productDetailImg;
@property (nonatomic, assign) NSInteger type;

// 销售数量
@property (nonatomic, assign) NSInteger saleNum;

// 将productImg拆分
@property (nonatomic, strong) NSMutableArray *productImgs;

@property (nonatomic, copy) NSString *productDetailVideo;

@end

//
//  SLLogisticsModel.h
//  MGBEB
//
//  Copyright © 2018年 surge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLLogisticsModel : NSObject

// id
@property (nonatomic, copy) NSString *idstr;

@property (nonatomic, copy) NSString *logisticsDescribe; // 物流信息
@property (nonatomic, copy) NSString *logisticsTime; // 物流时间

@end

NS_ASSUME_NONNULL_END

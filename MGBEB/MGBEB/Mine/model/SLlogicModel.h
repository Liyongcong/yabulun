//
//  SLlogicModel.h
//  MGBEB
//  Copyright © 2018年 surge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLlogicModel : NSObject

// id
@property (nonatomic, copy) NSString *idstr;

@property (nonatomic, copy) NSString *transportUnit; // 承运人
@property (nonatomic, copy) NSString *phone; // 电话
@property (nonatomic, copy) NSString *waybillNo; // 单号


@end

NS_ASSUME_NONNULL_END

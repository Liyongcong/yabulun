//
//  EvaluViewController.h
//  MGBEB
//  评论
//  Copyright © 2018年 surge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLEvaluViewController : UIViewController

@property (nonatomic, assign) NSInteger orderId; // 订单Id
@property (nonatomic, assign) NSInteger productId; // 产品Id
@property (nonatomic, assign) NSInteger subId; // 二级产品Id

@property (nonatomic, copy) NSString *detailImg; // 图片


@end

NS_ASSUME_NONNULL_END

//
//  SLPayViewController.h
//  MGBEB
//
//  Created by SurgeLee on 2018/7/11.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLPayViewController : UIViewController

@property (nonatomic, copy) NSMutableArray *orderIds; // 订单id集合
@property (nonatomic, copy) NSString *points; // 积分
@property (nonatomic, copy) NSString *moneys; // 金额

@property (nonatomic, copy) NSMutableArray *orders; // 代付订单集合

@end

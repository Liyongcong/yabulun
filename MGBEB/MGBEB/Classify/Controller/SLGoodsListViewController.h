//
//  SLGoodsListViewController.h
//  MGBEB
//
//  Created by SurgeLee on 2018/6/25.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLGoodsListViewController : UIViewController

// 商品类型
@property (nonatomic, copy) NSString *typeId;

// 商品名称
@property (nonatomic, copy) NSString *productName;

// 首页类型
@property (nonatomic, copy) NSString *secKill;
@property (nonatomic, copy) NSString *indexId;

@end

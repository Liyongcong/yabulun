//
//  SLGoodDetailViewController.h
//  MGBEB
//
//  Created by SurgeLee on 2018/6/27.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SLProductModel.h"

@interface SLGoodDetailViewController : UIViewController

// 商品信息
@property (nonatomic, strong) SLProductModel *product;

// 商品Id
@property (nonatomic, copy) NSString *productId;


@property (strong, nonatomic) UIView *playView; 

@end

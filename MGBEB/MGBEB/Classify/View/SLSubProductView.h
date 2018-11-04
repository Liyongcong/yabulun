//
//  SLSubProductView.h
//  MGBEB
//
//  Created by SurgeLee on 2018/6/28.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SLSubProductModel.h"

@protocol SLSubProductViewDelegate <NSObject>

@optional

- (void)resetClick:(UIButton*)sender subProduct:(SLSubProductModel*)subProduct;

- (void)sureClick:(UIButton*)sender subProduct:(SLSubProductModel*)subProduct num:(NSInteger)num;

@end

@interface SLSubProductView : UIView

// 型号列表
@property (nonatomic, strong) NSMutableArray *subProducts;

// 代理对象
@property (nonatomic, weak) id<SLSubProductViewDelegate> delegate;

@end

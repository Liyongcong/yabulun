//
//  SLCartTableCell.h
//  MGBEB
//
//  Created by SurgeLee on 2018/6/30.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SLSubProductModel.h"
#import "SLSubOrderModel.h"

@protocol SLCartCellDelegate <NSObject>

/**
 产品选中与未选中状态发生变化
 @param product 产品
 */
- (void)productSelect:(SLSubOrderModel *)product isSelect:(BOOL) isSelect;
/**
 产品数量发生变化
 @param product 产品
 */
- (void)productChange:(SLSubOrderModel *)product number:(NSInteger)num;

// 删除购物车
- (void)productDel:(SLSubOrderModel *)product;

@end

@interface SLCartTableCell : UITableViewCell

@property (weak, nonatomic) id <SLCartCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) SLSubOrderModel *subProduct;

@property (nonatomic, weak) UIButton *redio;

@end

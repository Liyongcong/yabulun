//
//  SLMineTableCell.h
//  MGBEB
//
//  Created by SurgeLee on 2018/7/2.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SLSubProductModel.h"
#import "SLSubOrderModel.h"

@protocol SLMineCellDelegate <NSObject>

// 评价订单+产品
- (void)evaluOrder:(NSInteger)orderId productId:(NSInteger) productId prodSubId:(NSInteger) subId detailImg:(NSString *) detailImg;

@end

@interface SLMineTableCell : UITableViewCell

@property (weak, nonatomic) id <SLMineCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) SLSubOrderModel *subProduct;

@property (nonatomic, assign) NSInteger orderStatus; // 订单状态

@end

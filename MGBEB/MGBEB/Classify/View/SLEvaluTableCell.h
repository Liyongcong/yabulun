//
//  SLEvaluTableCell.h
//  MGBEB
//
//  Copyright © 2018年 surge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SLevaluModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLEvaluTableCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) SLevaluModel *evalu; // 评价

@end

NS_ASSUME_NONNULL_END

//
//  SLLogicTableCell.h
//  MGBEB
//
//  Copyright © 2018年 surge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SLLogisticsModel.h"

@interface SLLogicTableCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) SLLogisticsModel *logis;

@end


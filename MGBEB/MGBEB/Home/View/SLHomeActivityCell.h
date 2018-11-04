//
//  HomeActivityCell.h
//  MGBEB
//
//  Created by SurgeLee on 2018/6/20.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SLActivityModel.h"
#import "SLTypeModel.h"

@interface SLHomeActivityCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) SLTypeModel *activity;

@end

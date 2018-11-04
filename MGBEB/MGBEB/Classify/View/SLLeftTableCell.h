//
//  SLLeftViewCell.h
//  MGBEB
//
//  Created by SurgeLee on 2018/6/21.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SLProductTypeModel.h"

@interface SLLeftTableCell : UITableViewCell

@property(strong, nonatomic)SLProductTypeModel *productTypeModel;

//是否被选中
@property(assign, nonatomic)BOOL hasBeenSelected;


// 方法
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

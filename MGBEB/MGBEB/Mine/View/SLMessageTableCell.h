//
//  SLMessageTableCell.h
//  MGBEB
//
//  Copyright © 2018 surge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SLCharList.h"

@interface SLMessageTableCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) SLCharList *charLists;

@end


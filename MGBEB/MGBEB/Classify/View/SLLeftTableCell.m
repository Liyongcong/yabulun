//
//  SLLeftViewCell.m
//  MGBEB
//
//  Created by SurgeLee on 2018/6/21.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLLeftTableCell.h"

#import "SLHeader.h"

@interface SLLeftTableCell()

@property(strong, nonatomic)UIView *leftColorView;

@property(strong, nonatomic)UILabel *nameLabel;

@end

//左边色彩条宽度
static const CGFloat leftColorViewWidth = 3;
//文字字体大小
static const CGFloat textFontSize = 13;

@implementation SLLeftTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"leftTableCell";
    SLLeftTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SLLeftTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //设置背影色
        self.backgroundColor = [UIColor whiteColor];//SLColor(238, 238, 238, 255);
        self.accessoryType = UITableViewCellAccessoryNone;
        
        if (!self.leftColorView) {
            self.leftColorView = [[UIView alloc] init];
            self.leftColorView.backgroundColor = [UIColor redColor];
            self.leftColorView.hidden = YES;
            [self.contentView addSubview: self.leftColorView];
        }
        
        if (!self.nameLabel) {
            self.nameLabel = [[UILabel alloc] init];
            self.nameLabel.font = [UIFont systemFontOfSize:textFontSize];
            self.nameLabel.textAlignment = NSTextAlignmentCenter;
            [self.nameLabel sizeToFit];
            [self.contentView addSubview: self.nameLabel];
        }
        
        // 布局
        self.leftColorView.sd_layout.leftSpaceToView(self.contentView, 0)
            .widthIs(2)
            .topSpaceToView(self.contentView, 0)
            .bottomSpaceToView(self.contentView, 0);
        
        self.nameLabel.sd_layout.leftSpaceToView(self.leftColorView, 2)
            .rightSpaceToView(self.contentView, 0)
            .topSpaceToView(self.contentView, 0)
            .bottomSpaceToView(self.contentView, 0);
    }
    return self;
}

-(void)setHasBeenSelected:(BOOL)hasBeenSelected
{
    _hasBeenSelected = hasBeenSelected;
    if (_hasBeenSelected) {
        self.backgroundColor = [UIColor whiteColor];
        self.nameLabel.textColor = SLColor(88, 88, 88, 255);
        self.leftColorView.hidden = NO;
    } else {
        self.backgroundColor = SLColor(236,237,241, 255); // SLColor(238, 238, 238, 255);
        self.nameLabel.textColor = SLColor(162, 162, 162, 255);
        self.leftColorView.hidden = YES;
    }
}

- (void)setProductTypeModel:(SLProductTypeModel *)productTypeModel{
    _productTypeModel = productTypeModel;
    self.nameLabel.text = _productTypeModel.typeName;
}

@end

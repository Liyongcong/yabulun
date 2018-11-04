//
//  HomeActivityCell.m
//  MGBEB
//
//  Created by SurgeLee on 2018/6/20.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLHomeActivityCell.h"

#import "SLHeader.h"

// 标题字体
#define SLActivityCellTitleFont [UIFont systemFontOfSize:11]

@interface SLHomeActivityCell()

@property (nonatomic, weak) UIImageView *imgView;

@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation SLHomeActivityCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"homeActivityCell";
    SLHomeActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SLHomeActivityCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 1、创建视图
        // 图片
        UIImageView *imgView = [[UIImageView alloc] init];
        [imgView.layer setMasksToBounds:YES];
        imgView.layer.cornerRadius = 5.0;
        // 标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = SLActivityCellTitleFont;
        
        self.imgView = imgView;
        self.titleLabel = titleLabel;
        
        // 3、添加到父视图
        [self addSubview:imgView];
        [self addSubview:titleLabel];
        
        // 4、设置布局
        imgView.sd_layout.leftSpaceToView(self, 8)
            .rightSpaceToView(self, 8)
            .topSpaceToView(self, 0)
            .heightIs(137);
        
        titleLabel.sd_layout.leftSpaceToView(self, 10)
            .rightSpaceToView(self, 0)
            .topSpaceToView(imgView, 0)
            .heightIs(30);
        
        [self setupAutoHeightWithBottomView:imgView bottomMargin:35];
        
        // 5、设置父视图
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

// 设置cell值
- (void)setActivity:(SLTypeModel *)activity{
    // 2、赋值
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:activity.imgUrl] placeholderImage:[UIImage imageNamed:@"activity_defult"]];

    [self.titleLabel setText:activity.describe]; // @"春季618超级活动"
}

@end

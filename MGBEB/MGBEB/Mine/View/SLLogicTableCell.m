//
//  SLLogicTableCell.m
//  MGBEB
//
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLLogicTableCell.h"

#import "SLHeader.h"

@interface SLLogicTableCell()

@property (nonatomic, weak) UILabel *logisLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIView *line;
@property (nonatomic, weak) UIButton *iconView;

@end

@implementation SLLogicTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"logicTableCell";
    SLLogicTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SLLogicTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//        cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 图标
        UIButton *iconView = [UIButton buttonWithType:UIButtonTypeCustom];
        iconView.frame = CGRectMake(30, 10, 20, 20);
        [iconView setBackgroundImage:[UIImage imageNamed:@"logic_icon"] forState:UIControlStateNormal];
        iconView.titleLabel.font = [UIFont systemFontOfSize: 13];
        [iconView setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        // 物流详细信息
        UILabel *logicLabel = [[UILabel alloc] init];
        logicLabel.numberOfLines = 0;
        logicLabel.font = SLCellFont3;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:12];
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, 0, kSLscreenW - 40, 1)];
//        line.backgroundColor = [UIColor blackColor];
        
        self.logisLabel = logicLabel;
        self.timeLabel = timeLabel;
//        self.line = line;
        self.iconView = iconView;
        
        [self addSubview:logicLabel];
        [self addSubview:timeLabel];
//        [self addSubview: line];
        [self addSubview: iconView];
    }
    
    return self;
}

#pragma mark -
#pragma mark 设置变量
- (void)setLogis:(SLLogisticsModel *)logis{
    _logis = logis;
    
    // 1、设置物流信息
    self.logisLabel.text = logis.logisticsDescribe;
//    self.timeLabel.text = logis.logisticsTime;
    
    // 2、计算宽高
    // 图标
    NSString *str = @"运";
    if ([logis.logisticsDescribe containsString:@"发"]) {
        str = @"发";
        [self.iconView setBackgroundImage:[UIImage imageNamed:@"logic_icon"] forState:UIControlStateNormal]; 
    } else if ([logis.logisticsDescribe containsString:@"收"]) {
        str = @"收";
        [self.iconView setBackgroundImage:[UIImage imageNamed:@"logic_icon2"] forState:UIControlStateNormal];
    }
    [self.iconView setTitle:str forState:UIControlStateNormal];
    // 物流信息
    CGSize labelSize = [self.logisLabel.text sizeWithFont:self.logisLabel.font constrainedToSize:CGSizeMake(kSLscreenW - 40, MAXFLOAT) lineBreakMode:NSLineBreakByClipping];
    self.logisLabel.frame = CGRectMake(57, 10, kSLscreenW - 40, labelSize.height);
    // 时间
    self.timeLabel.frame = CGRectMake(57, self.logisLabel.y + self.logisLabel.height + 10, kSLscreenW - 40, 10);
    self.timeLabel.attributedText = [SLStringUtil stringWithString:logis.logisticsTime font:SLCellFont3 color:SLColor(207,207,207, 255)];
    // 线
//    self.line.frame = CGRectMake(30, self.timeLabel.y + self.timeLabel.height + 5, kSLscreenW - 30, 1);
    
//    SLLog(@"时间 %@",NSStringFromCGRect(self.timeLabel.frame));
//    SLLog(@"线 %@",NSStringFromCGRect(self.line.frame));
    
    // 3、获得当前cell高度，计算当前cell的高度
    CGRect frame = [self frame];
    frame.size.height = self.timeLabel.y + 25;
    self.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

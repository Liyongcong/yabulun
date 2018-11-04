//
//  SLMessageTableCell.m
//  MGBEB
//
//  Copyright © 2018 surge. All rights reserved.
//

#import "SLMessageTableCell.h"
#import "SLHeader.h"

@interface SLMessageTableCell()

@property (nonatomic, weak) UILabel *toUserLabel;
@property (nonatomic, weak) UILabel *timeLabel;


@end

@implementation SLMessageTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"messageTableCell";
    SLMessageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SLMessageTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        //        cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *toUserLabel = [[UILabel alloc] init];
        toUserLabel.font = SLCellFont3;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = SLFont11;
        timeLabel.textColor = [UIColor grayColor];
        
        self.toUserLabel = toUserLabel;
        self.timeLabel = timeLabel;
        
        
        toUserLabel.frame = CGRectMake(15, 15, kSLscreenW - 20, 15);
        timeLabel.frame = CGRectMake(kSLscreenW - 120, 45, 120, 10);
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeLabel.frame) + 15, kSLscreenW, 1)];
        line.backgroundColor = SLColor(207,207,207, 255);
        
        [self addSubview:toUserLabel];
        [self addSubview:timeLabel];
        [self addSubview:line];
    }
    
    return self;
}

#pragma mark -
#pragma mark 设置变量
- (void)setCharLists:(SLCharList *)charLists{
    _charLists = charLists;
    
    self.toUserLabel.text = charLists.to_user;
    self.timeLabel.text = charLists.lastTime != nil? charLists.lastTime : charLists.create_time;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

//
//  SLEvaluTableCell.m
//  MGBEB
//
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLEvaluTableCell.h"

#import "SLHeader.h"

@interface SLEvaluTableCell()

@property (nonatomic, weak) UILabel *memberLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) UIImageView *starView;
@property (nonatomic, weak) UIImageView *headView;

@property (nonatomic, weak) UIView *line;

@end

@implementation SLEvaluTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"evaluTableCell";
    SLEvaluTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SLEvaluTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        //        cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *headView = [[UIImageView alloc] init];

        UILabel *memberLabel = [[UILabel alloc] init];
        memberLabel.font = SLCellFont4;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = SLCellFont5;
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.numberOfLines = 0;
        contentLabel.font = SLCellFont4;
        
        UIImageView *starView = [[UIImageView alloc] init];
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, 0, kSLscreenW - 40, 1)];
//        line.backgroundColor = [UIColor blackColor];
        
        self.memberLabel = memberLabel;
        self.timeLabel = timeLabel;
        self.contentLabel = contentLabel;
        self.starView = starView;
        self.headView = headView;
        
        [self addSubview:memberLabel];
        [self addSubview:timeLabel];
        [self addSubview:contentLabel];
        [self addSubview:starView];
        [self addSubview:headView];
    }
    
    return self;
}

- (void)setEvalu:(SLevaluModel *)evalu{
    _evalu = evalu;
    
    // 设置数据
    // 会员号码处理
//    self.memberLabel.text = evalu.memberCode;
    NSString *str1 = [evalu.memberCode substringToIndex:2];
    self.memberLabel.text = [NSString stringWithFormat:@"%@**", str1];
    
    self.timeLabel.text = [evalu.evaluationTime substringToIndex:10];
    self.contentLabel.text = evalu.evaluationContent;
    self.starView.image = [UIImage imageNamed:[NSString stringWithFormat:@"star_%ld", (long)evalu.evaluationStar]];
    self.headView.image = [UIImage imageNamed:@"head"];
    
    // 设置fream
    self.headView.frame = CGRectMake(5, 5, 30, 30);
    
    CGSize memberSize = [self.memberLabel.text sizeWithFont:self.memberLabel.font constrainedToSize:CGSizeMake(100, 20) lineBreakMode:NSLineBreakByClipping];
    self.memberLabel.frame = CGRectMake(self.headView.x + self.headView.width + 10, self.headView.y + 5, memberSize.width + 5, 20);
    
    self.timeLabel.frame = CGRectMake(kSLscreenW-85, self.memberLabel.y, 100, 20);
    
    CGSize labelSize = [self.contentLabel.text sizeWithFont:self.contentLabel.font constrainedToSize:CGSizeMake(kSLscreenW-60, MAXFLOAT) lineBreakMode:NSLineBreakByClipping];
    self.contentLabel.frame = CGRectMake(50, 50, kSLscreenW - 60, labelSize.height);
    
    self.starView.frame = CGRectMake(self.memberLabel.x + self.memberLabel.width, self.memberLabel.y, 80, 15);
    
    // 计算cell高度
    CGRect frame = [self frame];

    frame.size.height = self.contentLabel.y + labelSize.height + 10;
    self.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

//
//  SLMineTableCell.m
//  MGBEB
//
//  Created by SurgeLee on 2018/7/2.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLMineTableCell.h"

#import "SLHeader.h"

#define kSLLabelColor SLColor(60, 60, 60, 255)
#define kSLDisableColor SLColor(197, 197, 197, 255)

@interface SLMineTableCell()

@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *subLabel;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *numLabel;

@property (nonatomic, weak) UIButton *evaluBtn; // 评论按钮

@end

@implementation SLMineTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"mineTableCell";
    SLMineTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SLMineTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
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
        // 标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize: 11];
        // 商品
        UILabel *subLabel = [[UILabel alloc] init];
        subLabel.font = [UIFont systemFontOfSize: 11];
        // 描述
        UILabel *ptLabel = [[UILabel alloc] init];
        ptLabel.font = [UIFont systemFontOfSize: 11];
        ptLabel.text = @"售价:";
        ptLabel.textColor = SLColor(60, 60, 60, 255);
        // 价格
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.font = SLCellFont;
        priceLabel.textColor = SLColor(234,0,0, 255);
        // 数量
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.font = SLCellFont4;
        numLabel.textAlignment = NSTextAlignmentRight;
        
        // 评价
        UIButton *evaluBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [evaluBtn setTitleColor:kSLLabelColor forState:UIControlStateNormal];
        [evaluBtn setTitleColor:kSLDisableColor forState:UIControlStateDisabled];
        [evaluBtn setTitle:@"评价" forState:UIControlStateNormal];
        evaluBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [evaluBtn.layer setMasksToBounds:YES];
        [evaluBtn.layer setCornerRadius:5.0]; // 设置矩形四个圆角半径
        [evaluBtn.layer setBorderWidth:1.0]; // 边框宽度
        [evaluBtn addTarget:self action:@selector(evaluClick:) forControlEvents:UIControlEventTouchUpInside];
        evaluBtn.layer.borderColor = kSLDisableColor.CGColor;
        evaluBtn.enabled = NO;
        
        self.imgView = imgView;
        self.titleLabel = titleLabel;
        self.subLabel = subLabel;
        self.priceLabel = priceLabel;
        self.numLabel = numLabel;
        self.evaluBtn = evaluBtn; // 评价按钮
        
        // 3、添加到父视图
        [self addSubview:imgView];
        [self addSubview:titleLabel];
        [self addSubview:subLabel];
        [self addSubview:ptLabel];
        [self addSubview:priceLabel];
        [self addSubview:numLabel];
        [self addSubview:evaluBtn];
        
        // 4、设置布局
        imgView.sd_layout.leftSpaceToView(self, 20)
            .topSpaceToView(self, 5)
            .heightIs(100).widthIs(100);
        titleLabel.sd_layout.leftSpaceToView(imgView, 10)
            .rightSpaceToView(self, 50)
            .topSpaceToView(self, 10)
            .heightIs(25);
        subLabel.sd_layout.leftSpaceToView(imgView, 10)
            .rightSpaceToView(self, 10)
            .topSpaceToView(titleLabel, 2)
            .heightIs(25);
        ptLabel.sd_layout.leftSpaceToView(imgView, 10)
            .topSpaceToView(subLabel, 10)
            .heightIs(25).widthIs(40);
        priceLabel.sd_layout.leftSpaceToView(ptLabel, 0)
            .topSpaceToView(subLabel, 10)
            .heightIs(25).widthIs(80);
        numLabel.sd_layout.leftSpaceToView(priceLabel, 20)
            .rightSpaceToView(self, 20)
            .topSpaceToView(subLabel, 10)
            .heightIs(25);
        // 评价
        evaluBtn.sd_layout.rightSpaceToView(self, 20)
            .topEqualToView(titleLabel)
            .heightIs(15).widthIs(30);
        
//        [self setupAutoHeightWithBottomView:imgView bottomMargin:40];
        
        // 5、设置父视图
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

#pragma mark -
#pragma mark 设置变量
- (void)setSubProduct:(SLSubOrderModel *)subProduct{
    _subProduct = subProduct;
    
    NSArray *array = [subProduct.productImg componentsSeparatedByString:@";"];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:array[0]] placeholderImage:[UIImage imageNamed:@"activity_defult"]];
    self.titleLabel.text = subProduct.productName; // @"女款衣服两件";
    self.subLabel.text = subProduct.secondName; // @"120尺码";
//    self.priceLabel.text = [NSString stringWithFormat:@"%ld", subProduct.price.integerValue]; // @"150";
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingMode = NSNumberFormatterRoundFloor;
    formatter.maximumFractionDigits = 2;
    self.priceLabel.text = [formatter stringFromNumber:subProduct.price];
    
    self.numLabel.text = [NSString stringWithFormat:@"x %ld", subProduct.amount]; // @"x 2";
    
}

- (void)setOrderStatus:(NSInteger)orderStatus{
    if (orderStatus == 3) {
        self.evaluBtn.enabled = YES;
        self.evaluBtn.layer.borderColor = kSLLabelColor.CGColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark -
#pragma mark 评价
// 评价信息
- (void)evaluClick:(UIButton*) btn{
    if ([self.delegate respondsToSelector:@selector(evaluOrder:productId:prodSubId:detailImg:)]) {
        
        // 图片
        NSArray *array = [self.subProduct.productImg componentsSeparatedByString:@";"];
        
        [self.delegate evaluOrder:self.subProduct.fkOrderManage productId:self.subProduct.fkProductManageMainId prodSubId:self.subProduct.fkProductManageSub
            detailImg:array[0]];
    }
}

@end

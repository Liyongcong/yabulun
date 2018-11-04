//
//  SLCartTableCell.m
//  MGBEB
//
//  Created by SurgeLee on 2018/6/30.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLCartTableCell.h"

#import "SLHeader.h"

@interface SLCartTableCell()

//@property (nonatomic, weak) UIButton *redio;
@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *subLabel;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *numLabel;

@end

@implementation SLCartTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cartTableCell";
    SLCartTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SLCartTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
        // 选择按钮
        UIButton *redio = [UIButton buttonWithType:UIButtonTypeCustom];
        [redio setImage:[UIImage imageNamed:@"redio_normal"] forState:UIControlStateNormal];
        [redio setImage:[UIImage imageNamed:@"redio_selected"] forState:UIControlStateSelected];
        [redio addTarget:self action:@selector(redioClick:) forControlEvents:UIControlEventTouchUpInside];
//        redio.selected = NO;
        // 图片
        UIImageView *imgView = [[UIImageView alloc] init];
        // 标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize: 11];
        titleLabel.textColor = SLColor(42,42,42, 255);
        // 商品
        UILabel *subLabel = [[UILabel alloc] init];
        subLabel.font = [UIFont systemFontOfSize: 11];
        subLabel.textColor = SLColor(42,42,42, 255);
        // 价格
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.textColor = SLColor(234,0,0, 255);
        // 数量
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.font = [UIFont systemFontOfSize: 11];
        numLabel.textColor = SLColor(42,42,42, 255);
        // 按钮背景图
        UIImageView *btnBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plus_minus"]];
        // 按钮
        UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusBtn setImage:[UIImage imageNamed:@"btn_plus"] forState:UIControlStateNormal];
        [plusBtn addTarget:self action: @selector(plusBtnClick:)  forControlEvents:UIControlEventTouchUpInside];
        UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [minusBtn setImage:[UIImage imageNamed:@"btn_minus"] forState:UIControlStateNormal];
        [minusBtn addTarget:self action: @selector(minusBtnClick:)  forControlEvents:UIControlEventTouchUpInside];
        // 删除按钮
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"btn_del"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(selBtnClick:) forControlEvents:UIControlEventTouchUpInside];
          
        self.redio = redio;
        self.imgView = imgView;
        self.titleLabel = titleLabel;
        self.subLabel = subLabel;
        self.priceLabel = priceLabel;
        self.numLabel = numLabel;
        
        // 3、添加到父视图
        [self addSubview:redio];
        [self addSubview:imgView];
        [self addSubview:titleLabel];
        [self addSubview:subLabel];
        [self addSubview:priceLabel];   
        [self addSubview:btnBack];
        [self addSubview:numLabel];
        [self addSubview:plusBtn];
        [self addSubview:minusBtn];
        [self addSubview:delBtn];
        
        // 4、设置布局
        redio.sd_layout.leftSpaceToView(self, 15)
            .topSpaceToView(self, 50)
            .heightIs(20).widthIs(20);
        
        imgView.sd_layout.leftSpaceToView(redio, 10)
            .topSpaceToView(self, 10)
            .heightIs(100).widthIs(100);
        
        titleLabel.sd_layout.leftSpaceToView(imgView, 15)
            .rightSpaceToView(self, 40)
            .topSpaceToView(self, 20)
            .heightIs(25);
        subLabel.sd_layout.leftSpaceToView(imgView, 15)
            .rightSpaceToView(self, 40)
            .topSpaceToView(titleLabel, 5)
            .heightIs(25);
//        ptLabel.sd_layout.leftSpaceToView(imgView, 10)
//            .topSpaceToView(subLabel, 10)
//            .heightIs(25).widthIs(50);
        priceLabel.sd_layout.leftSpaceToView(imgView, 15)
            .topSpaceToView(subLabel, 5)
            .heightIs(25).widthIs(80);
        btnBack.sd_layout.rightSpaceToView(self, 15)
            .bottomSpaceToView(self, 15)
            .heightIs(25).widthIs(75);
        plusBtn.sd_layout.rightSpaceToView(self, 15)
            .bottomSpaceToView(self, 15)
            .heightIs(25).widthIs(24);
        numLabel.sd_layout.rightSpaceToView(plusBtn, 1)
            .bottomSpaceToView(self, 15)
            .heightIs(25).widthIs(24);
        minusBtn.sd_layout.rightSpaceToView(numLabel, 1)
            .bottomSpaceToView(self, 15)
            .heightIs(25).widthIs(24);
        
        delBtn.sd_layout.rightSpaceToView(self, 13)
            .topSpaceToView(self, 10)
            .heightIs(13).widthIs(12);
//        lineImg.sd_layout.rightSpaceToView(delBtn, 5)
//            .topSpaceToView(numLabel, 10)
//            .heightIs(30).widthIs(5);
//        editBtn.sd_layout.rightSpaceToView(lineImg, 5)
//            .topSpaceToView(numLabel, 10)
//            .heightIs(30).widthIs(40);
        
//        [self setupAutoHeightWithBottomView:imgView bottomMargin:40];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = SLColor(241,241,241, 255);
        [self addSubview:lineView];
        lineView.sd_layout.rightSpaceToView(self, 0)
            .bottomSpaceToView(self, 0)
            .heightIs(1).widthIs(kSLscreenW);
        
        // 5、设置父视图
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)redioClick:(UIButton *)btn{
    self.redio.selected = !btn.selected;
    
    // 产品订单选中状态变化
    if ([self.delegate respondsToSelector:@selector(productSelect:isSelect:)]) {
        self.subProduct.amount = self.numLabel.text.integerValue; // 设置产品数量
        double tPrice = self.subProduct.price.doubleValue * self.subProduct.amount;
        self.subProduct.totalPrie = [NSNumber numberWithDouble:tPrice]; // 计算价格
        [self.delegate productSelect:self.subProduct isSelect:self.redio.selected];
    }
}

#pragma mark -
#pragma mark 设置变量
- (void)setSubProduct:(SLSubOrderModel *)subProduct{
    _subProduct = subProduct;
    
    NSArray *array = [subProduct.productImg componentsSeparatedByString:@";"];
    self.redio.selected = subProduct.selStatus;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:array[0]] placeholderImage:[UIImage imageNamed:@"activity_defult"]];
    self.titleLabel.text = subProduct.productName;
    self.subLabel.text = subProduct.secondName;
//    self.priceLabel.text = [NSString stringWithFormat:@"%ld", (long)subProduct.price.integerValue];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingMode = NSNumberFormatterRoundFloor;
    formatter.maximumFractionDigits = 2;
    self.priceLabel.text = [formatter stringFromNumber:subProduct.price];
    
    self.numLabel.text = [NSString stringWithFormat:@"%ld", (long)subProduct.amount];
    
}

- (void)plusBtnClick:(UIButton*)button {
    NSInteger count = [self.numLabel.text integerValue];
    count ++;
    self.numLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
    self.subProduct.amount = self.numLabel.text.integerValue; // 设置产品数量
    double tPrice = self.subProduct.price.doubleValue * self.subProduct.amount;
//    self.subProduct.totalPrie = [NSNumber numberWithDouble:tPrice]; // 计算价格
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingMode = NSNumberFormatterRoundFloor;
    formatter.maximumFractionDigits = 2;
    self.subProduct.totalPrie = [formatter numberFromString:[NSString stringWithFormat:@"%f", tPrice]];
    // 在选中情况下修改产品数量
//    if (self.redio.selected) {
//        if ([self.delegate respondsToSelector:@selector(productChange:number:)]) {
//            [self.delegate productChange:self.subProduct number:count];
//        }
//    }
    if ([self.delegate respondsToSelector:@selector(productChange:number:)]) {
        [self.delegate productChange:self.subProduct number:count];
    }
}

- (void)minusBtnClick:(UIButton*)button {
    NSInteger count = [self.numLabel.text integerValue];
    if (count > 1) {
        count --;
    }
    self.numLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
    self.subProduct.amount = self.numLabel.text.integerValue; // 设置产品数量
    double tPrice = self.subProduct.price.doubleValue * self.subProduct.amount;
//    self.subProduct.totalPrie = [NSNumber numberWithDouble:tPrice]; // 计算价格
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingMode = NSNumberFormatterRoundFloor;
    formatter.maximumFractionDigits = 2;
    self.subProduct.totalPrie = [formatter numberFromString:[NSString stringWithFormat:@"%f", tPrice]];
    
    // 在选中情况下修改产品数量
//    if (self.redio.selected) {
//        if ([self.delegate respondsToSelector:@selector(productChange:number:)]) {
//            [self.delegate productChange:self.subProduct number:count];
//        }
//    }
    if ([self.delegate respondsToSelector:@selector(productChange:number:)]) {
        [self.delegate productChange:self.subProduct number:count];
    }
}

// 删除购物车
- (void)selBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(productDel:)]) {
        [self.delegate productDel:self.subProduct];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

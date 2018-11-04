//
//  SLSubProductView.m
//  MGBEB
//
//  Created by SurgeLee on 2018/6/28.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLSubProductView.h"

#import "SLHeader.h"

@interface SLSubProductView() <UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *showLabel;
@property (nonatomic, strong) UILabel *countLabel;

// 选中的按钮
@property (nonatomic, strong) UIButton *selectBtn;
// 选中的产品
@property (nonatomic, strong) SLSubProductModel *selectSub;

// 容器
@property (nonatomic, strong) UIScrollView *subScrollView;



@end

@implementation SLSubProductView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    // 1.设置颜色
    self.backgroundColor = [UIColor whiteColor];
    // 2.添加按钮
    [self setupBottom];
    // 3.设置显示内容
    [self setupCenter];
    
}

- (void)setupBottom{
    UIButton *reset = [UIButton buttonWithType:UIButtonTypeCustom];
    [reset setTitle:@"取消" forState:UIControlStateNormal];
    [reset setBackgroundColor:[UIColor lightGrayColor]];
    [reset addTarget:self action:@selector(resetContent:) forControlEvents:UIControlEventTouchDown];
    
    UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure setBackgroundColor:[UIColor redColor]];
    [sure addTarget:self action:@selector(sureContent:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:reset];
    [self addSubview:sure];
    
    [reset setFrame:CGRectMake(0, self.height - 50, self.width/2, 50)];
    [sure setFrame:CGRectMake(self.width/2, self.height - 50, self.width/2, 50)];
}

- (void)setupCenter{
    // 1. 容器
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 50)];
//    [view setBackgroundColor:[UIColor redColor]];
    [self addSubview:view];
    
    SLLog(@"%@", NSStringFromCGRect(view.frame));
    
    // 2. 品类容器
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 140)];
//    [scrollView setBackgroundColor:[UIColor greenColor]];
    scrollView.showsVerticalScrollIndicator = NO;
    self.subScrollView = scrollView;
    [view addSubview:scrollView];

    // 3. 创建品类
    CGFloat marginF = 15;
//    NSInteger count = self.subProducts.count;
//    CGFloat marginF = 15;
//    for (int i = 0; i < count; ++i) {
//        SLSubProductModel *sub = self.subProducts[i];
//
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        CGFloat childW = self.frame.size.width - marginF *2;
//        CGFloat childH = 40;
//        CGFloat childX = marginF;
//        CGFloat childY = marginF + i * (1 + childH);
//        btn.frame = CGRectMake(childX, childY, childW, childH);
//        [btn setTitle:[NSString stringWithFormat:@"   %@ ", sub.secondName] forState:UIControlStateNormal];
//        [btn setBackgroundImage: [UIImage imageNamed:@"select_btn"] forState:UIControlStateNormal];
//        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [btn setTitleColor:SLColor(140, 140, 140, 255) forState:UIControlStateNormal];
//
//        [btn setBackgroundImage: [UIImage imageNamed:@"select_btn_selectd"] forState:UIControlStateSelected];
//        [btn setTitleColor:SLColor(231, 98, 173, 255) forState:UIControlStateSelected];
//
//        btn.tag = i; // 这是成id
//        [btn addTarget:self action: @selector(subProductClick:)  forControlEvents:UIControlEventTouchUpInside];
//
//        [scrollView addSubview:btn];
//
//    }
//    scrollView.contentSize = CGSizeMake(0, 40 * (count + 1));

    // 添加标签
    UIView *labelView =[[UIView alloc] initWithFrame:CGRectMake(0, self.height - 130, view.width, 80)];
//    labelView.backgroundColor = [UIColor orangeColor];
    [view addSubview:labelView];

    UILabel *selectLabel = [[UILabel alloc] init];
    selectLabel.text = @"已选择:";
    selectLabel.font = [UIFont systemFontOfSize:16];
    selectLabel.textColor = SLColor(88, 88, 88, 255);
    
    UILabel *showLabel = [[UILabel alloc] init];
    showLabel.text = @"没有选择商品";
    showLabel.font = [UIFont systemFontOfSize:16];
    showLabel.textColor = SLColor(88, 88, 88, 255);
    showLabel.textAlignment = NSTextAlignmentRight;
    self.showLabel = showLabel;
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.text = @"数量:";
    numLabel.font = [UIFont systemFontOfSize:16];
    numLabel.textColor = SLColor(88, 88, 88, 255);
    
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusBtn setImage:[UIImage imageNamed:@"plus_btn"] forState:UIControlStateNormal];
    plusBtn.backgroundColor = SLColor(217, 217, 217, 255);
    [plusBtn addTarget:self action: @selector(plusBtnClick:)  forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.text = @"1"; // 默认1条
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.font = [UIFont systemFontOfSize:16];
    countLabel.textColor = SLColor(88, 88, 88, 255);
    self.countLabel = countLabel;
    
    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [minusBtn setImage:[UIImage imageNamed:@"minus_btn"] forState:UIControlStateNormal];
    minusBtn.backgroundColor = SLColor(217, 217, 217, 255);
    [minusBtn addTarget:self action: @selector(minusBtnClick:)  forControlEvents:UIControlEventTouchUpInside];

    [labelView addSubview:selectLabel];
    [labelView addSubview:showLabel];
    [labelView addSubview:numLabel];
    [labelView addSubview:plusBtn];
    [labelView addSubview:countLabel];
    [labelView addSubview:minusBtn];

    [selectLabel setFrame:CGRectMake(marginF, 0, 60, 35)];
    [showLabel setFrame:CGRectMake(80, 0, labelView.width - 100, 35)];
    [numLabel setFrame:CGRectMake(marginF, selectLabel.y + 35, 50, 40)];
    [plusBtn setFrame:CGRectMake(labelView.width - 60, numLabel.y, 45, 40)];
    [countLabel setFrame:CGRectMake(labelView.width - 105, numLabel.y, 45, 40)];
    [minusBtn setFrame:CGRectMake(labelView.width - 150, numLabel.y, 45, 40)];

}

#pragma mark -
#pragma mark 点击按钮事件

- (void)resetContent:(UIButton*)button {
    
    if ([self.delegate respondsToSelector:@selector(resetClick:subProduct:)]) {
        [self.delegate resetClick:button subProduct:nil];
    }
}

- (void)sureContent:(UIButton*)button {
    
    if (self.selectSub == nil || [self.countLabel.text isEqualToString:@"0"]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(sureClick:subProduct:num:)]) {
        [self.delegate sureClick:button subProduct:self.selectSub num:[self.countLabel.text integerValue]];
    }
}

- (void)subProductClick:(UIButton*)button {
    
    SLLog(@"选择：%ld", button.tag);

    self.showLabel.text = button.titleLabel.text;
    
    // 显示状态
    [button setSelected: YES];
    [self.selectBtn setSelected: NO];
    self.selectBtn = button;
    
    self.selectSub = self.subProducts[button.tag];
}

- (void)plusBtnClick:(UIButton*)button {
    NSInteger count = [self.countLabel.text integerValue];
    count ++;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", count];
}

- (void)minusBtnClick:(UIButton*)button {
    NSInteger count = [self.countLabel.text integerValue];
    if (count > 0) {
        count --;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%ld", count];
}

// 设置页面数据
- (void)setSubProducts:(NSMutableArray *)subProducts {
    _subProducts = subProducts;
    
    NSInteger count = subProducts.count;
    CGFloat marginF = 15;
    for (int i = 0; i < count; ++i) {
        SLSubProductModel *sub = subProducts[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat childW = self.frame.size.width - marginF *2 - 100;
        CGFloat childH = 40;
        CGFloat childX = marginF;
        CGFloat childY = marginF + i * (1 + childH);
        btn.frame = CGRectMake(childX, childY, childW, childH);
        [btn setTitle:[NSString stringWithFormat:@"   %@ ", sub.secondLevelName] forState:UIControlStateNormal];
        [btn setBackgroundImage: [UIImage imageNamed:@"select_btn"] forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setTitleColor:SLColor(140, 140, 140, 255) forState:UIControlStateNormal];
        
        [btn setBackgroundImage: [UIImage imageNamed:@"select_btn_selectd"] forState:UIControlStateSelected];
        [btn setTitleColor:SLColor(231, 98, 173, 255) forState:UIControlStateSelected];
        
        btn.tag = i; // 设置成id
        [btn addTarget:self action: @selector(subProductClick:)  forControlEvents:UIControlEventTouchUpInside];
        
        // 添加价格
        UILabel *price = [[UILabel alloc] init];
        CGFloat childW2 = 100 - marginF;
        CGFloat childH2 = 40;
        CGFloat childX2 = childW + marginF;
        CGFloat childY2 = marginF + i * (1 + childH);
        price.frame = CGRectMake(childX2, childY2, childW2, childH2);
        price.text = [NSString stringWithFormat:@"￥ %@",[sub.price stringValue]]; // 设置价格
        price.textAlignment = NSTextAlignmentRight;
        
        [self.subScrollView addSubview:btn];
        [self.subScrollView addSubview:price];
    }
    self.subScrollView.contentSize = CGSizeMake(0, 40 * (count + 1));
}

@end

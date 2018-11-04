//
//  SLClassifyView.m
//  MGBEB
//
//  Created by SurgeLee on 2018/6/20.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLClassifyView.h"

#import "SLHeader.h"

#import "SLClassifyButton.h"


@interface SLClassifyView()

/**
 *  保存当前选中按钮
 */
@property (nonatomic, weak) UIButton *currenSelectedBtn;

/**
 *  存储所有的选项卡按钮
 */
@property (nonatomic, strong) NSMutableArray *btns;

@end

@implementation SLClassifyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

//        long count = self.types.count < 10 ? self.types.count : 10;
//        for (long i = 0; i < count; i++) {
//            // 创建类型按钮
//            [self addType:_types[i]];
//        }
//        for (long i = 0; i < 10; i++) {
//            // 创建类型按钮
//            [self addType:[[SLTypeModel alloc] init]];
//        }
    }
    return self;
}

- (void)addTypeBtn:(NSArray *)models{
    for (long i = 1; i < models.count - 1; i++) {
        // 创建类型按钮
        SLTypeModel *m = models[i];
        m.iconUrl = [NSString stringWithFormat:@"icon_home_%02ld", i];// @"icon_type_defult";//
        [self addType:models[i]];
    }
}

// 布局
- (void)layoutSubviews{
    
    NSUInteger index = 0;
    
    for (UIView *child in self.subviews) {
        if (child.tag != 998) {
            // 1.计算每个按钮的frame
            CGFloat childW = self.frame.size.width / 5;
            CGFloat childH = self.frame.size.height / 2;
            CGFloat childX = (index % 5) * childW;
            CGFloat childY = (index / 5) * childH;
            index++;
            child.frame = CGRectMake(childX, childY, childW, childH);
        }
    }
}

- (void)addType:(SLTypeModel *)model
{
    // 1.创建按钮
    SLClassifyButton *btn = [[SLClassifyButton alloc] init];
    
    // 2.设置按钮属性
    // 2.1.创建按钮（UIButton）
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    // 2.2.给按钮设置文字
    [btn setTitle:model.typeName forState:UIControlStateNormal];
    // 2.3.设置颜色
    [btn setTitleColor:[UIColor darkGrayColor]  forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor]  forState:UIControlStateSelected];
    // 2.4.设置默认状态下的背景图片
    UIImage *imageNarmal = [UIImage imageNamed:model.iconUrl];
//    [btn setBackgroundImage:imageNarmal forState:UIControlStateNormal];
//    [btn sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_type_defult"]];
//    [btn sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] forState:UIControlStateSelected placeholderImage:[UIImage imageNamed:@"icon_type_defult"]];
    [btn setImage:imageNarmal forState:UIControlStateNormal];
    [btn setImage:imageNarmal forState:UIControlStateSelected];
//    btn.layer.cornerRadius = 20;  //设置按钮的拐角为宽的一半
//    btn.layer.masksToBounds = YES;
    // 2.5.把动态创建的按钮加到控制器所管理的那个view中
    [self addSubview:btn];
    
    // 3.添加监听事件
    [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchDown];
    
    // 3.添加按钮到当前view
    [self addSubview:btn];
    
    // 4.将按钮添加到数组中
//    btn.tag = self.types.count; // 0 1 2 3 4
    btn.tag = [model.idstr integerValue];
    [self.btns addObject:btn]; // 1
}

- (void)btnOnClick:(UIButton *)btn
{
    // 1.切换控制器, 通知控制器
    if ([self.delegate respondsToSelector:@selector(calssifyView:selectedBtnFrom:to:)]) {
        [self.delegate calssifyView:self selectedBtnFrom:self.currenSelectedBtn.tag to:btn.tag];
    }
    
    // 2.切换按钮的状态
    // 取消上一次选中
    self.currenSelectedBtn.selected = NO;
    // 选中当前点击的按钮
    btn.selected = YES;
    // 记录当前选中的按钮
    self.currenSelectedBtn = btn;
}

#pragma mark -
#pragma mark 懒加载

- (NSMutableArray *)types{
    if (!_types) {
        _types = [NSMutableArray array];
    }
    return _types;
}

@end

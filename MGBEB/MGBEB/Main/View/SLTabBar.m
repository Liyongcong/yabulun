//
//  SLTabBar.m
//
//  Created by SurgeLee on 2018/6/17.
//  Copyright © 2018年 mgood. All rights reserved.
//

#import "SLTabBar.h"

#import "SLHeader.h"

#import "SLTabBarButton.h"
#import "UIView+Frame.h"

@interface SLTabBar ()

/**
 *  保存当前选中按钮
 */
@property (nonatomic, weak) UIButton *currenSelectedBtn;

///**
// *  存储所有的选项卡按钮
// */
//@property (nonatomic, strong) NSMutableArray *btns;

@end

@implementation SLTabBar

// 通过代码创建控件时会调用
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

// 通过xib/Storboard创建时调用
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    // 1.设置背景颜色
    self.backgroundColor = [UIColor whiteColor];
}

- (void)addItem:(UITabBarItem *)item
{
    // 1.创建选项卡按钮
    SLTabBarButton *btn = [[SLTabBarButton alloc] init];
    
    // 2.设置按钮属性
    btn.item = item;
    
    // 3.添加监听事件
    [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchDown];
    
    // 3.添加按钮到当前view
    [self addSubview:btn];
    
    // 4.将按钮添加到数组中
    btn.tag = self.btns.count; // 0 1 2 3 4
    [self.btns addObject:btn]; // 1
    
    if (self.btns.count == 1) {
        [self btnOnClick:btn];
    }

//    // 5.设置默认选中按钮
//    // 默认情况下subviews.count等于0, 只要添加了一个按钮那么就代表肯定是第一个
//    if (self.subviews.count == 1) {
//        [self btnOnClick:btn];
//    }
    
}

- (void)btnOnClick:(UIButton *)btn
{
    // 1.切换控制器, 通知tabbarcontroller
    if ([self.delegate respondsToSelector:@selector(tabBar:selectedBtnFrom:to:)]) {
        [self.delegate tabBar:self selectedBtnFrom:self.currenSelectedBtn.tag to:btn.tag];
    }
    
    // 2.切换按钮的状态
    // 取消上一次选中
    self.currenSelectedBtn.selected = NO;
    // 选中当前点击的按钮
    btn.selected = YES;
    // 记录当前选中的按钮
    self.currenSelectedBtn = btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置其他选项卡按钮的frame
    NSUInteger index = 0;
    for (UIView *child in self.subviews) {
        
        if (child.tag != 998) {
            
            // 2.计算每个按钮的frame
            CGFloat childW = self.frame.size.width / 4;
            CGFloat childH = self.frame.size.height;
            CGFloat childX = index * childW;
            CGFloat childY = 0;
            index++;
            child.frame = CGRectMake(childX, childY, childW, childH);
        }
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)btns
{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

@end

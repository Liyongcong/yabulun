//
//  SLTabBarButton.m
//
//  Created by SurgeLee on 2018/6/17.
//  Copyright © 2018年 mgood. All rights reserved.
//

#import "SLClassifyButton.h"

#import "SLHeader.h"

@interface SLClassifyButton ()

@end

@implementation SLClassifyButton


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
    // 设置图片居中
    self.imageView.contentMode = UIViewContentModeCenter;
    // 设置标题居中
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    // 设置文字字体大小
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    
    // 设置按钮标题颜色
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self setTitleColor:SLColor(28,117, 214, 255) forState:UIControlStateSelected];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * 0.8;
    CGFloat imageX = 0;
    CGFloat imageY = 10;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    // 如果相对自定义按钮通过transform进行缩放, 那么不能在自定义按钮中访问self.frame
    // Y = 按钮的高度 - 图片的高度
    CGFloat titleY = contentRect.size.height* 0.8;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - contentRect.size.height * 0.8;
    CGFloat titleX = 0;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

-(void)setHighlighted:(BOOL)highlighted
{
    
}

@end

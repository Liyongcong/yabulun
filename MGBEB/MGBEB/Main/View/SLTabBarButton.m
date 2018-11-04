//
//  SLTabBarButton.m
//
//  Created by SurgeLee on 2018/6/17.
//  Copyright © 2018年 mgood. All rights reserved.
//

#import "SLTabBarButton.h"

#import "SLHeader.h"

@interface SLTabBarButton ()

/**
 *  提醒按钮
 */
@property (nonatomic, weak) UIButton *badgeBtn;

@end

@implementation SLTabBarButton


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
    
    // 添加提醒按钮
    UIButton *badgeBtn = [[UIButton alloc] init];
    [badgeBtn setBackgroundImage:[UIImage imageNamed:@"badge"] forState:UIControlStateNormal];
    badgeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    badgeBtn.titleLabel.font = [UIFont systemFontOfSize:7];
    badgeBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:8];
    [badgeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    badgeBtn.hidden = YES;
    [self addSubview:badgeBtn];
    self.badgeBtn = badgeBtn;
}

// - (void)layoutSubviews
// {
//     [super layoutSubviews];
//
//     self.imageView.y  = 0;
//     self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
//     self.titleLabel.centerX = self.imageView.centerX;
// }

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.badgeBtn.size = CGSizeMake(22, 22);
    self.badgeBtn.y = 4;
    self.badgeBtn.x = self.width/2 + 10;
    //self.width - self.badgeBtn.width - 10;
//    SLLog(@"提醒按钮的大小  %@ ", self.badgeBtn);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * 0.55;
    CGFloat imageX = 0;
    CGFloat imageY = 5;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
//#warning 如果相对自定义按钮通过transform进行缩放, 那么不能在自定义按钮中访问self.frame
    // Y = 按钮的高度 - 图片的高度
    CGFloat titleY = contentRect.size.height* 0.65;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - contentRect.size.height * 0.7;
    CGFloat titleX = 0;
    return CGRectMake(titleX, titleY, titleW, titleH);
}


- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    [self setTitle:item.title forState:UIControlStateNormal];
    [self setImage:item.image forState:UIControlStateNormal];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
    
    // 利用KVO监听UITabBarItem属性的改变
    [item addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)setHighlighted:(BOOL)highlighted
{
    
}

#pragma mark -
#pragma mark 提醒

- (void)dealloc
{
    [_item removeObserver:self forKeyPath:@"badgeValue"];
}

/**
 *  监听到某个被监听对象的指定属性改变时调用
 *
 *  @param keyPath 被监听的属性
 *  @param object  被监听的对象
 *  @param change  改变的值
 *  @param context 监听时传入的参数
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    SLLog(@"%@", change);
    NSNumber *number = change[@"new"];
    if (number.intValue > 0) {
        self.badgeBtn.hidden = NO;
        if (number.intValue > 99) {
            [self.badgeBtn setTitle:@"N" forState:UIControlStateNormal];
        } else {
            [self.badgeBtn setTitle:[number description] forState:UIControlStateNormal];
        }
    } else {
        self.badgeBtn.hidden = YES;
    }
    
}

@end

//
//  UIBarButtonItem+Extension.m
//
//  Created by SurgeLee on 2018/4/17.
//  Copyright © 2018年 mgood. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Frame.h"

@implementation UIBarButtonItem (Extension)

/**
 *  创建UIBarButtonItem
 *
 *  @param image    默认状态图片
 *  @param higImage 高亮状态图片
 *
 *  @return item
 */
+ (UIBarButtonItem *)itemWithImage:(NSString *)image higImage:(NSString *)higImage target:(id)target action:(SEL)action
{
    UIButton *btn = [[UIButton alloc] init];
    // 设置对应状态图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:higImage] forState:UIControlStateHighlighted];
    // 设置frame
//    btn.size = btn.currentImage.size;
    btn.size = CGSizeMake(20, 20);
    // 添加监听事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end

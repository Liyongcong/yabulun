//
//  UIBarButtonItem+Extension.h
//
//  Created by SurgeLee on 2018/4/17.
//  Copyright © 2018年 mgood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

/**
 *  创建UIBarButtonItem
 *
 *  @param image    默认状态图片
 *  @param higImage 高亮状态图片
 *  @param action  监听方法
 *  @param target 监听对象
 *  @return item
 */
+ (UIBarButtonItem *)itemWithImage:(NSString *)image higImage:(NSString *)higImage  target:(id)target action:(SEL)action;
@end

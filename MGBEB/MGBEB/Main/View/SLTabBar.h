//
//  SLTabBar.h
//
//  Created by SurgeLee on 2018/6/17.
//  Copyright © 2018年 mgood. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SLTabBar;

@protocol SLTabBarDelegate <NSObject>

/**
 用于监听自定义TabBar按钮的点击事件

 @param tabBar 触发事件的控件
 @param from 以前按钮的索引
 @param to 当前点击按钮的索引
 */
- (void)tabBar:(SLTabBar *)tabBar selectedBtnFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface SLTabBar : UIView

/**
 添加一个按钮

 @param item 按钮需要显示的数据
 */
- (void)addItem:(UITabBarItem *)item;

@property (nonatomic, weak) id<SLTabBarDelegate> delegate;


// 10-09
/**
 *  存储所有的选项卡按钮
 */
@property (nonatomic, strong) NSMutableArray *btns;

- (void)btnOnClick:(UIButton *)btn;

@end

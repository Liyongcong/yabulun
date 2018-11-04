//
//  SLTabBarController.m
//
//  Created by SurgeLee on 2018/6/1.
//  Copyright © 2018年 mgood. All rights reserved.
//

#import "SLNavigationController.h"

#import "SLHeader.h"
#import "UIBarButtonItem+Extension.h"

@interface SLNavigationController ()

@end

@implementation SLNavigationController

+ (void)initialize
{
    // 设置整个项目所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置普通状态
    // key：NS****AttributeName
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = SLColor(28,117, 214, 255);
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
    disableTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    // 设置导航条颜色 以及 标题颜色
    // 设置标题栏颜色（失败）
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.translucent = NO;
//    bar.barTintColor = SLColor(28, 119, 215, 255);
    [bar setBackgroundImage:[UIImage imageNamed:@"nav_back"] forBarMetrics:UIBarMetricsDefault];
    
    // 字体颜色
    bar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]
                                , NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        /* 设置导航栏上面的内容 */
        // 设置左边的返回按钮
//        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"navigationbar_back" higImage:@"navigationbar_back_highlighted" target:self action:@selector(back)];
//        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"navigationbar_more" higImage:@"navigationbar_more_highlighted" target:self action:@selector(more)];
    }

    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    // 这里要用self，不是self.navigationController
    // 因为self本来就是一个导航控制器，self.navigationController这里是nil的
    [self popViewControllerAnimated:YES];
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}
@end

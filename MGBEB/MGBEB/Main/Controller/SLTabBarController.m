//
//  SLTabBarController.m
//
//  Created by SurgeLee on 2018/4/17.
//  Copyright © 2018年 mgood. All rights reserved.
//

#import "SLTabBarController.h"

#import "SLHeader.h"
// 控制器
#import "SLNavigationController.h"
#import "SLHomeViewController.h"
#import "SLClassifyViewController.h"
#import "SLMineViewController.h"
#import "SLCartViewController.h"

#import "AppDelegate.h"
#import "SLStringUtil.h"

@interface SLTabBarController () <SLTabBarDelegate>

//@property (nonatomic, strong) SLMessageController *message;

@end

@implementation SLTabBarController

// code 或 xib 加载的时候回调用
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [self addControllerWithClass:[SLHomeViewController class] title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
        [self addControllerWithClass:[SLClassifyViewController class] title:@"分类" image:@"tabbar_classify" selectedImage:@"tabbar_classify_selected"];
        [self addControllerWithClass:[SLCartViewController class] title:@"购物车" image:@"tabbar_cart" selectedImage:@"tabbar_cart_selected"];
        [self addControllerWithClass:[SLMineViewController class] title:@"我的" image:@"tabbar_mine" selectedImage:@"tabbar_mine_selected"];    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.创建自定义SLTabBar
    SLTabBar *tabBar = [[SLTabBar alloc] init];
    tabBar.delegate = self;
    // 2.设置TabBar的frame
//    tabBar.frame = self.tabBar.frame;
    tabBar.frame = CGRectMake(0, self.view.height-60, self.view.width, 60);
    // 3.添加TabBar到父控件
    [self.view addSubview:tabBar];
    self.customTabBar = tabBar;
    // 4.移除系统自带的tabbar
    [self.tabBar removeFromSuperview];
    
    // 5.创建菜单视图
  
}

- (void)viewWillAppear:(BOOL)animated{
    // 版本判断
    [self versionCheck];
}

/**
 * 隐藏工具条
 */
-(void)viewDidAppear:(BOOL)animated
{
    [self.tabBar removeFromSuperview];
}

#pragma mark -
#pragma mark  添加控制器

- (UIViewController *)addControllerWithNibName:(NSString *)name title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    UIStoryboard *sb =[UIStoryboard storyboardWithName:name bundle:nil];
    UIViewController *vc = [sb instantiateInitialViewController];
    return [self addControllerWithVc:vc title:title image:image selectedImage:selectedImage];
}

- (UIViewController *)addControllerWithClass:(Class)class title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    /*
     注意: 不是所有的控制器都是通过init方法初始化的
     */
    UIViewController *vc = [[class alloc] init];
    return [self addControllerWithVc:vc title:title image:image selectedImage:selectedImage];
}

/**
 *  添加底部控制器
 */
- (UIViewController *)addControllerWithVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    
    /*
     iOS7需要通过代码告诉系统不要用tabBar.tintColor来渲染选中图片
     */
    // 1.创建图片
    UIImage *newImage =  [UIImage imageNamed:selectedImage];
    // 2.告诉系统原样显示
    newImage = [newImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 3.设置图片
    childVc.tabBarItem.selectedImage = newImage;
    
    // 设置文字的样式
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[NSForegroundColorAttributeName] = SLColor(0, 0, 0, 0);
//    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
//    selectTextAttrs[NSForegroundColorAttributeName] = SLColor(28,117, 214, 255);
//    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
//    childVc.view.backgroundColor = SLRandomColor;
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    SLNavigationController *nav = [[SLNavigationController alloc] initWithRootViewController:childVc];
    
    // 添加控制器到tabbarcontroller
    [self addChildViewController:nav];
    
    // 每添加一个子控制器就要创建一个对应的按钮
    [self.customTabBar addItem: childVc.tabBarItem];
    
    return childVc;
}

#pragma mark -
#pragma mark - SLTabBarDelegate
- (void)tabBar:(SLTabBar *)tabBar selectedBtnFrom:(NSInteger)from to:(NSInteger)to
{
    // 切换控制器
    // 1.取出当前选中按钮对应的控制器
    UIViewController *vc = self.childViewControllers[to];
    self.selectedViewController = vc;
    
    SLLog(@"%tu==>%tu", from, to );
    // 2. 直接切换
    self.selectedIndex = to;
    
    // tabbar中装的是nav， 需要显示跟控制器
//    UINavigationController *vc = self.childViewControllers[to];
//    SLLog(@"子控制器== %@", self.childViewControllers);
//    [vc popToRootViewControllerAnimated:YES];
//    self.selectedViewController = vc;
}

- (void)versionCheck {
    
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
    parameters[@"appos"] = @"iOS";
    // 3.发送请求
    NSString *urlString = @"sys/version";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
//        SLLog(@"版本数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            if ([result[@"info"][@"isRequired"] intValue] == 1) {
                [self versionUpgrade: result[@"info"][@"version"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
    
}

- (void)versionUpgrade: (NSString*) version{
    
    // 1、获取当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    SLLog(@"版本号1 = %@", version);
    SLLog(@"版本号2 = %@", app_Version);
    
    // 2、版本号对比
    Boolean isUpgrade = false;
    if ([SLStringUtil versionCompareFirst:version andVersionSecond:app_Version] == 1) {
        isUpgrade = true;
    }
    
    // 3、弹出确认框
    if (isUpgrade) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请更新至最新版本！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self gotoAppStore];
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)gotoAppStore{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/1409483617"]];
}

// APP 强制升级
- (void)exitApplication {
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    //exit(0);
}

@end

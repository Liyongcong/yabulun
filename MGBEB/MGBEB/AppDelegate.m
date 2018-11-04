//
//  AppDelegate.m
//  MGBEB
//
//  Created by SurgeLee on 2018/5/29.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "AppDelegate.h"

#import "SLUserModel.h"

#import "SLTabBarController.h"
#import "SLLoginViewController.h"


@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 0 集成IM
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"YBL1022";
#else
    apnsCertName = @"YBL1022F";
#endif
    
    EMOptions *options = [EMOptions optionsWithAppkey:@"1123181017177027#mg-ybl"];
    options.apnsCertName = apnsCertName;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    // 1.创建Windows
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    // 2.显示Windows
    [self.window makeKeyAndVisible];
    
    // 获取用户信息
    SLUserModel *user = [SLUserModel achieveUser];
    
    if (!user) { // 用户未登录

        // 1、获取跟视图
        SLLoginViewController *loginVC = [[SLLoginViewController alloc] init];
        // 2、设置根视图
        self.window.rootViewController = loginVC;
     
    } else {
        // 获取跟视图
        SLTabBarController *tabBarVC = [[SLTabBarController alloc] init];
        // 设置根视图
        self.window.rootViewController = tabBarVC;
    }

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

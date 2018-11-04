//
//  SLTabBarController.h
//
//  Created by SurgeLee on 2018/4/17.
//  Copyright © 2018年 mgood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLHeader.h"
#import "SLTabBar.h"

@interface SLTabBarController : UITabBarController

// 自定义工具条
@property (nonatomic, weak) SLTabBar *customTabBar;


@end


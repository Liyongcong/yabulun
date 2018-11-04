//
//  SLHeader.h
//  MGCRM
//
//  Created by SurgeLee on 2018/5/3.
//  Copyright © 2018年 mgood. All rights reserved.
//

/*
 * 公共头文件
 */
// 框架相关
#import "SLNetWorkTools.h"
#import <YYModel/YYModel.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <UIButton+WebCache.h>
#import <UIImageView+WebCache.h>
#import <SDAutoLayout.h> // 自动布局
// 工具类
#import "SLTextSizeTools.h" //计算文本高度
#import "UIView+Frame.h" // 计算Fream分类
#import "SLStringUtil.h"

/*
 * 定义宏
 */

#ifndef SLHeader_h
#define SLHeader_h

#endif /* SLHeader_h */

/*
 * 设置Dlog可以打印出类名,方法名,行数.
 */
#ifdef DEBUG
#define SLLog(FORMAT, ...) NSLog((@"%s [Line %d] " FORMAT), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define SLLog(...)
//#define SLLog(FORMAT, ...) nil
#endif

/*
 * 屏幕大小
 */
#define kSLscreenS [UIScreen mainScreen].bounds.size
#define kSLscreenW [UIScreen mainScreen].bounds.size.width
#define kSLscreenH [UIScreen mainScreen].bounds.size.height

/*
 * 颜色
 */
// 1.快速创建颜色
#define SLColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
// 2.随机颜色
#define SLRandomColor SLColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
// 3.查询条件 灰色
#define SLColorConditionGray [UIColor colorWithRed:(236)/255.0 green:(239)/255.0 blue:(243)/255.0 alpha:(255)/255.0]
//// 3.查询条件 灰色
//#define SLColorConditionGray(r, g, b, a) [UIColor colorWithRed:(236)/255.0 green:(239)/255.0 blue:(243)/255.0 alpha:(a)/255.0];

// cell 中字体大小
#define SLCellFont [UIFont systemFontOfSize:15]
#define SLCellFont2 [UIFont systemFontOfSize:16]
#define SLCellFont3 [UIFont systemFontOfSize:14]
#define SLCellFont4 [UIFont systemFontOfSize:13]
#define SLCellFont5 [UIFont systemFontOfSize:11]

#define SLFont11 [UIFont systemFontOfSize:11]
#define SLFont13 [UIFont systemFontOfSize:13]
#define SLFont15 [UIFont systemFontOfSize:15]


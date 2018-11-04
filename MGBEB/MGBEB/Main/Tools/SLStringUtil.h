//
//  SLStringUtil.h
//  MGBEB
//
//  Created by SurgeLee on 2018/6/26.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SLStringUtil : NSObject

// 是否空字符
+ (BOOL)isBlankString:(NSString *)aStr;

// 获取不同颜色文字
+ (NSMutableAttributedString *)stringWithString: (NSString *)string font:(UIFont*)font color:(UIColor*) color;

/*
 * 版本号比较大小
 * 1 : >
 * 0 : =
 * -1 : <
 */
+ (int)versionCompareFirst:(NSString *)first andVersionSecond: (NSString *)second;

@end

//
//  SLTextSizeTools.h
//
//  Created by SurgeLee on 2018/6/16.
//  Copyright © 2018年 mgood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SLTextSizeTools : NSObject

// 计算文字size
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW;

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font;


@end

//
//  SLTextSizeTools.m
//
//  Created by SurgeLee on 2018/6/16.
//  Copyright © 2018年 mgood. All rights reserved.
//

#import "SLTextSizeTools.h"

@implementation SLTextSizeTools

// 计算文字Size（宽，高）
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}

@end

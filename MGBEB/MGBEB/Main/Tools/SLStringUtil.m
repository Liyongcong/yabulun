//
//  SLStringUtil.m
//  MGBEB
//
//  Created by SurgeLee on 2018/6/26.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLStringUtil.h"

@implementation SLStringUtil

+ (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!aStr.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

+ (NSMutableAttributedString *)stringWithString: (NSString *)string font:(UIFont*)font color:(UIColor*) color{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
//    [str addAttribute:NSForegroundColorAttributeName value: color range:NSMakeRange(0, str.length)];
    [str addAttributes:@{NSForegroundColorAttributeName:color, NSFontAttributeName:font} range:NSMakeRange(0, str.length)];
    
    return str;
}


+ (int)versionCompareFirst:(NSString *)first andVersionSecond: (NSString *)second{
    NSArray *versions1 = [first componentsSeparatedByString:@"."];
    NSArray *versions2 = [second componentsSeparatedByString:@"."];
    NSMutableArray *ver1Array = [NSMutableArray arrayWithArray:versions1];
    NSMutableArray *ver2Array = [NSMutableArray arrayWithArray:versions2];
    // 确定最大数组
    NSInteger a = (ver1Array.count > ver2Array.count) ? ver1Array.count : ver2Array.count;
    // 补成相同位数数组
    if (ver1Array.count < a) {
        for(NSInteger j = ver1Array.count; j < a; j++) {
            [ver1Array addObject:@"0"];
        }
    } else {
        for(NSInteger j = ver2Array.count; j < a; j++) {
            [ver2Array addObject:@"0"];
        }
    }
    
    // 版本号比较
    for (int i = 0; i< ver2Array.count; i++) {
        NSInteger a = [[ver1Array objectAtIndex:i] integerValue];
        NSInteger b = [[ver2Array objectAtIndex:i] integerValue];
        if (a > b) {
            return 1;
        }
        else if (a < b)
        {
            return -1;
        }
    }
    return 0;

}

@end

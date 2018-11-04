//
//  SLMoneyTool.h
//
//  Created by SurgeLee on 2018/6/29.
//  Copyright © 2018年 mgood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SLMoneyTool : NSObject

+ (NSString *)moneyWithNSString:(NSString *)money;

+ (NSString *)moneyWithFormat:(CGFloat)money;


+ (NSString *)moneyFormatWithNSString:(NSString *)money;

+ (NSString *)moneyFormatWithCGFloat:(CGFloat)money;


@end

//
//  UIButton+FillColor.h
//  MGBEB
//
//  Created by SurgeLee on 2018/7/4.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (FillColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@property (nonatomic, strong) NSString * titleName;

@end

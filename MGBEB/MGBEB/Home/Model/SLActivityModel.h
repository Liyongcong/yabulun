//
//  SLActivityModel.h
//  MGBEB
//
//  Created by SurgeLee on 2018/6/20.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLActivityModel : NSObject<NSCoding>

// id
@property (nonatomic, copy) NSString *idstr;
// 标题
@property (nonatomic, copy) NSString *title;
// 图片
@property (nonatomic, copy) NSString *imageUrl;

@end

//
//  SLTypeModel.h
//  MGBEB
//
//  Created by SurgeLee on 2018/6/20.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLTypeModel : NSObject<NSCoding>

// 名称
@property (nonatomic, copy) NSString *typeName;
// 类型
@property (nonatomic, assign) NSInteger *type;
// id
@property (nonatomic, copy) NSString *idstr;
// 图片
@property (nonatomic, copy) NSString *imgUrl;
// 描述
@property (nonatomic, copy) NSString *describe;
// 图标
@property (nonatomic, copy) NSString *iconUrl;

@end

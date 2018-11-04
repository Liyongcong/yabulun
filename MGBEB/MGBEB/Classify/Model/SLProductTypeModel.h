//
//  SLProductTypeModel.h
//  MGBEB
//
//  Created by SurgeLee on 2018/6/21.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLProductTypeModel : NSObject

// 名称
@property (nonatomic, copy) NSString *typeName;
// 类型
@property (nonatomic, assign) NSInteger *type;
// id
@property (nonatomic, copy) NSString *idstr;
// 图片
@property (nonatomic, copy) NSString *typeIcon;
// 父类型ID
@property (nonatomic, assign) NSInteger *parendId;


//这个来定位右边数据源滚动的位置
@property(assign, nonatomic) float offsetScorller;

@end

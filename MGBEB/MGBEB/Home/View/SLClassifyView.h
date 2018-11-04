//
//  SLClassifyView.h
//  MGBEB
//
//  Created by SurgeLee on 2018/6/20.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLTypeModel.h"

@class SLClassifyView;

@protocol SLClassifyViewDelegate <NSObject>

/**
 用于监听自定义SLClassifyView按钮的点击事件
 
 @param calssifyView 触发事件的控件
 @param from 以前按钮的索引
 @param to 当前点击按钮的索引
 */
- (void)calssifyView:(SLClassifyView *)calssifyView selectedBtnFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface SLClassifyView : UIView

// 类型列表
@property (nonatomic, strong) NSMutableArray *types;

// 代理对象
@property (nonatomic, weak) id<SLClassifyViewDelegate> delegate;

- (void)addTypeBtn:(NSArray *)models;

@end

//
//  SLDataPickerView.h
//  MGCRM
//
//  Created by SurgeLee on 2017/4/23.
//  Copyright © 2017年 mgood. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SLDataPickerViewDelegate <NSObject>

/**
 保存按钮代理方法
 @param selectStr 选择的数据
 @param selectNum 选择的数据行号
 */
- (void)dataPickerViewSave:(NSString *)selectStr number:(NSInteger)selectNum;

/**
 取消按钮代理方法
 */
@optional
- (void)dataPickerViewCancel;

@end


@interface SLDataPickerView : UIView

// 标题
@property (copy, nonatomic) NSString *title;
@property (weak, nonatomic) id <SLDataPickerViewDelegate> delegate;


@property (strong, nonatomic) UIPickerView *pickerView; // 选择器
// 数据源
@property (strong, nonatomic) NSMutableArray *dataArray; // 数据源


// 显示
- (void)showDataView;


@end

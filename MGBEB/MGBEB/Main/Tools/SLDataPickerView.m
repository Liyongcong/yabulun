//
//  SLDataPickerView.m
//  MGCRM
//
//  Created by SurgeLee on 2017/4/23.
//  Copyright © 2017年 mgood. All rights reserved.
//

#import "SLDataPickerView.h"
#import "SLHeader.h"

#import "UIButton+FillColor.h"

@interface SLDataPickerView() <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIView *dataView; // 容器view
//@property (strong, nonatomic) UIPickerView *pickerView; // 选择器
@property (strong, nonatomic) UIView *toolView; // 工具条
@property (strong, nonatomic) UILabel *titleLbl; // 标题

//@property (strong, nonatomic) NSMutableArray *dataArray; // 数据源

@property (copy, nonatomic) NSString *selectStr; // 选中的数据
@property (assign, nonatomic) NSInteger selectNum; // 选中的数据标号

@end

#define SLColorRGB(rgb)    [UIColor colorWithRed:(rgb)/255.0 green:(rgb)/255.0 blue:(rgb)/255.0 alpha:1.0]


@implementation SLDataPickerView

#pragma mark -
#pragma mark 初始化
/// 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        self.dataArray = [NSMutableArray array];
        // 1.数据加载
        
        [self configToolView];
        [self configPickerView];
    }
    return self;
}
#pragma mark - 配置界面
/// 配置工具条  取消保存按钮
- (void)configToolView {
    self.toolView = [[UIView alloc] init];
    self.toolView.frame = CGRectMake(0, 0, self.frame.size.width, 44);
    [self addSubview:self.toolView];
    
    UIButton *saveBtn = [[UIButton alloc] init];
    saveBtn.frame = CGRectMake(self.frame.size.width - 70, 2, 60, 35);
//    [saveBtn setImage:[UIImage imageNamed:@"icon_select1"] forState:UIControlStateNormal];
    [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize: 16];
    [saveBtn setBackgroundColor:SLColor(28, 119, 215, 255) forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:saveBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.frame = CGRectMake(10, 2, 60, 35);
//    [cancelBtn setImage:[UIImage imageNamed:@"icon_revocation1"] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize: 16];
    [cancelBtn setBackgroundColor:SLColor(28, 119, 215, 255) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:cancelBtn];
    
    self.titleLbl = [[UILabel alloc] init];
    self.titleLbl.frame = CGRectMake(60, 2, self.frame.size.width - 120, 40);
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    self.titleLbl.textColor = SLColorRGB(34);
    [self.toolView addSubview:self.titleLbl];
}

// 配置UIPickerView
- (void)configPickerView {
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolView.frame), self.frame.size.width, self.frame.size.height - 44)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self addSubview:self.pickerView];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLbl.text = title;
}


#pragma mark -
#pragma mark 点击方法

/**
 * 保存
 */
- (void)saveBtnClick {

    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = self.dataView.frame;
        frame.origin.y = self.frame.size.height;
        self.dataView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        
        if ([self.delegate respondsToSelector:@selector(dataPickerViewSave:number:)]) {
            [self.delegate dataPickerViewSave:self.selectStr number:self.selectNum];
        }

    }];
    
}


/**
 * 取消
 */
- (void)cancelBtnClick {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = self.dataView.frame;
        frame.origin.y = self.frame.size.height;
        self.dataView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(dataPickerViewCancel)]) {
            [self.delegate dataPickerViewCancel];
        }
    }];
}

#pragma mark -
#pragma mark 外部方法

// 显示
- (void)showDataView{
    
}

#pragma mark -
#pragma mark UIPickerViewDataSource

// UIPickerView返回多少组
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// UIPickerView返回每组多少条数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.dataArray count];
}

// UIPickerView选择哪一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.selectNum = row; // 选择行
    self.selectStr = self.dataArray[row];  // 选择行数据
//    SLLog(@"选择的数据 %ld - %@", row, self.dataArray[row]);
}

// UIPickerView返回每一行数据
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataArray[row];

}

// UIPickerView返回每一行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

// UIPickerView返回每一行的View
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 44)];
    myView.font = [UIFont systemFontOfSize:16];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text = self.dataArray[row];
    myView.backgroundColor = SLColor(50, 130, 215, 255);
    return myView;
}

#pragma mark -
#pragma mark 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end

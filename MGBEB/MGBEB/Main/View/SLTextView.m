//
//  SLTextView.m
//  MGCRM
//
//  Created by SurgeLee on 2017/5/23.
//  Copyright © 2017年 mgood. All rights reserved.
//

#import "SLTextView.h"

@interface SLTextView()

@property (nonatomic, weak) UILabel *placeholderLabel;

@end

@implementation SLTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.创建用于显示提醒文本的Label
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.text = @"请输入...";
        [placeholderLabel sizeToFit];
//        placeholderLabel.x = 5;
//        placeholderLabel.y = 7;
        
        CGRect tempFrame = placeholderLabel.frame;
        tempFrame.origin.x = 5;
        tempFrame.origin.y = 5;
        placeholderLabel.frame = tempFrame;
        
        
        // 设置字体大小
        self.font = [UIFont systemFontOfSize:15];
        placeholderLabel.font = self.font;
        [self addSubview:placeholderLabel];
        self.placeholderLabel = placeholderLabel;
        
        // 2.监听文本框输入事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChange
{
    // 判断是否输入了内容 , 如果有内容就隐藏label, 如果没有内容就显示label
    self.placeholderLabel.hidden = (self.text.length > 0);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    self.placeholderLabel.text = _placeholder;
    [self.placeholderLabel sizeToFit];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = font;
    [self.placeholderLabel sizeToFit];
}
@end

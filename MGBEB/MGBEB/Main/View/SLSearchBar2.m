//
//  SLSearchBar2.m
//  MGBEB
//
//  Created by SurgeLee on 2018/7/11.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLSearchBar2.h"

#import "SLHeader.h"

@implementation SLSearchBar2

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:13];
//        self.placeholder = @"请输入搜索条件";
        self.background = [UIImage imageNamed:@"search_back"];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入搜索条件" attributes: @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:self.font }];
        self.attributedPlaceholder = attrString;
        
        // 通过init来创建初始化绝大部分控件，控件都是没有尺寸
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [searchBtn setBackgroundImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
        [searchBtn setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
        searchBtn.width = 30;
        searchBtn.height = 30;
        searchBtn.contentMode = UIViewContentModeCenter;
        [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.leftView = searchBtn;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

+ (instancetype)searchBar
{
    return [[self alloc] init];
}

// 代理
- (void)searchBtnClick:(UIButton*)btn {
    if ([self.delegate respondsToSelector:@selector(searchBtnClick:searchField:)]) {
        [self.delegate searchBtnClick:btn searchField:self.text];
    }
}


@end

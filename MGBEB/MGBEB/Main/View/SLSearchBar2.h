//
//  SLSearchBar2.h
//  MGBEB
//
//  Created by SurgeLee on 2018/7/11.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SLSearchBarDelegate <NSObject>

@optional

- (void)searchBtnClick:(UIButton*)sender searchField:(NSString*)searchField;

@end

@interface SLSearchBar2 : UITextField

// 代理对象
@property (nonatomic, weak) id<SLSearchBarDelegate> delegate;

+ (instancetype)searchBar;

@end

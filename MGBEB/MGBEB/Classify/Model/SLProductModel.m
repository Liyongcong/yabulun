//
//  SLProductModel.m
//  MGBEB
//
//  Created by SurgeLee on 2018/6/25.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLProductModel.h"

#import "SLStringUtil.h"

@implementation SLProductModel

// 特殊字段处理
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idstr" : @"id"};
}

- (void)setProductImg:(NSString *)productImg {
    _productImg = productImg;
    if (![SLStringUtil isBlankString:productImg]) {
        self.productImgs = [NSMutableArray arrayWithArray: [productImg componentsSeparatedByString:@";"] ];
    } else {
        self.productImgs = [NSMutableArray arrayWithObject:@"goods_default"];
    }
}

- (NSMutableArray *)productImgs{
    if (!_productImgs) {
        _productImgs = [NSMutableArray array];
    }
    return _productImgs;
}

@end

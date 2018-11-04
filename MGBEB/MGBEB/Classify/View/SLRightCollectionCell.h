//
//  SLRightCollectionCell.h
//  MGBEB
//
//  Created by SurgeLee on 2018/6/21.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SLProductTypeModel.h"

@interface SLRightCollectionCell : UICollectionViewCell

@property(strong, nonatomic)SLProductTypeModel *productTypeModel;

+ (CGSize)cellSize;

@end

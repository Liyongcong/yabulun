//
//  SLGoodsCollectionCell.h
//  MGBEB
//
//  Created by SurgeLee on 2018/6/25.
//  Copyright © 2018年 surge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SLProductModel.h"

@interface SLGoodsCollectionCell : UICollectionViewCell

@property(strong, nonatomic)SLProductModel *productModel;

+ (instancetype)cellWithTCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@end

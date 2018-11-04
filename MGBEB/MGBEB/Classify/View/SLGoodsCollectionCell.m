//
//  SLGoodsCollectionCell.m
//  MGBEB
//
//  Created by SurgeLee on 2018/6/25.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLGoodsCollectionCell.h"

#import "SLHeader.h"

@interface SLGoodsCollectionCell()

@property(strong, nonatomic)UIImageView *goodImageView;

@property(strong, nonatomic)UILabel *titleLabel;

@property(strong, nonatomic)UILabel *priceLabel;

@property(strong, nonatomic)UILabel *saleNumLabel;

@end

@implementation SLGoodsCollectionCell

+ (instancetype)cellWithTCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"goodsCollectionCell";
    SLGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];

    return cell;

}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 图片
        self.goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSLscreenW/2 - 14, kSLscreenW/2 - 14)];
        self.goodImageView.contentMode = UIViewContentModeScaleAspectFill;
       
        // 标题
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.goodImageView.frame) + 5, CGRectGetWidth(self.goodImageView.frame), 15)];
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.titleLabel.textColor = SLColor(89, 89, 89, 255);
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        // 价格
        self.priceLabel =  [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(self.titleLabel.frame) + 5, kSLscreenW/4-10, 16)];
        self.priceLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:15];
        //[UIFont systemFontOfSize:15];
        self.priceLabel.textColor = [UIColor redColor]; //SLColor(231, 97, 44, 255);
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        
        // 购买数量
        self.saleNumLabel =  [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.priceLabel.frame) + 5, self.priceLabel.y + 5, CGRectGetWidth(self.goodImageView.frame) - CGRectGetMaxX(self.priceLabel.frame) - 10, 10)];
        self.saleNumLabel.font = [UIFont systemFontOfSize:9];
        self.saleNumLabel.textColor = SLColor(190, 190, 190, 255);
        self.saleNumLabel.textAlignment = NSTextAlignmentRight;
        
        // 添加到视图
        [self.contentView addSubview: _goodImageView];
        [self.contentView addSubview: _titleLabel];
        [self.contentView addSubview: _priceLabel];
        [self.contentView addSubview: _saleNumLabel];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
//        [self.contentView.layer setMasksToBounds:YES];
//        self.contentView.layer.cornerRadius = 5.0;
    }
    return self;
}

- (void)setProductModel:(SLProductModel *)productModel{
    
    // 判断数组中是否有值
    if (productModel.productImgs.count == 0) {
        [self.goodImageView setImage: [UIImage imageNamed:@"goods_default"]];
    } else {
        [self.goodImageView sd_setImageWithURL:productModel.productImgs[0] placeholderImage:[UIImage imageNamed:@"goods_default"]];
    }
    
    NSString *name = productModel.productName ? productModel.productName : @"商品名称" ;
    NSNumber *price = productModel.appListPrice ? productModel.appListPrice : [NSNumber numberWithInt:0];
    NSInteger *num = productModel.saleNum ? productModel.saleNum : 0;
    
    self.titleLabel.text = name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", price];
    self.saleNumLabel.text = [NSString stringWithFormat:@"%tu人已付款", num];
}

@end

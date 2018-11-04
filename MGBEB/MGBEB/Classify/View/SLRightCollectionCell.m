//
//  SLRightCollectionCell.m
//  MGBEB
//
//  Created by SurgeLee on 2018/6/21.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLRightCollectionCell.h"

#import "SLHeader.h"

@interface SLRightCollectionCell()

@property(strong, nonatomic)UIImageView *roomImageView;

@property(strong, nonatomic)UILabel *roomLabel;

@end

static const CGFloat collectionCellHeight = 80;

static const CGFloat labelHeight = 20;

@implementation SLRightCollectionCell

//这边很关键 CollectionViewCell重用
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!self.roomImageView) {
            self.roomImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kSLscreenW / 4 - 20)/3, collectionCellHeight-labelHeight)];
            self.roomImageView.contentMode=UIViewContentModeScaleAspectFill;
            self.roomImageView.clipsToBounds = YES;
            self.roomImageView.layer.masksToBounds = YES;
            self.roomImageView.layer.cornerRadius = 2.0;
            [self.contentView addSubview:self.roomImageView];
        }
        
        if (!self.roomLabel) {
            self.roomLabel=[[UILabel alloc]init];
            self.roomLabel.font=[UIFont systemFontOfSize:13];
            self.roomLabel.textAlignment=NSTextAlignmentCenter;
            [self.roomLabel sizeToFit];
            [self.contentView addSubview:self.roomLabel];
        }
        
        // 布局
        self.roomImageView.sd_layout.leftSpaceToView(self.contentView, 20)
            .rightSpaceToView(self.contentView, 20)
            .topSpaceToView(self.contentView, 10)
            .bottomSpaceToView(self.contentView, 20);
        
        self.roomLabel.sd_layout.leftSpaceToView(self.contentView, 0)
            .rightSpaceToView(self.contentView, 0)
            .topSpaceToView(self.roomImageView, 0)
            .bottomSpaceToView(self.contentView, 0);
    }
    return self;
}

- (void)setProductTypeModel:(SLProductTypeModel *)productTypeModel{
    
    _productTypeModel = productTypeModel;
    [self.roomImageView sd_setImageWithURL:[NSURL URLWithString:productTypeModel.typeIcon] placeholderImage:[UIImage imageNamed:@"type_defult"]];
    self.roomLabel.text=_productTypeModel.typeName;
}

+ (CGSize)cellSize{
    return CGSizeMake((kSLscreenW / 4 - 10), collectionCellHeight);
}

@end

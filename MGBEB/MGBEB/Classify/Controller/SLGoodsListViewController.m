//
//  SLGoodsListViewController.m
//  MGBEB
//
//  Created by SurgeLee on 2018/6/25.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLGoodsListViewController.h"

#import "SLHeader.h"

#import "UIBarButtonItem+Extension.h"

#import "SLGoodsCollectionCell.h"
#import "SLGoodDetailViewController.h"

#import "SLProductModel.h"
#import <MJRefresh.h>

@interface SLGoodsListViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;

// 商品列表
@property(nonatomic, strong)NSMutableArray *products;

// 最后选择商品类型
@property (nonatomic, assign) NSString *lastTypeId;

@end

@implementation SLGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // 加载数据
    [self initData];
    // 初始化设置
    [self initNavigation];
    // 初始化视图
    [self initCollectionView];
    // 初始化刷新控件
    [self setupRefresh];
}

#pragma mark  设置CollectionView的的参数
- (void)initCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //设置CollectionView的属性
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSLscreenW, kSLscreenH -20) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = SLColor(240, 240, 240, 255);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;
    [self.view addSubview:self.collectionView];
    //注册Cell
    [self.collectionView registerClass:[SLGoodsCollectionCell class] forCellWithReuseIdentifier:@"goodsCollectionCell"];
}

// 设置导航
- (void)initNavigation {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_back2" higImage:@"nav_back2" target:self  action:@selector(leftBtn:)];
}

- (void)leftBtn:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

// 添加刷新
- (void)setupRefresh {
    // 上拉刷新
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreProduct)];
}

#pragma mark -
#pragma mark

- (void)initData {
//    SLProductModel  *model = [[SLProductModel alloc] init];
//    SLProductModel  *model2 = [[SLProductModel alloc] init];
//    SLProductModel  *model3 = [[SLProductModel alloc] init];
//    model.productName = @"商品1";
//    model2.productName = @"商品2";
//    model3.productName = @"商品3";
//    [self.products addObject: model];
//    [self.products addObject: model2];
//    [self.products addObject: model3];
    
    if (self.typeId || self.indexId || self.secKill || self.productName) {
        // 加载数据
        [self loadMoreProduct];
        if ([self.lastTypeId isEqualToString: self.typeId]) {
            [self.products removeAllObjects];
        } else {
            self.lastTypeId = self.typeId;
        }
    } 
}

// 加载更多商品信息
- (void)loadMoreProduct{
    
    // 获取参数信息
    SLProductModel *model = [self.products lastObject];

    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
    if (model) {
        parameters[@"minId"] = model.idstr; // 加载其实位置 默认为0
    }
    parameters[@"productType"] = self.typeId;
    parameters[@"secKill"] = self.secKill;
    parameters[@"appIndexTag"] = self.indexId;
    parameters[@"productName"] = self.productName;
    // 3.发送请求
    NSString *urlString = @"product/productsList";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            // 获取数据
            NSArray *list = [NSArray yy_modelArrayWithClass:[SLProductModel class] json:result[@"list"]];
            // 保存数据
            [self.products addObjectsFromArray:list];
            // 刷新表格
            [self.collectionView reloadData];
            
        } else {
            [SVProgressHUD showInfoWithStatus:@"数据异常！"];
        }
        
        // 关闭刷新控件
        [self.collectionView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
        // 关闭刷新控件
        [self.collectionView.mj_footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark UICollectionViewDelegate, UICollectionViewDataSource

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    SLGoodsCollectionCell *cell = [SLGoodsCollectionCell cellWithTCollectionView:collectionView forIndexPath:indexPath];
    
    cell.productModel = self.products[indexPath.row];
    cell.backgroundColor = SLColor(221,226,233, 255);
    [cell.layer setMasksToBounds:YES];
    cell.layer.cornerRadius = 8.0;
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.products.count;
}


#pragma mark -
#pragma mark UICollectionViewDelegateFlowLayout

// 定义整个CollectionViewCell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kSLscreenW/2 - 14, kSLscreenW/2 + 40);
}

// 定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsZero;
    return UIEdgeInsetsMake(8, 10, 0, 10);
}

// 定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

// 定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 6;
}

// 点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SLProductModel *p = self.products[indexPath.item];
    NSLog(@"点击了%@", p.productName);
    
    SLGoodDetailViewController *vc = [[SLGoodDetailViewController alloc] init];
    vc.product = p;
    
    [self.navigationController pushViewController:vc animated:YES];
}

// 设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark -
#pragma mark 懒加载

- (NSMutableArray *)products{
    if (!_products) {
        _products = [NSMutableArray array];
    }
    return _products;
}

@end

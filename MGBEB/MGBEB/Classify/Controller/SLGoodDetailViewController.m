//
//  SLGoodDetailViewController.m
//  MGBEB
//
//  Created by SurgeLee on 2018/6/27.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLGoodDetailViewController.h"

#import "SLHeader.h"

#import "UIBarButtonItem+Extension.h"

#import "SLProductModel.h"
#import "SLSubProductView.h"
#import "SLCartViewController.h"

#import "SLOrderModel.h"
#import "SLSubOrderModel.h"
#import "SLUserModel.h"

#import "AppDelegate.h"

#import <XYQPlayer/XYQMovieTool.h>

#import "SLevaluModel.h"
#import "SLEvaluTableCell.h"

@interface SLGoodDetailViewController () <UIScrollViewDelegate, SLSubProductViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIPageControl *pageControl;
@property (weak, nonatomic) UIImageView *detailImgView;
@property (weak, nonatomic) UIView *btnView;

@property (weak, nonatomic) UIButton *shopBtn; // 已购

@property (weak, nonatomic) UIScrollView *parentView; // 视图

@property (weak, nonatomic) SLSubProductView *maskView; // 蒙版

@property (strong, nonatomic) AppDelegate *myAppDelegate;

// 评论列表
@property(nonatomic, strong)NSMutableArray *evlas;

@end

@implementation SLGoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    // 初始化设置
    [self initNavigation];
    // 初始化页面
    [self initViewLayout];
    // 初始化轮播设置
    [self initScrollSetting];
    // 加载数据
    [self initData]; // 设置购物车数量
    // 加载评论
    [self loadEvalus];
}

// 页面
- (void)initViewLayout{
    
    // 页面设置
    UIScrollView *parentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kSLscreenW, kSLscreenH - 124)];
    self.parentView = parentView;
    self.parentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:parentView];
    
    // 创建轮播视图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kSLscreenW, kSLscreenW)];
    self.scrollView = scrollView;
    [self.parentView addSubview:scrollView];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    
    // 创建页标
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kSLscreenW - 20, kSLscreenW, 20)];
    self.pageControl = pageControl;
    [self.parentView addSubview:pageControl];
    
    CGFloat detailY = kSLscreenW + 10;
    
    if (![self.product.productDetailVideo isEqualToString:@""]
         && self.product.productDetailVideo.length > 10) {
        
        UIView *playView = [[UIView alloc] initWithFrame:CGRectMake(0, kSLscreenW + 10, kSLscreenW, kSLscreenW/2 + 20)];
        detailY += kSLscreenW/2 + 25;
        self.playView = playView;
        [self.parentView addSubview:playView];
        
        [XYQMovieTool pushPlayMovieWithNetURL:self.product.productDetailVideo viewController:self];
//        [XYQMovieTool pushPlayMovieWithNetURL:self.product.productDetailVideo viewController:self playView:playView];
    }
    
    // 详情信息
    UIImageView *detailImgView = [[UIImageView alloc] initWithFrame: CGRectMake(0, detailY, kSLscreenW, 200)]; // [[UIImageView alloc] initWithFrame: CGRectZero]; CGRectGetMaxY(scrollView.frame)
    self.detailImgView = detailImgView;
    [self.parentView addSubview:detailImgView];
    
    UILabel *evaluTitle = [[UILabel alloc] init];
    evaluTitle.text = @"用户评论";
    [parentView addSubview:evaluTitle];
    
    // 评论信息
    UITableView *tableView =[[UITableView alloc] init];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [parentView addSubview:tableView];
   
//    detailImgView.contentMode = UIViewContentModeScaleToFill;
    // 设置图片
//    [detailImgView sd_setImageWithURL:[NSURL URLWithString:self.product.productDetailImg] placeholderImage:[UIImage imageNamed:@"goods_default"]];
//    detailImgView.sd_layout.autoHeightRatio(1);
//    [self rescaleImageToSize: detailImgView.size];
    if (![self.product.productDetailImg isEqualToString:@""]) { // 图片为空时报错
        [detailImgView sd_setImageWithURL:[NSURL URLWithString:self.product.productDetailImg] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
//            SLLog(@"%@", NSStringFromCGSize(image.size));
            detailImgView.size = CGSizeMake(kSLscreenW, image.size.height / (image.size.width/kSLscreenW));
            //      [detailImgView setNeedsLayout];
            
            // 设置评论
            evaluTitle.frame = CGRectMake(5, detailImgView.y + detailImgView.height, kSLscreenW, 30);
            tableView.frame = CGRectMake(0, evaluTitle.y + evaluTitle.height, kSLscreenW, 300);
        }];
    }
    
    // 设置代理
    self.scrollView.delegate = self;
    
    // 设置滚动区域
//    self.parentView.contentSize = CGSizeMake(0, 1000);
    
    // 底部支付按钮
    UIView *btnView =[[UIView alloc] initWithFrame:CGRectMake(0, kSLscreenH - 124, kSLscreenW, 60)];
    btnView.backgroundColor = [UIColor whiteColor];
    self.btnView = btnView;
    [self.view addSubview: btnView];
    // 购物车按钮
    UIButton *shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shopBtn setFrame:CGRectMake(0, 0, kSLscreenW/3, 60)];
    [shopBtn setTitle:@"已选" forState:UIControlStateNormal];
    [shopBtn setBackgroundColor:SLColor(68, 148, 217, 255)];
    [shopBtn addTarget:self action:@selector(shopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.shopBtn = shopBtn;
    [self.btnView addSubview:shopBtn];
    // 结算按钮
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [payBtn setFrame:CGRectMake(kSLscreenW/3, 0, kSLscreenW/3, 60)];
    [payBtn setTitle:@"结算" forState:UIControlStateNormal];
    [payBtn setBackgroundColor:SLColor(253, 134, 9, 255)];
    [payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:payBtn];
    // 加入购物车
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(kSLscreenW/3 * 2, 0, kSLscreenW/3, 60)];
    [addBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addBtn setBackgroundColor:SLColor(251, 0, 6, 255)];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:addBtn];
}

// 初始化轮播设置
- (void)initScrollSetting{
    // 动态创建UIImageView添加到UIScrollView中
    CGFloat imgW = kSLscreenW;
    CGFloat imgH = kSLscreenW;
    CGFloat imgY = 0;
    
    NSUInteger imgCount = self.product.productImgs.count;
    
    // 1. 循环创建5个UIImageView添加到ScrollView中
    for (int i = 0; i < imgCount; i++) {
        // 创建一个UIImageView
        UIImageView *imgView = [[UIImageView alloc] init];
        
        // 设置UIImageView中的图片
        NSString *imgName = self.product.productImgs[i];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgName] placeholderImage:[UIImage imageNamed:@"goods_default"]];
        
        // 计算每个UIImageView在UIScrollView中的x坐标值
        CGFloat imgX = i * imgW;
        // 设置imgView的frame
        imgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
        
        // 把imgView添加到UIScrollView中
        [self.scrollView addSubview:imgView];
    }
    
    // 设置UIScrollView的contentSize(内容的实际大小)
    CGFloat maxW = self.scrollView.frame.size.width * imgCount;
    self.scrollView.contentSize = CGSizeMake(maxW, 0);
    
    // 实现UIScrollView的分页效果
    // 当设置允许分页以后, UIScrollView会按照自身的宽度作为一页来进行分页。
    self.scrollView.pagingEnabled = YES;
    
    // 隐藏水平滚动指示器
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    // 指定UIPageControl的总页数
    self.pageControl.numberOfPages = imgCount;
    
    // 指定默认是第0页
    self.pageControl.currentPage = 0;
    
//    [self.scrollView bringSubviewToFront:self.pageControl];
}

// 初始化数据
- (void)initData{
    
//    self.product = [[SLProductModel alloc] init];

//    self.product.productImgs = [NSMutableArray arrayWithObjects: @"https://img13.360buyimg.com/cms/jfs/t20017/333/1118681754/257554/9af8097d/5b14a452N6cac73ad.jpg.dpg",@"https://img20.360buyimg.com/vc/jfs/t17725/294/1302905584/315536/20af3ca6/5ac2ee19N3224daba.jpg.dpg;", nil];
//
//    SLLog(@"%@", self.product.productImgs);

//    self.product.productDetailImg =@"https://img20.360buyimg.com/vc/jfs/t17338/31/1327268563/333295/982287d0/5ac2ee1bNebeb06db.jpg.dpg";
    
    // 设置购物车数量
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.myAppDelegate = appDelegate;
    
    [self.shopBtn setTitle:[NSString stringWithFormat:@"已选（%@）", appDelegate.cartBadge] forState:UIControlStateNormal];
    
}

// 导航设置
- (void)initNavigation {
    
    self.title = @"商品详情";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_back2" higImage:@"nav_back2" target:self  action:@selector(leftBtn:)];
}

- (void)leftBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

// 图片处理
//- (void)viewWillAppear:(BOOL)animated {
//    _detailImgView.frame = CGRectMake(0, kSLscreenW + 10, kSLscreenW, _detailImgView.image.size.height);
//}

#pragma mark -
#pragma mark 按钮事件
// 已选
- (void)shopBtnClick:(UIButton *)btn {
    SLCartViewController *vc = [[SLCartViewController alloc] init];
    vc.isFromOther = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 结算
- (void)payBtnClick:(UIButton *)btn {
    SLCartViewController *vc = [[SLCartViewController alloc] init];
    vc.isFromOther = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 添加到购物车
- (void)addBtnClick:(UIButton *)btn {

    SLSubProductView *maskView = [[SLSubProductView alloc] initWithFrame:CGRectMake(0, kSLscreenH, kSLscreenW, kSLscreenW)];
    self.maskView = maskView;
    self.maskView.delegate = self;
    [self.view addSubview:maskView];
    
    // 设置产品型号信息
    [self loadSubProduct];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.y = kSLscreenH - kSLscreenW - 64;
    }];
}

- (void)loadSubProduct{
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
    parameters[@"productId"] = self.product.idstr;
    // 3.发送请求
    NSString *urlString = @"product/productsModel";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            // 获取数据
            NSArray *list = [NSArray yy_modelArrayWithClass:[SLSubProductModel class] json:result[@"list"]];
            // 设置数据
            self.maskView.subProducts = [list mutableCopy];
        } else {
            [SVProgressHUD showInfoWithStatus:@"数据异常！"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

- (void)loadEvalus{
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
    parameters[@"productId"] = self.product.idstr;
    // 3.发送请求
    NSString *urlString = @"evaluation/queryList";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            // 获取数据
            NSArray *list = [NSArray yy_modelArrayWithClass:[SLevaluModel class] json:result[@"list"]];
            
            self.evlas = [list mutableCopy];
            
        } else {
            [SVProgressHUD showInfoWithStatus:@"数据异常！"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

#pragma mark -
#pragma mark 商品选择代理 SLSubProductViewDelegate

- (void)resetClick:(UIButton*)sender subProduct:(SLSubProductModel*)subProduct{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.y = kSLscreenH;
    }];
}

- (void)sureClick:(UIButton*)sender subProduct:(SLSubProductModel*)subProduct num:(NSInteger)num{
    
    // 获取选择的值
    SLLog(@"准备购买 %ld 个 %@", num, subProduct.secondLevelName);
    
    subProduct.amount = num; // 购买数量
    // 加入购物车由接口完成，接口判定订单中商品的添加以及数量+-
    [self addProductToCart:subProduct];
    
    // 页面效果
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.y = kSLscreenH;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.parentView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.detailImgView.frame) + kSLscreenH +10);
    
}

// 加入到购物车
- (void)addProductToCart:(SLSubProductModel*)subProduct {
    SLUserModel *user = [SLUserModel achieveUser];
    if (!user) { // 未登录
        return;
    }
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    SLOrderModel *cart = [[SLOrderModel alloc] init];
    cart.fkSupplierManageId = self.product.fkSupplierManageId;
    cart.clientCode = user.CardID;
    cart.clientName = user.CardName;
    SLSubOrderModel *subCart = [[SLSubOrderModel alloc] init];
    subCart.fkProductManageMainId = [self.product.idstr integerValue]; // 所属商品
    subCart.productName = self.product.productName;
    subCart.productNameCode = self.product.productCode;
    subCart.fkProductManageSub = [subProduct.idstr integerValue]; // 商品型号
    subCart.secondCode = subProduct.secondCode;
    subCart.secondName = subProduct.secondLevelName;
    subCart.price = subProduct.price;
    subCart.amount = subProduct.amount;
    subCart.totalPrie = [NSNumber numberWithDouble:([subProduct.price doubleValue] * subProduct.amount)];
    cart.products = [NSArray arrayWithObject:subCart];
    NSString *jsonString = [cart yy_modelToJSONString];
    NSString *json = [jsonString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // 3.发送请求
    NSString *urlString = @"cart/cartJsonAdd";
    [tools POST:urlString parameters:json success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            if ([result[@"isNew"] integerValue]== 1) {
                // 购物车 + 1
                AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                self.myAppDelegate = appDelegate;
                int nums = [appDelegate.cartBadge isEqualToString:@""] ? 1 : [appDelegate.cartBadge intValue] + 1;
                appDelegate.cartBadge = [NSString stringWithFormat:@"%d", nums];
                [self.shopBtn setTitle:[NSString stringWithFormat:@"已选（%d）", nums] forState:UIControlStateNormal];
            }
            [SVProgressHUD showInfoWithStatus:@"操作成功！"];
        } else {
            [SVProgressHUD showInfoWithStatus:@"数据异常！"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error)  {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

#pragma mark - 轮播处理代理方法
#pragma mark UIScrollViewDelegate

// 实现UIScrollView的滚动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    // 如何计算当前滚动到了第几页？
    // 1. 获取滚动的x方向的偏移值
    CGFloat offsetX = scrollView.contentOffset.x;
    // 用已经偏移了得值, 加上半页的宽度
    offsetX = offsetX + (scrollView.frame.size.width * 0.5);
    
    // 2. 用x方向的偏移的值除以一张图片的宽度(每一页的宽度)，取商就是当前滚动到了第几页（索引）
    int page = offsetX / scrollView.frame.size.width;
    
    // 3. 将页码设置给UIPageControl
    self.pageControl.currentPage = page;
    
    //NSLog(@"滚了，要在这里根据当前的滚动来计算当前是第几页。");
}

- (UIImage*) rescaleImageToSize:(CGSize)size{
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    [self.detailImgView.image drawInRect: rect];// scales image to rect
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resImage;
}

//关闭播放器
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [XYQMovieTool cancelPlay];
}

#pragma tableview 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.evlas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SLEvaluTableCell *cell = [SLEvaluTableCell cellWithTableView:tableView];
    
    cell.evalu = self.evlas[indexPath.row]; // 设置物流明细
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLEvaluTableCell *cell = (SLEvaluTableCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    CGRect frame = tableView.frame;
    frame.size.height = frame.size.height + cell.frame.size.height;
    tableView.frame = frame;
    
    return cell.frame.size.height;
}

#pragma mark -
#pragma mark 懒加载

- (NSMutableArray *)evlas{
    if (!_evlas) {
        _evlas = [NSMutableArray array];
    }
    return _evlas;
}

@end

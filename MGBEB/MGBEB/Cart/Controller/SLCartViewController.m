//
//  SLCartViewController.m
//  MGBEB
//
//  Created by SurgeLee on 2018/6/19.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLCartViewController.h"

#import "SLHeader.h"

#import "SLCartTableCell.h"
#import "UIBarButtonItem+Extension.h"
#import "SLAddressModel.h"
#import "SLUserModel.h"
#import "SLPersonViewController.h"
#import "SLDataPickerView.h"
#import "SLMineViewController.h"
#import "SLPayViewController.h"

#import "SLOrderModel.h"
#import "SLSubOrderModel.h"

#import "AppDelegate.h"

#import "SLTabBarController.h"

#import "UILabel+ChangeLineSpaceAndWordSpace.h"

#define kSLLabelColor SLColor(42,42,42, 255)

@interface SLCartViewController () <UITableViewDelegate, UITableViewDataSource, SLDataPickerViewDelegate, SLCartCellDelegate>

@property (strong, nonatomic) UITableView *myTableView;

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *phoneLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *deliverLabel;
// 合计价格
@property (strong, nonatomic) UILabel *priceLabel;

@property (strong, nonatomic) SLAddressModel *address;
@property (strong, nonatomic) NSMutableArray *shippings;

// 数据控件
@property (nonatomic, strong) SLDataPickerView *dataView;

@property (strong, nonatomic) NSMutableArray *orders; //订单信息

@property (strong, nonatomic) NSMutableArray *selOrders; //选中的订单信息

// 当前用户
@property (strong, nonatomic) SLUserModel *user;

@end

@implementation SLCartViewController

- (instancetype)init{
    if (self = [super init]) {
        [self loadCartCount];
    }
    return self;
}

- (void)viewDidLoad {

    // 获取登陆用户
    SLUserModel *user = [SLUserModel achieveUser];
    self.user = user;
    
    [super viewDidLoad];
    // 设置tableView
    [self initTableView];
    // 设置头视图
    [self setupHeaderView];
    // 设置底部视图
    [self setupFooterView];
    // 初始化数据
//    [self initData];
    // 标题
    self.title = @"购物车";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    self.view.backgroundColor = SLColor(221,226,233, 255);
    // 导航
    if (_isFromOther) { // 由导航控制器进来
        // 初始化导航设置
        [self initNavigation];
    }
}

// 设置tableView
- (void)initTableView {
    
    CGFloat navHeight = 64;
    if (_isFromOther) { // 由导航控制器进来
        navHeight = 0;
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSLscreenW, kSLscreenH - 110 - navHeight)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView = tableView;
    [self.view addSubview:tableView];
}

// 初始化导航设置
- (void)initNavigation {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_back2" higImage:@"nav_back" target:self  action:@selector(leftBtn:)];
}

- (void)leftBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupHeaderView{
    
    // 1、容器
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kSLscreenW - 20, 175)];
    view.backgroundColor = SLColor(221,226,233, 255);
    UIView *headBackView = [[UIView alloc] initWithFrame:CGRectMake(12, 10, kSLscreenW - 24, 155)];
    headBackView.backgroundColor = [UIColor whiteColor];
    [headBackView.layer setMasksToBounds:YES];
    headBackView.layer.cornerRadius = 8.0;
    [view addSubview:headBackView];
    
    // 图标：收货人/地址/配送方式
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_name"]];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    UIImageView *addrImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_addr"]];
    addrImage.contentMode = UIViewContentModeScaleAspectFill;
    UIImageView *deliverImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_deliver"]];
    deliverImage.contentMode = UIViewContentModeScaleAspectFill;
    
    imgView.frame = CGRectMake(12, 25, 12, 12);
    addrImage.frame = CGRectMake(imgView.x, imgView.y + imgView.height + 20, imgView.width, imgView.height);
//    deliverImage.frame = CGRectMake(imgView.x, addrImage.y + addrImage.height + 15, imgView.width, imgView.height);
    deliverImage.frame = CGRectMake(12, 15, 12, 12);

    // 2、人员信息
    UIButton *personBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kSLscreenW, 109)];
    [personBtn addTarget:self action:@selector(personClick:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *nameTitleLabel = [[UILabel alloc] init];
    nameTitleLabel.font = SLCellFont4;
    nameTitleLabel.text = @"收 货 人:";
    UILabel *addressTitleLabel = [[UILabel alloc] init];
    addressTitleLabel.font = SLCellFont4;
    addressTitleLabel.text = @"地      址:";
    UILabel *nameLabel = [[UILabel alloc] init];
    UILabel *phoneLabel = [[UILabel alloc] init];
    UILabel *addressLabel = [[UILabel alloc] init];
    nameLabel.font = SLCellFont4;
    phoneLabel.font = SLCellFont4;
    addressLabel.font = SLCellFont4;
    addressLabel.numberOfLines = 0;
    [addressLabel sizeToFit];
    UIImageView *rightImg = [[UIImageView alloc] init];
    [rightImg setImage:[UIImage imageNamed:@"cart_right"]];
    
    nameTitleLabel.textColor = kSLLabelColor;
    addressTitleLabel.textColor = kSLLabelColor;
    nameLabel.textColor = kSLLabelColor;
    phoneLabel.textColor = kSLLabelColor;
    addressLabel.textColor = kSLLabelColor;
    
    self.nameLabel = nameLabel;
    self.phoneLabel = phoneLabel;
    self.addressLabel = addressLabel;
    
    [personBtn addSubview:imgView];
    [personBtn addSubview:addrImage];
    [personBtn addSubview:nameTitleLabel];
    [personBtn addSubview:addressTitleLabel];
    [personBtn addSubview:nameLabel];
    [personBtn addSubview:phoneLabel];
    [personBtn addSubview:addressLabel];
    [personBtn addSubview:rightImg];
    
    // 3、配送方式
    UIButton *deliverBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 110, kSLscreenW, 45)];
    [deliverBtn addTarget:self action:@selector(deliverClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *deliverTitleLabel = [[UILabel alloc] init];
    deliverTitleLabel.text = @"配送方式:";
    deliverTitleLabel.font = SLCellFont4;
    UILabel *deliverLabel = [[UILabel alloc] init];
    deliverLabel.font = SLCellFont4;
    UIImageView *rightImg2 = [[UIImageView alloc] init];
    [rightImg2 setImage:[UIImage imageNamed:@"cart_right"]];
    
    deliverTitleLabel.textColor = kSLLabelColor;
    deliverLabel.textColor = kSLLabelColor;
    
    [deliverBtn addSubview:deliverImage];
    [deliverBtn addSubview:deliverTitleLabel];
    [deliverBtn addSubview:deliverLabel];
    [deliverBtn addSubview:rightImg2];
    
    self.deliverLabel = deliverLabel;
    
    // 4、设置位置
    nameTitleLabel.frame = CGRectMake(CGRectGetMaxX(imgView.frame) + 5, imgView.y, 60, imgView.height);
    nameLabel.frame = CGRectMake(CGRectGetMaxX(nameTitleLabel.frame) + 1, nameTitleLabel.y, 80, nameTitleLabel.height);
    phoneLabel.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame) + 1, nameTitleLabel.y, kSLscreenW-CGRectGetMaxX(nameLabel.frame), nameTitleLabel.height);
    addressTitleLabel.frame = CGRectMake(nameTitleLabel.x, addrImage.y, 55, nameTitleLabel.height);
    
//    CGSize addSize = [addressLabel sizeThatFits: CGSizeMake(kSLscreenW-CGRectGetMaxX(addressTitleLabel.frame)-70, 40)];
//    addressLabel.frame = CGRectMake(nameLabel.x, addressTitleLabel.y, addSize.width, addSize.height);
    addressLabel.frame = CGRectMake(nameLabel.x, addressTitleLabel.y, kSLscreenW-CGRectGetMaxX(addressTitleLabel.frame)-50, 40);
    
    rightImg.frame = CGRectMake(kSLscreenW - 40, 47, 7, 15);
    
    deliverTitleLabel.frame = CGRectMake(CGRectGetMaxX(imgView.frame) + 5, deliverImage.y, nameTitleLabel.width, nameTitleLabel.height);
    deliverLabel.frame = CGRectMake(CGRectGetMaxX(deliverTitleLabel.frame) + 5, deliverTitleLabel.y, 100, deliverTitleLabel.height);
    rightImg2.frame = CGRectMake(kSLscreenW - 40, 15, 7, 15);
    
    // 5、添加到页面
    [headBackView addSubview:personBtn];
    [headBackView addSubview:deliverBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 109, kSLscreenW, 1)];
    lineView.backgroundColor = SLColor(241,241,241, 255);
    [headBackView addSubview:lineView];
    
    self.myTableView.tableHeaderView = view;
}

- (void)setupFooterView{
    
    CGFloat navHeight = 64;
    if (_isFromOther) { // 由导航控制器进来
        navHeight = 0;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kSLscreenH - 110 - navHeight, kSLscreenW, 50)];
    view.backgroundColor = SLColor(236,237,241, 255);
    
    UILabel *totleLabel = [[UILabel alloc] init];
    totleLabel.font = [UIFont systemFontOfSize: 13];
    totleLabel.text = @"合计:";
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.font = [UIFont systemFontOfSize: 18];
    priceLabel.textColor = SLColor(234,0,0, 255);
    priceLabel.text = [NSString stringWithFormat:@"￥%d", 0];
    self.priceLabel = priceLabel;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"去支付" forState: UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_pay_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:totleLabel];
    [view addSubview:priceLabel];
    [view addSubview:button];

    totleLabel.sd_layout.leftSpaceToView(view, 15)
        .topSpaceToView(view, 10)
        .heightIs(30).widthIs(40);
    priceLabel.sd_layout.leftSpaceToView(totleLabel, 0)
        .topSpaceToView(view, 10)
        .heightIs(30).widthIs(100);
    button.sd_layout.rightSpaceToView(view, 10)
        .topSpaceToView(view, 10)
        .heightIs(30).widthIs(84);
    
    [self.view addSubview:view];
}

// 初始化数据
- (void)initData {
    // 初始化地址
//    [self loadAddress];
    // 初始化配送方式
    self.deliverLabel.text = self.shippings.firstObject;
    // 初始化购物车
    [self loadCartList];
}

- (void)viewWillAppear:(BOOL)animated {
    // 初始化时应清空选择
    [self.selOrders removeAllObjects];
    // 初始化地址
    [self loadAddress];
    // 初始化数据
    [self initData];
    // 显示已选总金额
    [self showPrice];
}

#pragma mark -
#pragma mark 数据请求处理
// 地址
- (void)loadAddress {
    // 获取登陆用户
    SLUserModel *user = [SLUserModel achieveUser];
    if (!user) { // 未登录
        return;
    }
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
    parameters[@"memberCode"] = user.CardID;
    // 3.发送请求
    NSString *urlString = @"order/memberAddress";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            // 获取数据
            self.address = [SLAddressModel yy_modelWithJSON:result[@"info"]];
        } else {
            [SVProgressHUD showInfoWithStatus:@"数据异常！"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

// 加载购物车数量
- (void)loadCartCount {
    SLUserModel *user = [SLUserModel achieveUser];
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"memberCode"] = user.CardID; // 会员号
    // 请求参数
    // 3.发送请求
    NSString *urlString = @"cart/cartCount";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
             SLLog(@"加载购物车后数量：%@", [result[@"count"] stringValue]);
            // 获取数据
            self.tabBarItem.badgeValue = [result[@"count"] stringValue];
            // 保存至全局
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            appDelegate.cartBadge = [result[@"count"] stringValue];
        } else {
            [SVProgressHUD showInfoWithStatus:@"数据异常！"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

// 加载购物车
- (void)loadCartList{
    
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
    parameters[@"pageSize"] = @"20"; // 购物车最多也就50
    parameters[@"memberCode"] = self.user.CardID; // 会员号
    // 3.发送请求
    NSString *urlString = @"cart/cartList";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            // 获取数据
            NSArray *list = [NSArray yy_modelArrayWithClass:[SLOrderModel class] json:result[@"list"]];
            // 保存数据
//            [self.orders addObjectsFromArray:list];
            self.orders = [list mutableCopy];
            [self.myTableView reloadData];
            
            // 设置购物车数量
            NSString *nums = [NSString stringWithFormat:@"%@", result[@"count"]];
            self.tabBarItem.badgeValue = nums;
            // 保存至全局
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            appDelegate.cartBadge = nums;
            
            SLLog(@"加载购物车集合后数量：%@", [result[@"count"] stringValue]);
        } else {
            [SVProgressHUD showInfoWithStatus:@"数据异常！"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
    
}

// 提交订单
- (void)payCartInfo{

    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    [self showPrice]; // 计算总金额
    // 2.封装请求参数
    for (int i = 0; i < self.selOrders.count; ++i) {
        SLOrderModel *order = self.selOrders[i];
        order.receivingPerson = self.nameLabel.text;
        order.clientPhone = self.phoneLabel.text;
        order.dispatchingAddress = self.addressLabel.text;
        order.logisticsInfo = self.deliverLabel.text;
    }
    NSString *jsonString = [self.selOrders yy_modelToJSONString];
    NSString *json = [jsonString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 请求参数
    // 3.发送请求
    NSString *urlString = @"order/orderJsonAdd";
    [tools POST:urlString parameters:json success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            // 跳转到我的页面
//            SLMineViewController *vc = [[SLMineViewController alloc] init];
//            self.tabBarController.selectedViewController = vc;
//            self.tabBarController.selectedIndex = 3;
            
            // 跳到支付页面
            SLPayViewController *vc = [[SLPayViewController alloc] init];
            UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
            // 获取订单ids 与 总金额
            vc.orderIds = result[@"orderIds"]; // 订单编号
//            vc.points = [NSString stringWithFormat:@"%lld", [[self.priceLabel.text stringByReplacingCharactersInRange: NSMakeRange(0, 1) withString:@""] longLongValue]];
            vc.moneys = [NSString stringWithFormat:@"%@", [self.priceLabel.text stringByReplacingCharactersInRange: NSMakeRange(0, 1) withString:@""]];
            [self.selOrders removeAllObjects];
            
            // 取消勾选
            NSInteger sections = self.myTableView.numberOfSections;
            for (int section = 0; section < sections; section++) {
                NSInteger rows = [self.myTableView numberOfRowsInSection:section];
                for (int row = 0; row < rows; row++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                    SLCartTableCell *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
                    cell.redio.selected = NO;
                }
            }
            SLLog(@"订单总金额：%@ -- %@", self.priceLabel.text, vc.points);
            
            [self presentViewController:navVc animated:YES completion:^{}];
        } else {
            [SVProgressHUD showInfoWithStatus:result[@"return_msg"]];
            
            // 酒店订单跳到我的页面
            if ([result[@"err_code"] isEqualToString:@"mine"]) {
                // 刷新购物车
                [self loadCartList];
                [self.selOrders removeAllObjects];
                
//                SLLog(@"========%@SLTabBarController", self.parentViewController.parentViewController);
                SLTabBarController *tabBarCtrl = (SLTabBarController*)self.parentViewController.parentViewController;
                [tabBarCtrl.customTabBar btnOnClick:tabBarCtrl.customTabBar.btns[3]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error)  {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

// 修改购物车
- (void)updateCart:(SLOrderModel *) cart{
    
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSString *jsonString = [cart yy_modelToJSONString];
    NSString *json = [jsonString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // 3.发送请求
    NSString *urlString = @"cart/cartJsonUpdate";
    [tools POST:urlString parameters:json success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
//            [SVProgressHUD showInfoWithStatus:@"操作成功！"];
        } else {
            [SVProgressHUD showInfoWithStatus:@"接口异常！"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error)  {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

// 删除购物车
- (void)delCartOrder:(NSInteger)orderId productId:(NSInteger)productId{
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
    parameters[@"cartId"] = [NSString stringWithFormat:@"%ld", (long)orderId]; // 订单Id
    parameters[@"productId"] = [NSString stringWithFormat:@"%ld", (long)productId]; // 产品Id
    // 3.发送请求
    NSString *urlString = @"cart/cartDelete";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            
            // 客户端删除
            NSMutableArray *lastList = [NSMutableArray array];

            for (int i = 0; i < self.orders.count; ++i) {
                SLOrderModel *order = self.orders[i]; // 购物车元素
                SLOrderModel * lastorder = [[SLOrderModel alloc] init];
                lastorder.idstr = order.idstr;
                lastorder.fkSupplierManageId = order.fkSupplierManageId;
                lastorder.fkSupplierManageName = order.fkSupplierManageName;
                lastorder.fkSupplierManageCode = order.fkSupplierManageCode;
                lastorder.clientName = order.clientName;
                lastorder.clientCode = order.clientCode;
                lastorder.products = [NSArray array];
                for (int i = 0; i < order.products.count; ++i) {
                    SLSubOrderModel *selProd = order.products[i];
                    if (![selProd.idstr isEqualToString: [NSString stringWithFormat: @"%ld", (long)productId]]) {
                        lastorder.products = [lastorder.products arrayByAddingObject:selProd];
                    }
                }
                
                // 添加有效订单数据
                if (lastorder.products.count > 0) {
                    [lastList addObject: lastorder];
                }
            }

            self.orders = lastList;

            [self.myTableView reloadData];
            
            // 更新全部变量
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            int nums = [appDelegate.cartBadge intValue] - 1;
            appDelegate.cartBadge = [NSString stringWithFormat:@"%d", nums];
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", nums];
            
            SLLog(@"删除购物车后数量：%d", nums);
        } else {
            [SVProgressHUD showInfoWithStatus:@"数据异常！"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

// 选择类型
- (void)selectType:(id)sender {
    
    // 0.先移除之前的view
    [self.dataView removeFromSuperview];
    
    // 1.创建选择器
    SLDataPickerView *dataView = [[SLDataPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300)];
    dataView.delegate = self;
    dataView.title = @"请选择配送方式";
    self.dataView = dataView;
   
    [self.view addSubview:dataView];
    
    // 2.加载数据
    self.dataView.dataArray = self.shippings;
    //    [dataView.pickerView reloadAllComponents];
    
    // 3. 显示控件
    [self.dataView showDataView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark 按钮事件
// 地址
- (void)personClick:(UIButton*)btn{
    SLPersonViewController *vc = [[SLPersonViewController alloc] init];
    vc.address = self.address;
    [self.navigationController pushViewController:vc animated:YES];
}
// 配送方式
- (void)deliverClick:(UIButton*)btn{
    [self selectType:btn];
}
// 去支付
- (void)payBtnClick:(UIButton*)btn{
    // 非空验证
//    if ([self.nameLabel.text isEqualToString:@""]) {
//        [SVProgressHUD showInfoWithStatus:@"请填写收货人信息！"];
//        return;
//    }
    if ([SLStringUtil isBlankString:self.nameLabel.text]) {
        [SVProgressHUD showInfoWithStatus:@"收货人不能为空"];
        return;
    } else if ([SLStringUtil isBlankString:self.phoneLabel.text]) {
        [SVProgressHUD showInfoWithStatus:@"收货电话不能为空"];
        return;
    } else if ([SLStringUtil isBlankString:self.addressLabel.text]) {
        [SVProgressHUD showInfoWithStatus:@"收货地址不能为空"];
        return;
    }
    if (self.selOrders.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择要支付的订单！"];
    } else {
        [self payCartInfo]; // 订单支付
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.orders.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 订单中的产品
    SLOrderModel *order = self.orders[section];
    NSArray *products = order.products;
    
    return products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 获得cell
    SLCartTableCell *cell = [SLCartTableCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.redio.selected = NO;
    SLOrderModel *order = self.orders[indexPath.section];
    SLSubOrderModel *product = order.products[indexPath.row];
//    product.fkSupplierManageId = order.fkSupplierManageId;
//    product.fkSupplierManageName = order.fkSupplierManageName;
//    product.fkSupplierManageCode = order.fkSupplierManageCode;
    
    cell.subProduct = product;
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    SLOrderModel *order = self.orders[indexPath.section];
//    SLSubProductModel *model = order.products[indexPath.row];
    
//    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"subProduct" cellClass:[SLCartTableCell class] contentViewWidth:kSLscreenW];
    
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // 订单数据
    SLOrderModel *order = self.orders[section];
    // 容器
    UIView *view = [[UIView alloc] init];
    [view setFrame: CGRectMake(0, 0, kSLscreenW, 40)];
    view.backgroundColor = [UIColor whiteColor];

    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_title"]];
    [imgView setFrame: CGRectMake(12, 18, 5, 5)];
    UILabel *title = [[UILabel alloc] init];
    [title setFrame: CGRectMake(20, 5, kSLscreenW - 40, 30)];
    title.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
    title.textColor = kSLLabelColor;
    title.text = order.fkSupplierManageName; // 供应商
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kSLscreenW, 1)];
    lineView.backgroundColor = SLColor(241,241,241, 255);
    
    [view addSubview:imgView];
    [view addSubview:title];
    [view addSubview:lineView];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

#pragma mark -
#pragma mark Data控件
- (void)dataPickerViewSave:(NSString *)selectStr number:(NSInteger)selectNum {
    if (selectStr != nil) {
        self.deliverLabel.text = selectStr;
    }
}

#pragma mark -
#pragma mark cell 代理
// 产品选中状态发生变化
- (void)productSelect:(SLSubOrderModel *)product isSelect:(BOOL) isSelect{
    // 添加或删除预提交订单
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"idstr = '%ld'", (long)product.fkCartManage]];
    NSArray *orderList = [self.orders copy]; // 获取新集合
    NSArray *oNewList = [orderList filteredArrayUsingPredicate:predicate]; // 符合条件的订单
    SLOrderModel *order = oNewList.firstObject; // 符合条件的只有一个
    if (isSelect) { // 选中状态，加入到选中订单集合
        // 1、选中订单结合存在此商品订单，在存在的订单中添加商品
        NSArray *sList = [self.selOrders copy];
        NSArray *nlist = [sList filteredArrayUsingPredicate:predicate];
        SLOrderModel *nOrder = nlist.firstObject;
        if (nOrder != nil) {
            nOrder.products = [nOrder.products arrayByAddingObject:product]; // 添加商品
        } else {
            // 2、选中订单集合中不存在此商品订单，增加新订单，并添加商品
            SLOrderModel *order2 = [[SLOrderModel alloc] init];
            order2.idstr = order.idstr;
            order2.fkSupplierManageId = order.fkSupplierManageId;
            order2.fkSupplierManageName = order.fkSupplierManageName;
            order2.fkSupplierManageCode = order.fkSupplierManageCode;
            order2.products = [NSArray arrayWithObject:product];
            order2.clientCode = self.user.CardID;
            order2.clientName = self.user.CardName;
            order2.receivingPerson = self.nameLabel.text;
            order2.clientPhone = self.phoneLabel.text;
            order2.dispatchingAddress = self.addressLabel.text;
            [self.selOrders addObject:order2];
        }
        // 设置未选中
        product.selStatus = YES;
    } else { // 从选中集合中删除
        NSArray *orderSelList = [self.selOrders copy]; // 获取新集合
        NSArray *oNewSelList = [orderSelList filteredArrayUsingPredicate:predicate]; // 符合条件的订单
        SLOrderModel *selOrder = oNewSelList.firstObject; //符合条件的只有一个
        // 判断订单中商品的数量
        NSUInteger currCount = selOrder.products.count; // 选中产品所属订单中的产品数量
        if (currCount == 1) {
            [self.selOrders removeObject:selOrder]; // 直接删除订单
        } else { // 删除订单中的商品
            NSMutableArray *pList = [NSMutableArray array]; // 重新组装产品
            for (int i = 0; i < selOrder.products.count; ++i) {
                SLSubOrderModel *selProd = selOrder.products[i];
                if (![selProd.idstr isEqualToString:product.idstr]) {
                     [pList addObject:selProd]; // 添加非选中的其他数组
                }
            }
            selOrder.products = [pList copy];
        }
        // 设置选中
        product.selStatus = NO;
    }
    
    // 计算显示合计
    [self showPrice];
}

// 选中的产品数量变化
- (void)productChange:(SLSubOrderModel *)product number:(NSInteger)num {
    SLLog(@"修改购物车");
    
    // 得到被选中的订单，修改订单数量
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"idstr = '%ld'", (long)product.fkCartManage]];
    NSArray *orderSelList = [self.orders copy]; // 获取新集合
    NSArray *oNewSelList = [orderSelList filteredArrayUsingPredicate:predicate]; // 符合条件的订单
    SLOrderModel *selOrder = oNewSelList.firstObject; // 符合条件的只有一个
    for (int i = 0; i < selOrder.products.count; ++i) {
        SLSubOrderModel *selProd = selOrder.products[i];
        if ([selProd.idstr isEqualToString:product.idstr]) {
            selProd.amount = num;
        }
    }
    
    // 计算显示合计
    [self showPrice];
    
    // 修改服务器数据
    [self updateCart:selOrder];
}

// 删除购物车
- (void)productDel:(SLSubOrderModel *)product{
    SLLog(@"删除购物车");
    
    // 客户端删除
//    [self.myTableView deleteSections:[NSIndexSet indexSetWithIndex:1l] withRowAnimation:UITableViewRowAnimationLeft];
//    [self.myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.orders[1]] withRowAnimation:UITableViewRowAnimationLeft];
    
    // 服务端删除
    [self delCartOrder:product.fkCartManage productId:product.idstr.integerValue];
    
}

#pragma mark -
#pragma mark SET GET
// 配送地址
- (void)setAddress:(SLAddressModel *)address {
    _address = address;
    self.nameLabel.text = address.name;
    self.addressLabel.text = address.address;
    self.phoneLabel.text = address.phone;
    [UILabel changeLineSpaceForLabel:self.addressLabel WithSpace:10.0];
}

// 配送方式
- (NSMutableArray *)shippings {
    if (!_shippings) {
        _shippings = [NSMutableArray arrayWithObjects: @"送货上门", @"上门自取", nil];
    }
    return _shippings;
}

// 订单
- (NSMutableArray *)orders {
    if (!_orders) {
        _orders = [NSMutableArray array];
    }
    return _orders;
}

// 已选中的订单
- (NSMutableArray *)selOrders {
    if (!_selOrders) {
        _selOrders = [NSMutableArray array];
    }
    return _selOrders;
}

#pragma mark -
#pragma mark 私有计算方法
- (void)showPrice {
    // priceLabel.text = [NSString stringWithFormat:@"￥%d", 180];
    double totleP = 0; // 全部金额
    for (int i = 0; i < self.selOrders.count; ++i) {
        SLOrderModel *order = self.selOrders[i];
        double orderP = 0; // 订单金额
        for (int j = 0; j < order.products.count; ++j) {
            SLSubOrderModel *subPro = order.products[j];
            orderP += subPro.totalPrie.doubleValue; // 产品金额
            totleP += subPro.totalPrie.doubleValue; // 总金额
        }
        order.orderMoney = [NSNumber numberWithDouble:orderP];
    }
    self.priceLabel.text =  [NSString stringWithFormat:@"￥%.2f", totleP];
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//    formatter.numberStyle = NSNumberFormatterDecimalStyle;
//    formatter stringFromNumber:<#(nonnull NSNumber *)#>
}

@end

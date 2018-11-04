//
//  SLMineViewController.m
//  MGBEB
//
//  Created by SurgeLee on 2018/6/19.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLMineViewController.h"

#import "SLHeader.h"

#import "SLMineTableCell.h"
#import "SLPayViewController.h"

#import "SLOrderModel.h"
#import "SLUserModel.h"
#import "OrderUtils.h"

#import "SLLoginViewController.h"
#import <MJRefresh.h>

#import "SLLogicTableViewController.h"
#import "SLEvaluViewController.h"

//#import "EaseMessageViewController.h"
#import "SLMessageController.h"
#import "SLNavigationController.h"
#import "EaseTextView.h"
#import "SLMessageListController.h"
#import "UIBarButtonItem+Extension.h"

#define kSLLabelColor SLColor(42,42,42, 255)
#define kSLDisableColor SLColor(197, 197, 197, 255)

@interface SLMineViewController ()<SLMineCellDelegate>

@property (strong, nonatomic) NSMutableArray *orders; //订单信息

@property (strong, nonatomic) UILabel *yueLabel; // 余额
@property (strong, nonatomic) UILabel *jifenLabel; // 积分

@end

@implementation SLMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 设置导航
    [self setuptNavView];
    
    // 设置头视图
    [self setupHeaderView];
    // 去除分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 初始化数据
//    [self initData];
    self.tableView.backgroundColor = SLColor(232, 232, 232, 232);
    
    // 初始化刷新控件
    [self setupRefresh];
    
}

// 修改样式
- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)setuptNavView {
//   UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    negativeSpacer.width = +10;  //偏移距离  -向左偏移, +向右偏移
//    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
//    [right setImage:[UIImage imageNamed:@"mine_info"] forState:UIControlStateNormal];
//    [right addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
//    right.size = CGSizeMake(10, 10);
//    right.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
//    self.navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:right]];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"message_icon" higImage:@"message_icon" target:self action:@selector(rightClick:)];
}

- (void)rightClick:(UIButton *)btn {
    
    SLMessageListController *vc = [[SLMessageListController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)setupHeaderView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSLscreenW, 60)];
    view.backgroundColor = SLColor(221,226,233, 255);
    UIView *headBackView = [[UIView alloc] initWithFrame:CGRectMake(12, 8, kSLscreenW - 24, 45)];
    headBackView.backgroundColor = [UIColor whiteColor];
    [headBackView.layer setMasksToBounds:YES];
    headBackView.layer.cornerRadius = 8.0;
    [view addSubview:headBackView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_money2"]];
    UILabel *yuLabel = [[UILabel alloc] init];
    yuLabel.textColor = kSLLabelColor;
    [yuLabel setFont: [UIFont systemFontOfSize:13]];
    yuLabel.text = @"卡余额:";
    UILabel *yueLabel = [[UILabel alloc] init];
    yueLabel.textColor = kSLLabelColor;
    [yueLabel setFont: [UIFont systemFontOfSize: 13]];
    yueLabel.text = @"0";
    self.yueLabel = yueLabel;
    UILabel *jiLabel = [[UILabel alloc] init];
    jiLabel.textColor = kSLLabelColor;
    [jiLabel setFont: [UIFont systemFontOfSize: 13]];
    jiLabel.text = @"积分:";
    UILabel *jifenLabel = [[UILabel alloc] init];
    jifenLabel.textColor = kSLLabelColor;
    [jifenLabel setFont: [UIFont systemFontOfSize: 13]];
    jifenLabel.text = @"0";
    self.jifenLabel = jifenLabel;
    
    [headBackView addSubview:imgView];
    [headBackView addSubview:yuLabel];
    [headBackView addSubview:yueLabel];
    [headBackView addSubview:jiLabel];
    [headBackView addSubview:jifenLabel];
    
    imgView.sd_layout.leftSpaceToView(headBackView, 15)
        .topSpaceToView(headBackView, 15)
        .widthIs(15).heightIs(15);
    yuLabel.sd_layout.leftSpaceToView(imgView, 5)
        .topSpaceToView(headBackView, 15)
        .widthIs(60).heightIs(15);
    yueLabel.sd_layout.leftSpaceToView(yuLabel, 0)
        .rightSpaceToView(headBackView, kSLscreenW/2 - 30)
        .topSpaceToView(headBackView, 15)
        .heightIs(15);
    jiLabel.sd_layout.leftSpaceToView(yueLabel, 0)
        .topSpaceToView(headBackView, 15)
        .widthIs(40).heightIs(15);
    jifenLabel.sd_layout.leftSpaceToView(jiLabel, 0)
        .rightSpaceToView(headBackView, 0)
        .topSpaceToView(headBackView, 15)
        .heightIs(15);
    
    self.tableView.tableHeaderView = view;
}

// 添加刷新
- (void)setupRefresh {
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreOrderList)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    SLMineTableCell *cell = [SLMineTableCell cellWithTableView:tableView];
    cell.delegate = self; // 设置代理
    
    SLOrderModel *order = self.orders[indexPath.section];
    SLSubOrderModel *product = order.products[indexPath.row];
//    product.fkSupplierManageId = order.fkSupplierManageId;
//    product.fkSupplierManageName = order.fkSupplierManageName;
//    product.fkSupplierManageCode = order.fkSupplierManageCode;
    cell.subProduct = product;
    cell.orderStatus = order.orderStatus; // 

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    SLSubProductModel *model = [[SLSubProductModel alloc] init];
//
//    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"subProduct" cellClass:[SLCartTableCell class] contentViewWidth:kSLscreenW];
    
    return 115;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // 订单数据
    SLOrderModel *order = self.orders[section];
    
    // 容器
    UIView *view = [[UIView alloc] init];
    [view setFrame: CGRectMake(0, 0, kSLscreenW, 120)];
    view.backgroundColor = [UIColor whiteColor];
    // 订单
    UILabel *orderLabel = [[UILabel alloc] init];
    orderLabel.text = [NSString stringWithFormat:@"订单: %@", order.orderCode];
    orderLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size: 13];
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.attributedText = [SLStringUtil stringWithString:[NSString stringWithFormat:@"%@", [OrderUtils statusWithValue:order.orderStatus type:order.type]] font:SLCellFont3 color: SLColor(255,153,1,255)];
    statusLabel.textAlignment = NSTextAlignmentRight;
    // 分组
    UILabel *title = [[UILabel alloc] init];
    title.font = SLCellFont4;
    title.textColor = kSLLabelColor;
    title.text = order.fkSupplierManageName;//@"上海巴拉巴拉服饰公司";
    
    [view addSubview:orderLabel];
    [view addSubview:statusLabel];
    [view addSubview:title];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = SLColor(241,241,241, 255);
    [view addSubview:lineView1];
    
    orderLabel.sd_layout.leftSpaceToView(view, 10)
        .rightSpaceToView(view, 0)
        .topSpaceToView(view, 12)
        .heightIs(10);
    statusLabel.sd_layout.rightSpaceToView(view, 15)
        .topSpaceToView(view, 12)
        .heightIs(10).widthIs(120); // 右侧 sureBtn, 0  上 orderLabel, 0
    lineView1.sd_layout.leftSpaceToView(view, 0)
        .topSpaceToView(orderLabel, 12)
        .heightIs(1).widthIs(kSLscreenW);
    title.sd_layout.leftSpaceToView(view, 20)
        .rightSpaceToView(view, 0)
        .topSpaceToView(lineView1, 12)
        .heightIs(10);
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 110;
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    // 订单数据
    SLOrderModel *order = self.orders[section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSLscreenW, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *totleLabel = [[UILabel alloc] init];
    totleLabel.font = SLCellFont;
    totleLabel.text = @"合计";
    UILabel *priceLabel = [[UILabel alloc] init];
//    priceLabel.text = [NSString stringWithFormat:@"￥%d", 180];
    priceLabel.text = [NSString stringWithFormat:@"￥%.2f", order.orderMoney.doubleValue];
    priceLabel.textColor = SLColor(251, 0, 8, 255);
    [priceLabel setFont: [UIFont systemFontOfSize: 15]];
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [delBtn setTitle:@"删除订单" forState:UIControlStateNormal];
    [delBtn setTitleColor:kSLLabelColor forState:UIControlStateNormal];
    delBtn.titleLabel.font = [UIFont systemFontOfSize: 11];
    delBtn.tag = 1000 + [order.idstr integerValue];  // 设置订单ID
    [delBtn addTarget:self action:@selector(orderDel:order:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [payBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [payBtn setBackgroundImage:[UIImage imageNamed:@"btn_pay_back"] forState:UIControlStateNormal];
//    [payBtn setTitleColor:kSLLabelColor forState:UIControlStateNormal];
//    [payBtn setTitleColor:kSLDisableColor forState:UIControlStateDisabled];
    payBtn.titleLabel.font = SLCellFont3;
    payBtn.tag = 1000 + [order.idstr integerValue];  // 设置订单ID
    [payBtn addTarget:self action:@selector(orderPay:order:) forControlEvents:UIControlEventTouchUpInside];
    
    // 去支付按钮禁用判断
    if (order.type == 2) { // 酒店订单，不是审核通过状态禁用按钮
        if (order.orderStatus != 4) {
            payBtn.enabled = NO;
        }
    } else {
        if (order.orderStatus != 0) { // 非未支付 禁用按钮
            payBtn.enabled = NO;
        }
    }

    // 物流  退款  客服
    UIButton *logisBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logisBtn setBackgroundImage:[UIImage imageNamed:@"btn_pay_back"] forState:UIControlStateNormal];
    [logisBtn setTitle:@"物流信息" forState:UIControlStateNormal];
    logisBtn.titleLabel.font = SLCellFont3;
//    [logisBtn.layer setMasksToBounds:YES];
//    [logisBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
//    [logisBtn.layer setBorderWidth:1.0]; // 边框宽度
    [logisBtn addTarget:self action:@selector(loadLogis:) forControlEvents:UIControlEventTouchUpInside];
    logisBtn.tag = 1000 + [order.idstr integerValue];  // 设置订单ID
    
    UIButton *refundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refundBtn setTitleColor:kSLLabelColor forState:UIControlStateNormal];
    [refundBtn setTitleColor:kSLDisableColor forState:UIControlStateDisabled];
    [refundBtn setTitle:@"退款申请" forState:UIControlStateNormal];
    refundBtn.titleLabel.font = [UIFont systemFontOfSize: 11];
//    [refundBtn.layer setMasksToBounds:YES];
//    [refundBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
//    [refundBtn.layer setBorderWidth:1.0]; // 边框宽度
    [refundBtn addTarget:self action:@selector(loadRefund:) forControlEvents:UIControlEventTouchUpInside];
    refundBtn.tag = 1000 + [order.idstr integerValue];  // 设置订单ID

    UIButton *onlineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [onlineBtn setBackgroundImage:[UIImage imageNamed:@"btn_pay_back"] forState:UIControlStateNormal];
    [onlineBtn setTitle:@"在线客服" forState:UIControlStateNormal];
    onlineBtn.titleLabel.font = SLCellFont3;
    [onlineBtn addTarget:self action:@selector(loadOnline:) forControlEvents:UIControlEventTouchUpInside];
    onlineBtn.tag = 3000 + section;  // 在线客户tag
    
    // 退款按钮禁用判断  1 支付完成（未配送）2 配送中 3完成 ---  0未申请（退款）
    if ((order.orderStatus == 1 || order.orderStatus == 2 || order.orderStatus == 3) && (order.refundStatus == 0)) {
        refundBtn.enabled = YES;
    } else {
        refundBtn.enabled = NO;
        refundBtn.layer.borderColor = kSLDisableColor.CGColor;
        // 设置退款按钮显示名称
        [refundBtn setTitle:[NSString stringWithFormat:@"%@", [OrderUtils refundWithValue:order.refundStatus]] forState:UIControlStateDisabled];
        
//        SLLog(@"退款状态%@", [NSString stringWithFormat:@"%@", [OrderUtils refundWithValue:order.refundStatus]]);
    }
    
    [view addSubview:totleLabel];
    [view addSubview:priceLabel];
    [view addSubview:delBtn];
    [view addSubview:payBtn];
    [view addSubview:logisBtn];
    [view addSubview:refundBtn];
    [view addSubview:onlineBtn]; // 在线客服
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = SLColor(241,241,241, 255);
    [view addSubview:lineView2];
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.backgroundColor = SLColor(241,241,241, 255);
    [view addSubview:lineView3];
    
    lineView2.sd_layout.leftSpaceToView(view, 0)
        .topSpaceToView(view, 0)
        .heightIs(1).widthIs(kSLscreenW);
    totleLabel.sd_layout.leftSpaceToView(view, 20)
        .topSpaceToView(view, 5)
        .heightIs(30).widthIs(35);
    lineView3.sd_layout.leftSpaceToView(view, 0)
        .topSpaceToView(totleLabel, 5)
        .heightIs(1).widthIs(kSLscreenW);
    refundBtn.sd_layout.rightSpaceToView(view, 15)
        .topSpaceToView(view, 5)
        .heightIs(30).widthIs(50);
    delBtn.sd_layout.rightSpaceToView(refundBtn, 15)
        .topSpaceToView(view, 5)
        .heightIs(30).widthIs(50);
    priceLabel.sd_layout.leftSpaceToView(totleLabel, 5)
        .rightSpaceToView(delBtn, 10)
        .topSpaceToView(view, 4)
        .heightIs(30);
    
    payBtn.sd_layout.rightSpaceToView(view, 15)
        .topSpaceToView(totleLabel, 15)
        .heightIs(25).widthIs(70);
    logisBtn.sd_layout.rightSpaceToView(payBtn, 10)
        .topSpaceToView(totleLabel, 15)
        .heightIs(25).widthIs(70);
    onlineBtn.sd_layout.rightSpaceToView(logisBtn, 10)
        .topSpaceToView(totleLabel, 15)
        .heightIs(25).widthIs(70);
    
    UIView *lineView4 = [[UIView alloc] init];
    lineView4.backgroundColor = SLColor(241,241,241, 255);
    [view addSubview:lineView4];
    lineView4.sd_layout.leftSpaceToView(view, 0)
        .bottomEqualToView(view)
        .heightIs(8).widthIs(kSLscreenW);
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 90;
}

// 解决footer隐藏问题
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y == -64) {
//        scrollView.contentInset = UIEdgeInsetsMake(0, 0, -50, 0);
//    }else if (scrollView.contentOffset.y >= scrollView.contentSize.height - kSLscreenH) {
//        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    } else if (scrollView.contentOffset.y >= 0){
//        scrollView.contentInset = UIEdgeInsetsMake(0, 0, -50, 0);
//    }
}

#pragma mark -
#pragma mark 数据处理
- (void)viewWillAppear:(BOOL)animated {
    // 初始化数据
    [self initData];
    // 样式修正
//    [UIView animateWithDuration:0.1 animations:^{
//        self.tableView.contentOffset = CGPointMake(0, 0);
//    }];
}

// 初始化数据
- (void)initData {
    // 重新刷新用户信息
    [self userInfo];
    
    // 初始化购物车
    [self loadOrderList];
}

// 加载订单
- (void)loadOrderList{
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
    parameters[@"pageSize"] = @"10"; // 购物车最多也就50
//    parameters[@"orderStatus"] = @"0"; // 全部状态订单
    parameters[@"deleteFlag"] = @"1"; // 未删除
    parameters[@"clientCode"] = user.CardID; // 客户代码
    // 3.发送请求
    NSString *urlString = @"order/ordersList";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            // 获取数据
            NSArray *list = [NSArray yy_modelArrayWithClass:[SLOrderModel class] json:result[@"list"]];
            // 保存数据
//            [self.orders addObjectsFromArray:list];
            self.orders = [list mutableCopy];
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:@"数据异常！"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
    
}

// 加载更多订单
- (void)loadMoreOrderList{
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
    SLOrderModel *om = self.orders.lastObject;
    parameters[@"minId"] = om.idstr;
    parameters[@"pageSize"] = @"10"; // 每页显示数量
    //    parameters[@"orderStatus"] = @"0"; // 全部状态订单
    parameters[@"deleteFlag"] = @"1"; // 未删除
    parameters[@"clientCode"] = user.CardID; // 客户代码
    // 3.发送请求
    NSString *urlString = @"order/ordersList";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            // 获取数据
            NSArray *list = [NSArray yy_modelArrayWithClass:[SLOrderModel class] json:result[@"list"]];
            // 保存数据
            if (list.count > 0) {
                [self.orders addObjectsFromArray:list];
            }
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:@"数据异常！"];
        }
        
        // 关闭刷新控件
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
        // 关闭刷新控件
        [self.tableView.mj_footer endRefreshing];
    }];
}

// 删除订单
- (void)delOrder:(NSInteger)orderId{
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
    parameters[@"orderId"] = [NSString stringWithFormat:@"%ld", orderId]; // 订单Id
    // 3.发送请求
    NSString *urlString = @"order/orderDelete";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            
            // 更新订单集合
            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"idstr != '%ld'", orderId]];
            self.orders = [[self.orders filteredArrayUsingPredicate:predicate] mutableCopy];

            [self.tableView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:@"数据异常！"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

// 支付
- (void)payOrder:(SLOrderModel*)order{
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSString *jsonString = [order yy_modelToJSONString];
    //    NSString *json = [jsonString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 请求参数
    // 3.发送请求
    NSString *urlString = @"other/adjustPoint";
    [tools POST:urlString parameters:jsonString success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            // 跳转到我的页面
            
        } else {
//            [SVProgressHUD showInfoWithStatus:@"数据异常！"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error)  {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

// 登陆操作
- (void)userInfo{
    SLUserModel *user = [SLUserModel achieveUser];
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
    parameters[@"MasterAccount"] = user.CardID;
    parameters[@"PassWord"] = user.Password;
    // 3.发送请求
    NSString *urlString = @"other/getMemInfo";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"登陆返回数据： %@", result);
        
        if ([result[@"status"] integerValue] == 1){
            // 保存登陆信息
            SLUserModel *user2 = [SLUserModel yy_modelWithJSON: result];
            user2.Password = user.Password;
            // 数据归档
            [user2 saveUser];
            // 设置积分
            self.jifenLabel.text = [NSString stringWithFormat:@"%.2f", user2.Point.doubleValue];
            self.yueLabel.text = [NSString stringWithFormat:@"%.2f", user2.Money.doubleValue];

        } else {
            // 登陆信息验证失败
            [SVProgressHUD showInfoWithStatus:@"登陆信息验证失败！"];
            [[[UIApplication sharedApplication] delegate] window].rootViewController = [[SLLoginViewController alloc] init];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
        [[[UIApplication sharedApplication] delegate] window].rootViewController = [[SLLoginViewController alloc] init];
    }];
    
}

#pragma mark -
#pragma mark 按钮
// 删除订单
- (void)orderDel:(UIButton *)btn order:(NSInteger)orderId{
    // 请求后台
    [self delOrder:btn.tag - 1000];
}
// 订单支付
- (void)orderPay:(UIButton*)btn order:(SLOrderModel*)order{
    // 请求后台
//    [self payOrder:order];
    SLPayViewController *vc = [[SLPayViewController alloc] init];
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    [vc.orderIds addObject:[NSString stringWithFormat:@"%ld", btn.tag - 1000]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"idstr = '%ld'", btn.tag - 1000]];
    NSArray *oList = [self.orders copy]; // 获取新集合
    NSArray *nList = [oList filteredArrayUsingPredicate:predicate];
    SLOrderModel *o = nList.firstObject;
//    vc.points = [NSString stringWithFormat:@"%lld", o.orderMoney.longLongValue];
    vc.moneys = [o.orderMoney stringValue];
    [self presentViewController:navVc animated:YES completion:^{}];
}

// 加载物流信息
- (void)loadLogis:(UIButton*) btn{
    SLLogicTableViewController *vc = [[SLLogicTableViewController alloc] init];
    vc.orderId = btn.tag - 1000;
    [self.navigationController pushViewController:vc animated:YES];
}

// 申请退款
- (void)loadRefund:(UIButton*) btn{
//    [self refundClick:btn.tag - 1000];
    [self showAlert:btn];
}

// 请求退款接口
- (void)refundClick:(NSInteger) orderId{
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
//    parameters[@"orderId"] = [NSString stringWithFormat:@"%ld", btn.tag - 1000]; // 订单id @"68"
    parameters[@"orderId"] = [NSString stringWithFormat:@"%ld", orderId];
    // 3.发送请求
    NSString *urlString = @"order/refund";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            // 获取数据
            [SVProgressHUD showInfoWithStatus:@"申请成功，等待审核！"];
//            [self.tableView reloadData];
            [self loadOrderList]; // 重新设置数据
        } else {
            [SVProgressHUD showInfoWithStatus:result[@"return_msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

- (IBAction)showAlert:(UIButton *)sender {
    //显示提示框
    //过时
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"message" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    //    [alert show];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"是否确认申请退款？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        SLLog(@"action = %@", action);
//        SLLog(@"按钮tag:%ld", sender.tag);
        // 调用退款按钮
        [self refundClick:sender.tag - 1000];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        SLLog(@"action = %@", action);
    }];

    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// 在线客服
- (void)loadOnline:(UIButton*) btn{
    // 获取订单
    SLOrderModel *order = self.orders[btn.tag - 3000];
    SLLog(@"供应商：%@ -- %@", order.fkSupplierManageCode, order.emAccount);
    
    SLMessageController *chatController = [[SLMessageController alloc] initWithConversationChatter:order.emAccount conversationType:EMConversationTypeChat];
                                                                                 
    SLNavigationController *navCtrl = [[SLNavigationController alloc] initWithRootViewController:chatController];
    
    chatController.toUser = order.fkSupplierManageCode;

    [self presentViewController:navCtrl animated:YES completion:^{
        SLLog(@"联系客服");
    }];
    
}

#pragma mark -
#pragma mark 评价代理
- (void)evaluOrder:(NSInteger)orderId productId:(NSInteger)productId prodSubId:(NSInteger)subId detailImg:(NSString *)detailImg{
    
    SLLog(@"订单id=%ld，产品id=%ld，二级产品id=%ld，图片=%@", orderId, productId, subId, detailImg);
    
    SLEvaluViewController *view = [[SLEvaluViewController alloc] init];
    view.orderId = orderId;
    view.productId = productId;
    view.subId = subId;
    view.detailImg = detailImg;
    
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark -
#pragma mark 懒加载
- (NSMutableArray *)orders{
    if (!_orders) {
        _orders = [NSMutableArray array];
    }
    return _orders;
}

@end

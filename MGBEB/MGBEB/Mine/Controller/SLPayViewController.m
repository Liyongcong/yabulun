//
//  SLPayViewController.m
//  MGBEB
//
//  Created by SurgeLee on 2018/7/11.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLPayViewController.h"

#import "SLHeader.h"

#import "UIBarButtonItem+Extension.h"
#import "SLMineViewController.h"

#import "SLUserModel.h"

@interface SLPayViewController ()

//@property (nonatomic, weak) UILabel *point; // 积分
@property (nonatomic, weak) UILabel *money; // 积分
@property (nonatomic, weak) UITextField *password; // 密码

@end

@implementation SLPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 重新设置背景色
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化导航
    [self initNavigation];
    // 初始化页面
    [self setupView];
    // 解决键盘
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}

// 设置导航
- (void)initNavigation {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_back2" higImage:@"nav_back2" target:self  action:@selector(leftBtn:)];
}

- (void)leftBtn:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

// 初始化页面
- (void)setupView{
    UILabel *xfje = [[UILabel alloc] init];
    xfje.font = SLFont13;
    xfje.text = @"消费金额:";
    UILabel *money = [[UILabel alloc] init];
    money.font = SLFont15;
    money.textColor = SLColor(251, 0, 8, 255);
    self.money = money;
    money.text = @"";
    
    UILabel *zfmm = [[UILabel alloc] init];
    zfmm.font = SLFont13;
    zfmm.text = @"支付密码:";
    UITextField *password = [[UITextField alloc] init];
    password.font = SLFont13;
//    password.contentMode = UIViewContentModeScaleToFill;
//    password.background = [UIImage imageNamed:@"searchbar_textfield_background"];
    password.borderStyle = UITextBorderStyleRoundedRect;
    password.secureTextEntry = YES;
    self.password = password;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确定支付" forState:UIControlStateNormal];
    button.backgroundColor = SLColor(226, 72, 39, 255);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.layer.cornerRadius = 10;  //设置按钮的拐角为宽的一半
    button.layer.masksToBounds = YES;
    
    [button addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:xfje];
    [self.view addSubview:money];
    [self.view addSubview:zfmm];
    [self.view addSubview:password];
    [self.view addSubview:button];
    
    xfje.sd_layout.leftSpaceToView(self.view, 30)
        .topSpaceToView(self.view, 50)
        .heightIs(50).widthIs(80);
    money.sd_layout.leftSpaceToView(xfje, 10)
        .rightSpaceToView(self.view, 30)
        .topSpaceToView(self.view, 50)
        .heightIs(50);
    zfmm.sd_layout.leftEqualToView(xfje)
        .rightEqualToView(xfje)
        .topSpaceToView(xfje, 10)
        .heightIs(50);
    password.sd_layout.leftEqualToView(money)
        .rightEqualToView(money)
        .topSpaceToView(money, 18)
        .heightIs(40);
    button.sd_layout.leftSpaceToView(self.view, 30)
        .rightSpaceToView(self.view, 30)
        .topSpaceToView(password, 50)
        .heightIs(50);
}

- (void)viewWillAppear:(BOOL)animated{
    self.money.text = self.moneys;
}

// 支付
- (void)payBtnClick:(UIButton*)btn{
    [self payOrder];
}

- (void)payOrder{
    // 用户
    SLUserModel *user = [SLUserModel achieveUser];
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
    parameters[@"orderIds"] = [self.orderIds componentsJoinedByString:@";"];
    parameters[@"CardIDorMobile"] = user.CardID;
    parameters[@"Password"] = self.password.text;
//    parameters[@"Point"] = self.points; // 积分
    parameters[@"Money"] = self.moneys; // 金额
    // 3.发送请求
    NSString *urlString = @"order/orderJsonPay";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
//            SLMineViewController *vc = [[SLMineViewController alloc] init];
//            self.tabBarController.selectedViewController = vc;
//            self.tabBarController.selectedIndex = 3;
            [SVProgressHUD showInfoWithStatus:@"支付成功！"];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [SVProgressHUD showInfoWithStatus:@"支付失败！"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark 懒加载
- (NSMutableArray *)orderIds{
    if (!_orderIds) {
        _orderIds = [NSMutableArray array];
    }
    return _orderIds;
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

@end

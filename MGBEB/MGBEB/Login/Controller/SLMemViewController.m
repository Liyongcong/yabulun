//
//  SLMemViewController.m
//  MGBEB
//
//  Created by SurgeLee on 2018/7/3.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLMemViewController.h"

#import "SLHeader.h"
#import "UIButton+FillColor.h"
#import "UIBarButtonItem+Extension.h"

#import "SLLoginViewController.h"

#import "SLUserModel.h"

@interface SLMemViewController ()

@property (nonatomic, weak) UILabel *userName;
@property (nonatomic, weak) UILabel *LevelName;
@property (nonatomic, weak) UILabel *money;
@property (nonatomic, weak) UILabel *point;
@property (nonatomic, weak) UIButton *logoutBtn;

@end

@implementation SLMemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // CardID  LevelName  Point Password
    
    // 颜色
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化设置
    [self initNavigation];
    // 初始化页面
    [self setupLoginView];
    // 初始化数据
    [self setupData];
}

// 初始化导航
- (void)initNavigation {

    self.navigationItem.title = @"会员信息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_back2" higImage:@"nav_back" target:self  action:@selector(leftBtn:)];
}

// 导航按钮操作
- (void)leftBtn:(UIButton *)btn {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

// 初始化页面
- (void)setupLoginView{
    // 创建
    UILabel *userNameLabel = [[UILabel alloc] init];
    userNameLabel.font = SLFont13;
    userNameLabel.text = @"会员号";
    UILabel *userName = [[UILabel alloc] init];
    userName.font = SLFont13;
    userName.textColor = SLColor(200, 200, 200, 255);
    userName.text = @"会员号";
    userName.textAlignment = NSTextAlignmentRight;
    UILabel *LevelNameLabel = [[UILabel alloc] init];
    LevelNameLabel.font = SLFont13;
    LevelNameLabel.text = @"会员等级";
    UILabel *LevelName = [[UILabel alloc] init];
    LevelName.font = SLFont13;
    LevelName.textColor = SLColor(200, 200, 200, 255);
    LevelName.text = @"会员等级";
    LevelName.textAlignment = NSTextAlignmentRight;
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.font = SLFont13;
    moneyLabel.text = @"余额";
    UILabel *money = [[UILabel alloc] init];
    money.font = SLFont13;
    money.textColor = SLColor(200, 200, 200, 255);
    money.text = @"";
    money.textAlignment = NSTextAlignmentRight;
    UILabel *pointLabel = [[UILabel alloc] init];
    pointLabel.font = SLFont13;
    pointLabel.text = @"积分";
    UILabel *point = [[UILabel alloc] init];
    point.font = SLFont13;
    point.textColor = SLColor(200, 200, 200, 255);
    point.text = @"";
    point.textAlignment = NSTextAlignmentRight;
    
    UIButton *logoutBtn = [[UIButton alloc] init];
    [logoutBtn setTitle:@"注销登录" forState:UIControlStateNormal];
    [logoutBtn setBackgroundColor:SLColor(28, 119, 215, 255) forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutClick:) forControlEvents:UIControlEventTouchUpInside];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [logoutBtn.layer setMasksToBounds:YES];
    [logoutBtn.layer setCornerRadius:10.0];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = SLColor(200, 200, 200, 255);
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = SLColor(200, 200, 200, 255);
    UIView *line3 = [[UIView alloc]init];
    line3.backgroundColor = SLColor(200, 200, 200, 255);
    UIView *line4 = [[UIView alloc]init];
    line4.backgroundColor = SLColor(200, 200, 200, 255);
    
    [self.view addSubview:userNameLabel];
    [self.view addSubview:userName];
    [self.view addSubview:LevelNameLabel];
    [self.view addSubview:LevelName];
    [self.view addSubview:moneyLabel];
    [self.view addSubview:money];
    [self.view addSubview:pointLabel];
    [self.view addSubview:point];
    [self.view addSubview:logoutBtn];
    [self.view addSubview:line1];
    [self.view addSubview:line2];
    [self.view addSubview:line3];
    [self.view addSubview:line4];
    
    self.userName = userName;
    self.LevelName = LevelName;
    self.money = money;
    self.point = point;
    self.logoutBtn = logoutBtn;
    
    userNameLabel.sd_layout.leftSpaceToView(self.view, 15)
        .topSpaceToView(self.view, 30)
        .heightIs(40).widthIs(80);
    LevelNameLabel.sd_layout.leftEqualToView(userNameLabel)
        .rightEqualToView(userNameLabel)
        .topSpaceToView(userNameLabel, 30)
        .heightIs(40);
    moneyLabel.sd_layout.leftEqualToView(LevelNameLabel)
        .rightEqualToView(LevelNameLabel)
        .topSpaceToView(LevelNameLabel, 30)
        .heightIs(40);
    pointLabel.sd_layout.leftEqualToView(LevelNameLabel)
        .rightEqualToView(LevelNameLabel)
        .topSpaceToView(moneyLabel, 30)
        .heightIs(40);
    
    userName.sd_layout.leftSpaceToView(userNameLabel, 15)
        .rightSpaceToView(self.view, 15)
        .topEqualToView(userNameLabel)
        .heightIs(40);
    LevelName.sd_layout.leftEqualToView(userName)
        .rightEqualToView(userName)
        .topEqualToView(LevelNameLabel)
        .heightIs(40);
    money.sd_layout.leftEqualToView(pointLabel)
        .rightEqualToView(LevelName)
        .topEqualToView(moneyLabel)
        .heightIs(40);
    point.sd_layout.leftEqualToView(pointLabel)
        .rightEqualToView(LevelName)
        .topEqualToView(pointLabel)
        .heightIs(40);
    
    logoutBtn.sd_layout.leftSpaceToView(self.view, 15)
        .rightSpaceToView(self.view, 15)
        .topSpaceToView(point, 50)
        .heightIs(50);
    
    line1.sd_layout.leftEqualToView(logoutBtn)
        .rightEqualToView(logoutBtn)
        .topSpaceToView(userNameLabel, 2)
        .heightIs(2);
    line2.sd_layout.leftEqualToView(line1)
        .rightEqualToView(line1)
        .topSpaceToView(LevelNameLabel, 2)
        .heightIs(2);
    line3.sd_layout.leftEqualToView(line1)
        .rightEqualToView(line1)
        .topSpaceToView(moneyLabel, 2)
        .heightIs(2);
    line4.sd_layout.leftEqualToView(line1)
        .rightEqualToView(line1)
        .topSpaceToView(pointLabel, 2)
        .heightIs(2);
}

// 加载页面数据
- (void)setupData{
    // 解归档
    SLUserModel *user = [SLUserModel achieveUser];
    // 设置页面数据
    self.userName.text = user.CardID;
    self.LevelName.text = user.LevelName;
    self.money.text = [NSString stringWithFormat:@"%.2f", round([user.Money doubleValue]*100)/100];
    //user.Money.description;
    self.point.text = [NSString stringWithFormat:@"%.2f", round([user.Point doubleValue]*100)/100];
    //user.Point.description;
}

// 退出操作
- (void)logoutClick:(UIButton*)btn{
    // 删除用户归档数据
    [SLUserModel delUser];
    // 跳转到登陆页面
    [[[UIApplication sharedApplication] delegate] window].rootViewController = [[SLLoginViewController alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

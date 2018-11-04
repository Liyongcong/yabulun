//
//  SLPersonViewController.m
//  MGBEB
//
//  Created by SurgeLee on 2018/7/6.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLPersonViewController.h"

#import "SLHeader.h"
#import "UIButton+FillColor.h"
#import "SLTextView.h"
#import "UIBarButtonItem+Extension.h"

#import "SLUserModel.h"

@interface SLPersonViewController ()

@property (strong, nonatomic) UITextField *nameText;
@property (strong, nonatomic) UITextField *phoneText;
@property (strong, nonatomic) SLTextView *addressText;

@end

@implementation SLPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 重新设置背景色
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化视图
    [self setupView];
    self.title = @"收货信息";
    // 初始化设置
    [self initNavigation];
}

// 初始化视图
- (void)setupView{
    
    UILabel *nameLabel = [[UILabel alloc] init];
    UILabel *phoneLabel = [[UILabel alloc] init];
    UILabel *addressLabel = [[UILabel alloc] init];
    nameLabel.font = SLFont13;
    phoneLabel.font = SLFont13;
    addressLabel.font = SLFont13;
    nameLabel.text = @"收货人:";
    phoneLabel.text = @"电话:";
    addressLabel.text = @"地址:";
    UITextField *nameText = [[UITextField alloc] init];
    UITextField *phoneText = [[UITextField alloc] init];
    SLTextView *addressText = [[SLTextView alloc] init];
    nameText.font = SLFont13;
    phoneText.font = SLFont13;
    addressText.font = SLFont13;
    addressText.placeholder = @"";
    
    UIButton *saveBtn = [[UIButton alloc] init];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:SLColor(28, 119, 215, 255) forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [saveBtn.layer setMasksToBounds:YES];
    [saveBtn.layer setCornerRadius:10.0];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = SLColor(200, 200, 200, 255);
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = SLColor(200, 200, 200, 255);
    UIView *line3 = [[UIView alloc]init];
    line3.backgroundColor = SLColor(200, 200, 200, 255);
    
    self.nameText = nameText;
    self.phoneText = phoneText;
    self.addressText = addressText;
    
    [self.view addSubview:nameLabel];
    [self.view addSubview:phoneLabel];
    [self.view addSubview:addressLabel];
    [self.view addSubview:nameText];
    [self.view addSubview:phoneText];
    [self.view addSubview:addressText];
    [self.view addSubview:saveBtn];
    
    [self.view addSubview:line1];
    [self.view addSubview:line2];
    [self.view addSubview:line3];
    
    nameLabel.sd_layout.leftSpaceToView(self.view, 10)
        .topSpaceToView(self.view, 10)
        .heightIs(40).widthIs(60);
    phoneLabel.sd_layout.leftEqualToView(nameLabel)
        .topSpaceToView(nameLabel, 10)
        .heightIs(40).widthIs(60);
    addressLabel.sd_layout.leftEqualToView(phoneLabel)
        .topSpaceToView(phoneLabel, 10)
        .heightIs(40).widthIs(60);
    nameText.sd_layout.leftSpaceToView(nameLabel, 10)
        .rightSpaceToView(self.view, 10)
        .topEqualToView(nameLabel)
        .bottomEqualToView(nameLabel);
    phoneText.sd_layout.leftEqualToView(nameText)
        .rightEqualToView(nameText)
        .topEqualToView(phoneLabel)
        .bottomEqualToView(phoneLabel);
    addressText.sd_layout.leftEqualToView(phoneText)
        .rightEqualToView(phoneText)
        .topEqualToView(addressLabel)
        .heightIs(80);
    
    saveBtn.sd_layout.leftEqualToView(addressLabel)
        .rightEqualToView(addressText)
        .topSpaceToView(addressText, 50)
        .heightIs(40);
    
    line1.sd_layout.leftEqualToView(nameLabel)
        .rightEqualToView(nameText)
        .topSpaceToView(nameText, 2)
        .heightIs(1);
    line2.sd_layout.leftEqualToView(nameLabel)
        .rightEqualToView(nameText)
        .topSpaceToView(phoneText, 2)
        .heightIs(1);
    line3.sd_layout.leftEqualToView(nameLabel)
        .rightEqualToView(nameText)
        .topSpaceToView(addressText, 2)
        .heightIs(1);
}

// 设置导航
- (void)initNavigation {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_back2" higImage:@"nav_back2" target:self  action:@selector(leftBtn:)];
}

- (void)leftBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

// 设置地址
- (void)setAddress:(SLAddressModel *)address {
    if (address) {
        _address = address;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    self.nameText.text = self.address.name;
    self.phoneText.text = self.address.phone;
    self.addressText.text = self.address.address;
}

// 保存
- (void)saveClick:(UIButton*)btn {
    // 保存地址
    [self saveAddress];
}

- (void)saveAddress {
    // 获取登陆用户
    SLUserModel *user = [SLUserModel achieveUser];
    if (!user) { // 未登录
        return;
    }
    
    NSString *name = self.nameText.text;
    NSString *phone = self.phoneText.text;
    NSString *address = self.addressText.text;
    
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
    parameters[@"memberCode"] = user.CardID;
    parameters[@"name"] = name;
    parameters[@"phone"] = phone;
    parameters[@"address"] = address;
    // 3.发送请求
    NSString *urlString = @"order/addressChange";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            [SVProgressHUD showInfoWithStatus:@"保存成功！"];
            // 返回购物车页面
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showInfoWithStatus:@"数据异常！"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

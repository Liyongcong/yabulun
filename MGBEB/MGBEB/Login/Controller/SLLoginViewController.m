//
//  SLLoginViewController.m
//  MGBEB
//
//  Created by SurgeLee on 2018/6/19.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLLoginViewController.h"

#import "SLHeader.h"
#import "UIButton+FillColor.h"

#import "SLTabBarController.h"

#import "SLUserModel.h"

#import "SLUserModel.h"

#import <Hyphenate/Hyphenate.h>


@interface SLLoginViewController ()

@property (nonatomic, weak) UITextField *userName;
@property (nonatomic, weak) UITextField *password;
@property (nonatomic, weak) UIButton *loginBtn;

@property (nonatomic, weak) UITextField *verifyCode; // 验证码Label
@property (nonatomic, weak) UIButton *verifyBtn; // 验证码按钮
@property (nonatomic, strong) SLUserModel *user; // 用户信息
@property (nonatomic, copy) NSString *code; // 记录验证码

@end

@implementation SLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化页面
    [self setupLoginView];
    
    // 解决键盘
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
}

- (void)setupLoginView{
    // 创建
    UITextField *userName = [[UITextField alloc] init];
    userName.font = SLFont13;
    //在文本框内设置提示文字
    userName.placeholder = @"会员号";
    //设置光标颜色
    userName.tintColor = SLColor(25, 93, 204, 255);
    userName.clearButtonMode =UITextFieldViewModeWhileEditing;
    
    UITextField *password = [[UITextField alloc] init];
    password.font = SLFont13;
    //在文本框内设置提示文字
    password.placeholder = @"密码";
    //设置光标颜色
    password.tintColor = SLColor(25, 93, 204, 255);
    password.clearButtonMode =UITextFieldViewModeWhileEditing;
    password.secureTextEntry = YES;
    
    // 验证码
    UITextField *verifyCode = [[UITextField alloc] init];
    verifyCode.font = SLFont13;
    //在文本框内设置提示文字
    verifyCode.placeholder = @"验证码";
    //设置光标颜色
    verifyCode.tintColor = SLColor(25, 93, 204, 255);
    verifyCode.clearButtonMode =UITextFieldViewModeWhileEditing;
    
    // 验证码获取
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [button setTitle:@"已发送" forState:UIControlStateSelected];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.titleLabel.font = SLFont13;
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [button.layer setBorderWidth:1.0]; // 边框宽度
    button.layer.borderColor = [UIColor grayColor].CGColor;
    [button addTarget:self action:@selector(verifyClick:) forControlEvents:UIControlEventTouchUpInside];
 
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn setTitle:@"会员登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:SLColor(28, 119, 215, 255) forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:10.0];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = SLColor(200, 200, 200, 255);
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = SLColor(200, 200, 200, 255);
    UIView *line3 = [[UIView alloc]init];
    line3.backgroundColor = SLColor(200, 200, 200, 255);

    [self.view addSubview:userName];
    [self.view addSubview:password];
    [self.view addSubview:loginBtn];
    [self.view addSubview:line1];
    [self.view addSubview:line2];
    [self.view addSubview:verifyCode];
    [self.view addSubview:button];
    [self.view addSubview:line3];
    
    self.userName = userName;
    self.password = password;
    self.loginBtn = loginBtn;
    self.verifyCode = verifyCode; // 验证码
    self.verifyBtn = button; // 验证码按钮
    
    userName.sd_layout.leftSpaceToView(self.view, 15)
        .rightSpaceToView(self.view, 15)
        .topSpaceToView(self.view, (kSLscreenH/7))
        .heightIs(40);
    password.sd_layout.leftEqualToView(userName)
        .rightEqualToView(userName)
        .topSpaceToView(userName, 30)
        .heightIs(40);
    
    line1.sd_layout.leftEqualToView(userName)
        .rightEqualToView(userName)
        .topSpaceToView(userName, 2)
        .heightIs(2);
    line2.sd_layout.leftEqualToView(password)
        .rightEqualToView(password)
        .topSpaceToView(password, 2)
        .heightIs(2);
    verifyCode.sd_layout.leftEqualToView(password)
        .rightSpaceToView(self.view, 150)
        .topSpaceToView(password, 30)
        .heightIs(50);
    button.sd_layout.rightSpaceToView(self.view, 15)
        .topSpaceToView(password, 40)
        .heightIs(30).widthIs(100);
    
    loginBtn.sd_layout.leftEqualToView(userName)
        .rightEqualToView(userName)
        .topSpaceToView(verifyCode, 50)
        .heightIs(50);
    
    line3.sd_layout.leftEqualToView(password)
        .rightEqualToView(password)
        .topSpaceToView(verifyCode, 0)
        .heightIs(2);
}

// 测试信息
- (void)loginClick2:(UIButton*)btn{
    [[[UIApplication sharedApplication] delegate] window].rootViewController = [[SLTabBarController alloc] init];
}

// 登陆操作2.0
- (void)loginClick:(UIButton*)btn{
    // 账号
    NSString *accountText = self.userName.text;
    // 密码
    NSString *passwordText = self.password.text;
    NSString *verifyCode = self.verifyCode.text;
    if([accountText length] <= 0){
        [SVProgressHUD showInfoWithStatus:@"会员号为空！"];
        return;
    } else if([passwordText length] <= 0){
        [SVProgressHUD showInfoWithStatus:@"密码为空！"];
        return;
    } else if([verifyCode length] <= 0){
        [SVProgressHUD showInfoWithStatus:@"验证码为空！"];
        return;
    }
    // 验证码匹配
    if ([verifyCode isEqualToString:self.code]) {
        // 1、数据归档
        [self.user saveUser];
        
        // 2、环信
        if (self.user.emUserName) {
            // 登陆环信
            [[EMClient sharedClient] loginWithUsername:self.user.emUserName password:self.user.emPassWord completion:^(NSString *aUsername, EMError *aError) {
                if (!aError) {
                    // 设置自动登录
                    [[EMClient sharedClient].options setIsAutoLogin:YES];
                }
            }];
        }
        
        // 跳转到页面
        [[[UIApplication sharedApplication] delegate] window].rootViewController = [[SLTabBarController alloc] init];
    } else {
        [SVProgressHUD showInfoWithStatus:@"验证码错误！"];
    }
}

// 登陆操作--废弃
//- (void)loginClick:(UIButton*)btn{
//    // 账号
//    NSString *accountText = self.userName.text;
//    // 密码
//    NSString *passwordText = self.password.text;
//
//    // 非空校验
//    if([accountText length] <= 0){
//        [SVProgressHUD showInfoWithStatus:@"会员号为空！"];
//        return;
//    }else if([passwordText length] <= 0){
//        [SVProgressHUD showInfoWithStatus:@"密码为空！"];
//        return;
//    }
//
//    // 1.创建请求管理者
//    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
//    // 2.封装请求参数
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    // 请求参数
//    parameters[@"MasterAccount"] = accountText;
//    parameters[@"PassWord"] = passwordText;
//    // 3.发送请求
//    NSString *urlString = @"other/getMemInfo";
//    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//
//        SLLog(@"登陆返回数据： %@", result);
//
//        if ([result[@"status"] integerValue] == 1){
//            // 提示信息
//            [SVProgressHUD showInfoWithStatus:@"登陆成功！"];
//            // 保存登陆信息
//            SLUserModel *user = [SLUserModel yy_modelWithJSON: result];
//            user.Password = passwordText;
//            // 数据归档
//            self.user = user; // 保存用户信息
////            [user saveUser];
//            // 跳转到页面
////            [[[UIApplication sharedApplication] delegate] window].rootViewController = [[SLTabBarController alloc] init];
//        } else {
//            NSString *retMsg = @"登陆失败，请联系商家！";
//            if ([result[@"msg"] isEqualToString:@"06"] || [result[@"msg"] isEqualToString:@"07"]) {
//                retMsg = @"会员卡号或密码错误！";
//            }
//            [SVProgressHUD showInfoWithStatus:retMsg];
//        }
//
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
//    }];
//
//}

// 验证码
- (void)verifyClick:(UIButton *)btn{

    // 账号
    NSString *accountText = self.userName.text;
    // 密码
    NSString *passwordText = self.password.text;
    
    // 非空校验
    if([accountText length] <= 0){
        [SVProgressHUD showInfoWithStatus:@"会员号为空！"];
        return;
    }else if([passwordText length] <= 0){
        [SVProgressHUD showInfoWithStatus:@"密码为空！"];
        return;
    }
    
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
    parameters[@"MasterAccount"] = accountText;
    parameters[@"PassWord"] = passwordText;
    // 3.发送请求
    NSString *urlString = @"other/getMemInfo";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"登陆返回数据： %@", result);
        
        if ([result[@"status"] integerValue] == 1){
            // 保存登陆信息
            SLUserModel *user = [SLUserModel yy_modelWithJSON: result];
            user.Password = passwordText;
            // 数据归档
            self.user = user; // 保存用户信息
            // 调取验证码接口
            [self loadVerify:user.Phone];
            // 验证码按钮
//            self.verifyBtn.enabled = NO;
//            [self.verifyBtn setTitle:@"已发送" forState:UIControlStateDisabled];
            [self openCountdown]; // 倒计时
        } else {
            NSString *retMsg = @"登陆失败，请联系商家！";
            if ([result[@"msg"] isEqualToString:@"06"] || [result[@"msg"] isEqualToString:@"07"]) {
                retMsg = @"会员卡号或密码错误！";
            }
            [SVProgressHUD showInfoWithStatus:retMsg];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

// 开启倒计时效果
-(void)openCountdown{
    SLLog(@"开始倒计时！");
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式 @"重新发送"
                self.verifyBtn.enabled = YES;
                [self.verifyBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            });
            
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果 @"重新发送(%.2d)"
//                self.authCodeBtn.userInteractionEnabled = NO;
                self.verifyBtn.enabled = NO;
                [self.verifyBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

// 加载验证码
- (void)loadVerify:(NSString*) phone{
    // 非空校验
    if([phone length] <= 0){
        [SVProgressHUD showInfoWithStatus:@"会员注册手机号码为空！"];
        return;
    }
    
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
    parameters[@"tel"] = phone; // 手机号
    // 3.发送请求
    NSString *urlString = @"sms/send";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            self.code = result[@"code"]; // 验证码
        } else {
            [SVProgressHUD showInfoWithStatus:@"获取失败！"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

#pragma mark -
#pragma mark 键盘

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

//
//  SLMessageController.m
//  MGBEB
//
//  Copyright © 2018 surge. All rights reserved.
//

#import "SLMessageController.h"

#import "UIBarButtonItem+Extension.h"
#import "SLHeader.h"
#import "SLUserModel.h"

@interface SLMessageController ()

@end

@implementation SLMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_back2" higImage:@"nav_back2" target:self action:@selector(leftBtn:)];
    
}

- (void)leftBtn:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 创建聊天列表
- (void)viewWillAppear:(BOOL)animated {
    // 获取登陆用户
    SLUserModel *user = [SLUserModel achieveUser];
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
    parameters[@"fromUser"] = user.CardID;
    parameters[@"toUser"] = self.toUser;
    // 3.发送请求
    NSString *urlString = @"char/listSave";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

// 重写发消息方法
- (void)didSendText:(NSString *)text
{
    [super didSendText:text];
    
    // 保存消息记录
    SLLog(@"保存消息至数据库");
    // 获取登陆用户
    SLUserModel *user = [SLUserModel achieveUser];
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
    parameters[@"fromUser"] = user.CardID;
    parameters[@"toUser"] = self.toUser;
    parameters[@"content"] = text;
    // 3.发送请求
    NSString *urlString = @"char/messageSave";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       
    }];
    
}

@end

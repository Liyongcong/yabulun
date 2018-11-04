//
//  SLMessageListController.m
//  MGBEB
//
//  Copyright © 2018 surge. All rights reserved.
//

#import "SLMessageListController.h"
#import "SLHeader.h"
#import "UIBarButtonItem+Extension.h"
#import "SLCharList.h"
#import "SLUserModel.h"
#import "SLMessageTableCell.h"

@interface SLMessageListController ()

@property (strong, nonatomic) NSMutableArray *charLists; //

@end

@implementation SLMessageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_back2" higImage:@"nav_back2" target:self action:@selector(leftBtn:)];
    
    // 去除分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 加载列表数据
    [self loadCharList];
}

- (void)leftBtn:(UIButton *)btn {
    SLLog(@"退出聊天列表");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadCharList {
    // 获取登陆用户
    SLUserModel *user = [SLUserModel achieveUser];
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
    parameters[@"user"] = user.CardID;
    // 3.发送请求
    NSString *urlString = @"char/queryCharLists";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            NSArray *list = [NSArray yy_modelArrayWithClass:[SLCharList class] json:result[@"list"]];
            
            // 保存数据
            self.charLists = [list mutableCopy];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.charLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SLLog(@"行数 %ld", indexPath.row);
    
    SLMessageTableCell *cell = [SLMessageTableCell cellWithTableView:tableView];
    cell.charLists = self.charLists[indexPath.row]; 
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = [UIColor redColor];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark -
#pragma mark 懒加载
- (NSMutableArray *)charLists {
    if (!_charLists) {
        _charLists = [NSMutableArray array];
    }
    return _charLists;
}

@end

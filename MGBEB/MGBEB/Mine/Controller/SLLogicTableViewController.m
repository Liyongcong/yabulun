//
//  SLLogicTableViewController.m
//  MGBEB
//
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLLogicTableViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "SLLogicTableCell.h"
#import "SLLogicTableCell2.h"
#import "SLLogisticsModel.h"
#import "SLlogicModel.h"
#import "SLHeader.h"
#import "SLUserModel.h"

@interface SLLogicTableViewController ()

@property (strong, nonatomic) UILabel *waybillLabel; // 运单号
@property (strong, nonatomic) UILabel *someLabel; // 承运人
@property (strong, nonatomic) UILabel *phoneLabel; // 电话

@property (strong, nonatomic) SLlogicModel *info; // 物流运单信息
@property (strong, nonatomic) NSMutableArray *logis; // 物流明细

@end

@implementation SLLogicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
//    SLLog(@"订单id=%ld", self.orderId);
    self.title = @"物流信息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = SLColor(221,226,233, 255);
    // 去除分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 初始化导航
    [self initNavigation];
    // 初始化头部视图
    [self headerView];
    // 加载物流数据
    [self loadLogis: self.orderId];
}

// 设置导航
- (void)initNavigation {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_back2" higImage:@"nav_back2" target:self  action:@selector(leftBtn:)];
}
- (void)leftBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

// 初始化头视图
- (void)headerView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kSLscreenW - 20, 60)];
    view.backgroundColor = SLColor(221,226,233, 255);
    UIView *headBackView = [[UIView alloc] initWithFrame:CGRectMake(12, 10, kSLscreenW - 24, 60)];
    headBackView.backgroundColor = [UIColor whiteColor];
    [headBackView.layer setMasksToBounds:YES];
    headBackView.layer.cornerRadius = 8.0;
    [view addSubview:headBackView];
    
    // 图标
    UIImageView *numImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number_icon"]];
    numImage.contentMode = UIViewContentModeScaleAspectFill;
    UIImageView *someImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"some_icon"]];
    someImage.contentMode = UIViewContentModeScaleAspectFill;
    UIImageView *phoneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone_icon"]];
    phoneImage.contentMode = UIViewContentModeScaleAspectFill;
    
    numImage.frame = CGRectMake(24, 18, 12, 12);
    someImage.frame = CGRectMake(numImage.x, numImage.y + numImage.height + 15, numImage.width, numImage.height);
    phoneImage.frame = CGRectMake(numImage.x, someImage.y + someImage.height + 15, numImage.width, numImage.height);
    
    // 文字描述
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(numImage.x + numImage.width + 7 , numImage.y, 80, 13)];
    numLabel.attributedText = [SLStringUtil stringWithString:@"运   单   号：" font:[UIFont systemFontOfSize: 13] color:SLColor(42, 42, 42, 255)];
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(numLabel.x, numLabel.y + numLabel.height + 15, 80, numLabel.height)];
    unitLabel.attributedText = [SLStringUtil stringWithString:@"国内承运人：" font:[UIFont systemFontOfSize: 13] color:SLColor(42, 42, 42, 255)];
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(numLabel.x, unitLabel.y + unitLabel.height + 15, 80, numLabel.height)];
    telLabel.attributedText = [SLStringUtil stringWithString:@"承运人电话：" font:[UIFont systemFontOfSize: 13] color:SLColor(42, 42, 42, 255)];
    
    // 运单号 + 承运人 + 电话
    UILabel *waybillLabel = [[UILabel alloc] initWithFrame:CGRectMake(numLabel.x + numLabel.width + 5, numLabel.y, kSLscreenW - numLabel.width - 30, numLabel.height)];
//    waybillLabel.font = SLCellFont;
    UILabel *someLabel = [[UILabel alloc] initWithFrame:CGRectMake(unitLabel.x + unitLabel.width + 5, unitLabel.y, kSLscreenW - unitLabel.width - 30, numLabel.height)];
//    someLabel.font = SLCellFont;
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(telLabel.x + telLabel.width + 5, telLabel.y, kSLscreenW - telLabel.width - 30, numLabel.height)];
//    phoneLabel.font = SLCellFont;
    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, telLabel.y + telLabel.height + 10, kSLscreenW, 10)];
//    line.backgroundColor = [UIColor lightGrayColor];
    
    self.waybillLabel = waybillLabel;
    self.someLabel = someLabel;
    self.phoneLabel = phoneLabel;
    
    [headBackView addSubview:numImage];
    [headBackView addSubview:someImage];
    [headBackView addSubview:phoneImage];
    [headBackView addSubview:numLabel];
    [headBackView addSubview:unitLabel];
    [headBackView addSubview:telLabel];
    [headBackView addSubview:waybillLabel];
    [headBackView addSubview:someLabel];
    [headBackView addSubview:phoneLabel];
//    [view addSubview:line];
    
    headBackView.height = telLabel.y + telLabel.height + 20;
    view.height = headBackView.height + 20;
    
    self.tableView.tableHeaderView = view;
}

// 加载物流数据
- (void)loadLogis:(NSInteger)orderId {
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
    parameters[@"orderId"] = [NSString stringWithFormat:@"%ld", orderId]; // 订单id @"68"
    // 3.发送请求
    NSString *urlString = @"logistics/findByOrder";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            // 获取数据
            SLlogicModel *info = [SLlogicModel yy_modelWithJSON:result[@"info"]];
            
            if (info == nil) {
                [SVProgressHUD showInfoWithStatus:@"暂无物流信息！"];
            } else {
                NSArray *list = [NSArray yy_modelArrayWithClass:[SLLogisticsModel class] json:result[@"list"]];
                
                // 保存数据
                self.info = info;
                self.logis = [list mutableCopy];
            }

            [self.tableView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:@"数据异常！"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    SLLog(@"数量 %ld", self.logis.count);
    return self.logis.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SLLog(@"行数 %ld", indexPath.row);
    
    // 获得cell
    if (indexPath.row + 1 == self.logis.count) {
        SLLogicTableCell *cell = [SLLogicTableCell cellWithTableView:tableView];
        cell.logis = self.logis[indexPath.row]; // 设置物流明细
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        SLLogicTableCell2 *cell = [SLLogicTableCell2 cellWithTableView:tableView];
        cell.logis = self.logis[indexPath.row]; // 设置物流明细
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLLogicTableCell *cell = (SLLogicTableCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

#pragma mark -
#pragma mark 懒加载
- (NSMutableArray *)logis{
    if (!_logis) {
        _logis = [NSMutableArray array];
    }
    return _logis;
}

// set方法
- (void)setInfo:(SLlogicModel *)info {
//    self.waybillLabel.text = info.waybillNo;
//    self.someLabel.text = info.transportUnit;
//    self.phoneLabel.text = info.phone;
    self.waybillLabel.attributedText = [SLStringUtil stringWithString:info.waybillNo font:[UIFont systemFontOfSize: 13] color:SLColor(42, 42, 42, 255)];
    self.someLabel.attributedText = [SLStringUtil stringWithString:info.transportUnit font:[UIFont systemFontOfSize: 13] color:SLColor(42, 42, 42, 255)];
    self.phoneLabel.attributedText = [SLStringUtil stringWithString:info.phone font:[UIFont systemFontOfSize: 13] color:SLColor(42, 42, 42, 255)];
}

@end

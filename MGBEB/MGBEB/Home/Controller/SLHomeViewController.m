//
//  SLHomeViewController.m
//  MGBEB
//
//  Created by SurgeLee on 2018/6/19.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLHomeViewController.h"

#import "SLHeader.h"
#import "UIBarButtonItem+Extension.h"

#import "SLSearchBar2.h"
#import "SLClassifyView.h"
#import "SLHomeActivityCell.h"
#import "SLLoginViewController.h"
#import "SLMemViewController.h"

#import "SLTabBarController.h"
#import "SLTypeModel.h"

#import "SLGoodsListViewController.h"

@interface SLHomeViewController ()<SLSearchBarDelegate, SLClassifyViewDelegate>

// 类型列表
@property (nonatomic, strong) NSMutableArray *types;

@property (nonatomic, strong) SLClassifyView *classifyView; // 类别视图

@property (nonatomic, strong) UIButton *killView; // 秒杀视图
@property (nonatomic, strong) UIButton *noticeView; // 首页公告视图

@end

@implementation SLHomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // 设置导航
    [self setuptNavView];
    // 设置头部视图
    [self setupHeaderView];
    // 设置背景
//    self.tableView.backgroundColor = [SLColor(239, 240, 244, 255)];
    // 设置提醒数
    
    // 初始化数据
    [self initData];
}

- (void)setuptNavView {
    // 创建搜索框对象
    SLSearchBar2 *searchBar = [SLSearchBar2 searchBar];
    searchBar.width = kSLscreenW - 120;
    searchBar.height = 30;
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    
    // 设置logo等
    //    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_logo"]];
    //    UIButton *imgView = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [imgView setImage:[UIImage imageNamed:@"app_logo"] forState:UIControlStateNormal];
    //    imgView.size = CGSizeMake(50, 20);
    //    imgView.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    //    // 设置偏移量
    //    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    negativeSpacer.width = +20;  //偏移距离  -向左偏移, +向右偏移
    //    self.navigationItem.leftBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:imgView]];
    
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imgView];
    
    // 右侧
    //    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"mine_info" higImage:@"mine_info" target:self action:@selector(rightClick:)];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = +10;  //偏移距离  -向左偏移, +向右偏移
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setImage:[UIImage imageNamed:@"mine_info"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    right.size = CGSizeMake(10, 10);
    right.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:right]];
}

// 设置头布置图
- (void)setupHeaderView{
    // 1.创建视图
    // 头视图
    UIView *view =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 27)];
//    view.backgroundColor = SLColor(240,241,245, 255);
    
    // 类别背景
    UIView *classBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 187)];
    classBackView.backgroundColor = SLColor(221,226,233, 255);
    [view addSubview: classBackView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 7, self.view.width - 6, 183)];
    imgView.image = [UIImage imageNamed:@"head_back"];
    imgView.userInteractionEnabled = YES;
    [classBackView addSubview: imgView];

    // 类别视图
    SLClassifyView *classifyView = [[SLClassifyView alloc] init];
    classifyView.types = self.types;
    [classifyView setBackgroundColor:[UIColor whiteColor]];
    self.classifyView = classifyView;
    classifyView.delegate = self;
    
    // 秒杀视图
    UIButton *killView = [UIButton buttonWithType:UIButtonTypeCustom];
    [killView.layer setMasksToBounds:YES];
    killView.layer.cornerRadius = 5.0;
//    [killView sd_setBackgroundImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"kill_defult"]];
    self.killView = killView;
    
    // 公告
    UIButton *noticeView = [UIButton buttonWithType:UIButtonTypeCustom];
    [noticeView.layer setMasksToBounds:YES];
    noticeView.layer.cornerRadius = 5.0;
    self.noticeView = noticeView;
    
    // 2.添加到容器
    [imgView addSubview:classifyView];
    [view addSubview:killView];
    [view addSubview:noticeView];
    
    // 3.设置布局
    // 类别
    classifyView.sd_layout.leftSpaceToView(imgView, 8)
        .rightSpaceToView(imgView, 8)
        .topSpaceToView(imgView, 0)
        .heightIs(160);
    // 秒杀
    noticeView.sd_layout.leftSpaceToView(view, 8)
        .rightSpaceToView(view, 8)
        .topSpaceToView(classBackView, 10)
        .heightIs(137);
    killView.sd_layout.leftSpaceToView(view, 8)
        .rightSpaceToView(view, 8)
        .topSpaceToView(noticeView, 10)
        .heightIs(137);
    
    // 计算父视图高度
    view.height = 480;//classifyView.height + noticeView.height + killView.height + 20;
    self.tableView.tableHeaderView = view;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.types.count - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 获得cell
    SLHomeActivityCell *cell = [SLHomeActivityCell cellWithTableView:tableView];

    cell.activity = self.types[indexPath.row + 1];
//    cell.activity = [[SLActivityModel alloc] init];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    SLActivityModel *model = self.types[indexPath.row + 1];
    
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"activity" cellClass:[SLHomeActivityCell class] contentViewWidth:kSLscreenW];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //TODO 首页或不跳转
    
    // 首页列表
    SLGoodsListViewController *vc = [[SLGoodsListViewController alloc] init];
    vc.indexId = [NSString stringWithFormat:@"%ld", indexPath.row + 2];
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    SLTypeModel *type = self.types[indexPath.row + 1];
    vc.title = type.typeName;
    [self presentViewController:navVc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
//    //修改导航栏文字字体和颜色
//    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[RGBColor colorWithHexString:@"#4b95f2"],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
//    //修改导航栏颜色
//    [[UINavigationBar appearance]setBarTintColor:[RGBColor colorWithHexString:@"#00E5EE"]];
    
//    // 设置标题栏颜色（失败）
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    bar.translucent = NO;
//    bar.barTintColor = SLColor(28, 119, 215, 255);
//    
//    // 字体颜色
//    bar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]
//                                , NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
}

#pragma mark -
#pragma mark 导航按钮
- (void)rightClick:(UIButton *)btn{
    
//    SLLoginViewController *vc = [[SLLoginViewController alloc] init];
    SLMemViewController *vc = [[SLMemViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVc animated:YES completion:^{}];
}

- (void)initData{
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
//    parameters[@""] = @"";
    // 3.发送请求
    NSString *urlString = @"home/indexSettings";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            // 获取数据
            NSArray *list = [NSArray yy_modelArrayWithClass:[SLTypeModel class] json:result[@"list"]];
            // 保存数据
            [self.types addObjectsFromArray:list];
            [self.classifyView addTypeBtn:list]; // 设置类别
            [self settingNotice:list.lastObject]; // 首页公告
            [self settingKill:list.firstObject]; // 设置秒杀
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:@"数据异常！"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

- (void)settingKill:(SLTypeModel*)model{
    [self.killView sd_setBackgroundImageWithURL:[NSURL URLWithString:model.imgUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"kill_defult"]]; // 设置秒杀
    [self.killView addTarget:self action:@selector(killBtnClick:type:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)settingNotice:(SLTypeModel*)model{
    [self.noticeView sd_setBackgroundImageWithURL:[NSURL URLWithString:model.imgUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"activity_defult"]]; // 设置首页公告
}

// 秒杀点击
- (void)killBtnClick:(UIButton*)btn type:(SLTypeModel*)model{
    SLLog(@"点击秒杀");
    
    SLGoodsListViewController *vc = [[SLGoodsListViewController alloc] init];
    vc.secKill = @"1";
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.title = @"秒杀";
    [self presentViewController:navVc animated:YES completion:nil];
}

#pragma mark -
#pragma mark SLSearchBarDelegate
- (void)searchBtnClick:(UIButton*)sender searchField:(NSString*)searchField{
    SLLog(@"点击搜索");
//    SLGoodsListViewController *vc = [[SLGoodsListViewController alloc] init];
//    vc.name = searchField;
//    [self.navigationController pushViewController:vc animated:YES];
    
    SLGoodsListViewController *vc = [[SLGoodsListViewController alloc] init];
    vc.productName = searchField;
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.title = searchField;
    [self presentViewController:navVc animated:YES completion:nil];    
}

#pragma mark -
#pragma mark SLClassifyViewDelegate
- (void)calssifyView:(SLClassifyView *)calssifyView selectedBtnFrom:(NSInteger)from to:(NSInteger)to {
    SLLog(@"%ld", (long)to);
    
    SLGoodsListViewController *vc = [[SLGoodsListViewController alloc] init];
    vc.indexId = [NSString stringWithFormat:@"%ld", (long)to];
//    [self.navigationController pushViewController:vc animated:YES];
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    SLTypeModel *type = self.types[to-1];
    vc.title = type.typeName;
    [self presentViewController:navVc animated:YES completion:nil];
}

#pragma mark - 懒加载
- (NSMutableArray *)types
{
    if (!_types) {
        _types = [NSMutableArray array];
    }
    return _types;
}

@end

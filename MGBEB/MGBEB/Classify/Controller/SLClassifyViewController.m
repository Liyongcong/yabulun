//
//  SLClassifyViewController.m
//  MGBEB
//
//  Created by SurgeLee on 2018/6/19.
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLClassifyViewController.h"

#import "SLHeader.h"

#import "SLProductTypeModel.h"
#import "SLLeftTableCell.h"
#import "SLRightCollectionCell.h"

#import "SLGoodsListViewController.h"

#import "SLSearchBar2.h"

@interface SLClassifyViewController ()<UITableViewDataSource,  UITableViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SLSearchBarDelegate>

// 左边列表
@property (strong, nonatomic) UITableView *myTableView;
// 右边列表
@property (strong, nonatomic) UICollectionView *myCollectionView;

//左边列表的数据源
@property (nonatomic, strong) NSMutableArray *leftDataList;
//右边列表的过滤数据源
@property(nonatomic, strong)NSMutableArray *rightDataList;

//当前被选中的ID值
@property(strong, nonatomic)SLProductTypeModel *curSelectModel;

//是否保持右边滚动时位置
@property(assign, nonatomic) BOOL isKeepScrollState;
@property(assign, nonatomic) BOOL isReturnLastOffset;
@property(assign,nonatomic) NSInteger selectIndex;

@end

//表格的宽度
static CGFloat tableWidthSize = 80;
//行的高度
static const CGFloat tableCellHeight = 44;
//表格跟集合列表的空隙
static const CGFloat leftMargin = 0;

@implementation SLClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 解决键盘
//    self.view.userInteractionEnabled = YES;
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
//    [self.view addGestureRecognizer:singleTap];
    
    // 赋值全局变量
    tableWidthSize = kSLscreenW / 4;
    
    //1、初始化
    self.view.backgroundColor=[UIColor whiteColor];
    self.isReturnLastOffset=YES;
    //是否允许右位保持滚动位置
    self.isKeepScrollState=YES;
    
    // 加载左侧数据
    [self leftDataSoure];
    
    // 2、创建列表
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, tableWidthSize, kSLscreenH) style: UITableViewStylePlain];
        _myTableView.backgroundColor = SLColor(238, 238, 238, 255);
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.tableFooterView = [[UIView alloc] init];
        _myTableView.separatorColor = [UIColor whiteColor];
        [_myTableView registerClass: [SLLeftTableCell class] forCellReuseIdentifier: NSStringFromClass([SLLeftTableCell class])];
        
        if ([self.myTableView respondsToSelector: @selector(setLayoutMargins:)]) {
            self.myTableView.layoutMargins = UIEdgeInsetsZero;
        }
        if ([self.myTableView respondsToSelector: @selector(setSeparatorInset:)]) {
            self.myTableView.separatorInset = UIEdgeInsetsZero;
        }
        [self.view addSubview:_myTableView];
    }
    
    // 3、创建集合表格
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        self.myCollectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(tableWidthSize + leftMargin, 0, kSLscreenW -  tableWidthSize - 2 * leftMargin, kSLscreenH) collectionViewLayout: layout];
        self.myCollectionView.backgroundColor = [UIColor whiteColor];
        self.myCollectionView.showsHorizontalScrollIndicator = NO;
        self.myCollectionView.showsVerticalScrollIndicator = NO;
        [self.myCollectionView registerClass:[SLRightCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([SLRightCollectionCell class])];
        self.myCollectionView.dataSource = self;
        self.myCollectionView.delegate = self;
        [self.view addSubview:self.myCollectionView];
    }
    
    // 4、加载数据
//    for (int i=0; i<10; i++) {
//        SLProductTypeModel *left = [[SLProductTypeModel alloc] init];
//        left.typeName = [NSString stringWithFormat:@"分类%d", i];
//        left.idstr = [NSString stringWithFormat:@"%d", i];
//        [self.leftDataList addObject: left];
//
//        SLProductTypeModel *right = [[SLProductTypeModel alloc] init];
//        right.idstr = [NSString stringWithFormat:@"%d", i*100];
//        right.typeName = [NSString stringWithFormat:@"商品%d", i];
//        right.parendId = 0;
//        [self.rightDataList addObject: right];
//    }
    
    // 5、设置选中
    self.selectIndex=0;
    
    // 设置导航
    [self setuptNavView];
    
}

- (void)setuptNavView {
    // 创建搜索框对象
    SLSearchBar2 *searchBar = [SLSearchBar2 searchBar];
    searchBar.width = kSLscreenW - 30;
    searchBar.height = 30;
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
}

- (void)leftDataSoure {
    
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
    
    // 3.发送请求
    NSString *urlString = @"product/productType";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            // 获取数据
            NSArray *list = [NSArray yy_modelArrayWithClass:[SLProductTypeModel class] json:result[@"list"]];
            // 保存数据
            self.leftDataList = [list mutableCopy];
            // 刷新表格
            [self.myTableView reloadData];
            
            // 设置默认选择第一个
            if (self.leftDataList.count > 0) {
                self.curSelectModel = [self.leftDataList objectAtIndex:self.selectIndex];
                [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection: 0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                [self.myTableView reloadData];
                //右边数据加载
                SLProductTypeModel *pt = self.leftDataList[0];
                [self rightDataSoure: pt.idstr];
            }
            
        } else {
            [SVProgressHUD showInfoWithStatus:@"数据异常！"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

- (void)rightDataSoure: (NSString *)parendId{
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
    parameters[@"parendId"] = parendId;
    // 3.发送请求
    NSString *urlString = @"product/productType";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据2： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            // 获取数据
            NSArray *list = [NSArray yy_modelArrayWithClass:[SLProductTypeModel class] json:result[@"list"]];
            // 保存数据
            self.rightDataList = [list mutableCopy];
            // 刷新表格
            [self.myCollectionView reloadData];
            
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.leftDataList.count;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
//    SLLeftTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SLLeftTableCell class]) forIndexPath:indexPath];
    SLLeftTableCell *cell = [SLLeftTableCell cellWithTableView:tableView];
    
    cell.productTypeModel = [self.leftDataList objectAtIndex:indexPath.section];
    // 是否是当前选中的
    cell.hasBeenSelected = (cell.productTypeModel == self.curSelectModel);
    
    //修改表格行默认分隔线存空隙的问题
    if ([cell respondsToSelector: @selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector: @selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectIndex = indexPath.section;
    self.curSelectModel = [self.leftDataList objectAtIndex:indexPath.section];
    [self.myTableView reloadData];
    // 谓词处理
//    [self predicateDataSoure];
    //处理点击在滚动置顶的问题
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    // 设置右侧数据
    [self rightDataSoure:self.curSelectModel.idstr];
    
    self.isReturnLastOffset = NO;
    if (self.isKeepScrollState) {
        [self.myCollectionView scrollRectToVisible:CGRectMake(0, self.curSelectModel.offsetScorller, self.myCollectionView.frame.size.width, self.myCollectionView.frame.size.height) animated:NO];
    } else {
        [self.myCollectionView scrollRectToVisible:CGRectMake(0, 0, self.myCollectionView.frame.size.width, self.myCollectionView.frame.size.height) animated:NO];
    }
}

#pragma mark -
#pragma mark UICollectionViewDataSource, UICollectionViewDelegate
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    SLRightCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SLRightCollectionCell class]) forIndexPath:indexPath];
    
    SLProductTypeModel *model = [self.rightDataList objectAtIndex:indexPath.row];
    cell.productTypeModel = model;
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.rightDataList.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SLProductTypeModel *model = [self.rightDataList objectAtIndex:indexPath.row];
    SLLog(@"你选择了%@", model.typeName);
    
    // 跳转到商品列表
    SLGoodsListViewController *goodsVc = [[SLGoodsListViewController alloc] init];
    goodsVc.typeId = model.idstr; // 设置商品类型ID
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:goodsVc];
    
    goodsVc.title = model.typeName;
    
    [self presentViewController:navVc animated:YES completion:^{
        
    }];
    
}

#pragma mark -
#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [SLRightCollectionCell cellSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

#pragma mark -UIScrollViewDelegate
#pragma mark 记录滑动的坐标(把右边滚动的Y值记录在列表的一个属性中)

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.myCollectionView]) {
        self.isReturnLastOffset=YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if ([scrollView isEqual:self.myCollectionView]) {
        SLProductTypeModel * item = self.leftDataList[self.selectIndex];
        item.offsetScorller = scrollView.contentOffset.y;
        self.isReturnLastOffset = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.myCollectionView]) {
        SLProductTypeModel * item = self.leftDataList[self.selectIndex];
        item.offsetScorller = scrollView.contentOffset.y;
        self.isReturnLastOffset = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.myCollectionView] && self.isReturnLastOffset) {
        SLProductTypeModel * item = self.leftDataList[self.selectIndex];
        item.offsetScorller = scrollView.contentOffset.y;
    }
}

#pragma mark -
#pragma mark SLSearchBarDelegate
- (void)searchBtnClick:(UIButton*)sender searchField:(NSString*)searchField{
    SLLog(@"点击搜索");
    
    SLGoodsListViewController *vc = [[SLGoodsListViewController alloc] init];
    vc.productName = searchField;
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.title = searchField;
    [self presentViewController:navVc animated:YES completion:nil];
}

#pragma mark -
#pragma mark 懒加载
- (NSMutableArray *)leftDataList
{
    if (!_leftDataList) {
        _leftDataList = [NSMutableArray array];
    }
    return _leftDataList;
}

- (NSMutableArray *)rightDataList
{
    if (!_rightDataList) {
        _rightDataList = [NSMutableArray array];
    }
    return _rightDataList;
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

@end

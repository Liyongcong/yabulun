//
//  EvaluViewController.m
//  MGBEB
//
//  Copyright © 2018年 surge. All rights reserved.
//

#import "SLEvaluViewController.h"

#import "UIBarButtonItem+Extension.h"
#import "SLHeader.h"
#import "SLTextView.h"
#import "SLUserModel.h"

@interface SLEvaluViewController ()

@property (strong, nonatomic) SLTextView *textView; // 评价内容
@property (nonatomic, assign) NSInteger star; // 星级

@property (strong, nonatomic) UIView *topView; // 存放按钮的顶部视图

@end

@implementation SLEvaluViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"商品评价";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.star = 5;
    // 初始化导航
    [self initNavigation];
    // 初始化页面
    [self setupView];
}

// 设置导航
- (void)initNavigation {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_back2" higImage:@"nav_back2" target:self  action:@selector(leftBtn:)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtn:)];
    [rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16], NSFontAttributeName, [UIColor redColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)leftBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtn:(UIButton *)btn {
    [self sendEval];
}

// 初始化页面
- (void)setupView{
    
    // 顶部视图
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSLscreenH, 130)];
    self.topView = topView;
    
    // 商品信息
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:_detailImg] placeholderImage:[UIImage imageNamed:@"activity_defult"]];
    
    [topView addSubview: imgView];
    
    // 星级
    UILabel *title = [[UILabel alloc] init];
    title.font = SLFont13;
    title.text = @"商品评分";
    title.frame = CGRectMake(120, 30, kSLscreenW - 150, 20);
    [topView addSubview: title];
    
    for (int i=1; i<=5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.adjustsImageWhenHighlighted = NO;
        
        CGFloat childW = 20;
        CGFloat childH = 20;
        CGFloat childX = (i - 1) * (childW + 5) + 120;
        CGFloat childY = title.y + 30;
        
        [btn setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"star_sel"] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"star_sel"] forState:UIControlStateSelected];
        
        btn.tag = i;
        btn.selected = YES;
        btn.frame = CGRectMake(childX, childY, childW, childH);
        
        [btn addTarget:self action:@selector(starBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [topView addSubview: btn];
    }

    // 评论
    SLTextView *textView = [[SLTextView alloc] initWithFrame:CGRectMake(0, 120, kSLscreenW, 150)];
    textView.backgroundColor = SLColor(225, 225, 225, 225);
    textView.placeholder = @"请评论...";
    self.textView = textView;
    textView.font = SLFont13;
    
    // 添加到视图
    [self.view addSubview:topView];
    [self.view addSubview:textView];
}

// 星级评价
- (void)starBtnClick:(UIButton *)btn{
    
    SLLog(@"子控件%@", self.topView.subviews);
    
    for (int i = 0; i < self.topView.subviews.count; ++i) {
        if ([self.topView.subviews[i] isKindOfClass:[UIButton class]]) {
            
            UIButton *button = self.topView.subviews[i];
            if (button.tag <= btn.tag) {
                button.selected = YES;
            } else {
                button.selected = NO;
            }
            
        }
    }
    
    // 设置星级
    self.star = btn.tag;
}


- (void)sendEval{
    // 获取登陆用户
    SLUserModel *user = [SLUserModel achieveUser];
    if (!user) { // 未登录
        [SVProgressHUD showInfoWithStatus:@"用户信息失效，请重新登陆！"];
        return;
    }
    // 1.创建请求管理者
    SLNetWorkTools *tools = [SLNetWorkTools shareNetworkTools];
    // 2.封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 请求参数
    // productId=92&memberCode=1888&evaluationContent=习惯好评&evaluationStar=5
    parameters[@"productId"] = [NSString stringWithFormat:@"%ld", self.productId];
    parameters[@"memberCode"] = user.CardID;
    parameters[@"evaluationContent"] = self.textView.text;
    parameters[@"evaluationStar"] = [NSString stringWithFormat:@"%ld", self.star];
    
    SLLog(@"请求参数： %@", parameters);
    // 3.发送请求
    NSString *urlString = @"evaluation/create";
    [tools POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        SLLog(@"返回数据： %@", result);
        
        if ([result[@"return_code"] isEqualToString:@"SUCCESS"]){
            [SVProgressHUD showInfoWithStatus:@"评论成功！"];
        } else {
            [SVProgressHUD showInfoWithStatus:@"评论失败！"];
        }
        
        // 退出页面
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"操作失败！"];
    }];
}

@end

//
//  SPBManageHomeVC.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SPBManageHomeVC.h"
#import "JXCategoryView.h"
#import "UIWindow+JXSafeArea.h"
#import "JXCategoryListContainerView.h"
#import "SubManagerDetailVC.h"
#import "ReportFaultVC.h"

#define WindowsSize [UIScreen mainScreen].bounds.size

@interface SPBManageHomeVC ()<UINavigationControllerDelegate,JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSArray <NSString *> *titles;

@end

@implementation SPBManageHomeVC

#pragma mark ****************************** life cycle          ******************************
-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.delegate = self;
//    self.view.backgroundColor = [UIColor RandomColor];
    self.view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    CGFloat naviHeight = [UIApplication.sharedApplication.keyWindow jx_navigationHeight];
    [self setSubViewsProperty];
    
    self.titles = [self getRandomTitles];
    CGFloat categoryViewHeight = 50;
    CGFloat width = WindowsSize.width;
    CGFloat height = WindowsSize.height - naviHeight - categoryViewHeight;
    
    self.categoryView = [[JXCategoryTitleView alloc] init];
    self.categoryView.frame = CGRectMake(0, kStatusBarHeight+35, WindowsSize.width, categoryViewHeight);
    self.categoryView.titleColor =[UIColor colorWithHexString:@"333333"];
    self.categoryView.titleSelectedColor =[UIColor colorWithHexString:@"148aff"];
    self.categoryView.delegate = self;
    self.categoryView.titles = self.titles;
    self.categoryView.defaultSelectedIndex = 0;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = [UIColor colorWithHexString:@"148aff"];
    lineView.indicatorLineWidth = 100;
    self.categoryView.indicators = @[lineView];
    [self.view addSubview:self.categoryView];
    
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithParentVC:self delegate:self];
    self.listContainerView.frame = CGRectMake(0, categoryViewHeight+kStatusBarHeight+35, width, height);
    self.listContainerView.defaultSelectedIndex = 0;
    [self.view addSubview:self.listContainerView];
    
    self.categoryView.contentScrollView = self.listContainerView.scrollView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([SysPubSingleThings sharePublicSingle].isChangeLogin) {
        //重新更新网络数据
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark ****************************** System Delegate     ******************************

#pragma mark ****************************** Custom Delegate     ******************************
#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
//    LoadDataListContainerListViewController *listVC = [[LoadDataListContainerListViewController alloc] init];
//    listVC.naviController = self.navigationController;
//    return listVC;
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self.naviController presentViewController:navi animated:true completion:nil];
    SubManagerDetailVC *newVC = [[SubManagerDetailVC alloc] init];
    newVC.currentInt = index;
    newVC.naviController = self.navigationController;
    return newVC;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

#pragma mark ****************************** event   Response    ******************************

#pragma mark ****************************** private Methods     ******************************
- (NSArray <NSString *> *)getRandomTitles {
//    NSMutableArray *titles = @[@"红烧螃蟹", @"麻辣龙虾", @"美味苹果", @"胡萝卜", @"清甜葡萄", @"美味西瓜", @"美味香蕉", @"香甜菠萝", @"麻辣干锅", @"剁椒鱼头", @"鸳鸯火锅"].mutableCopy;
//    NSInteger randomMaxCount = arc4random()%6 + 5;
//    NSMutableArray *resultArray = [NSMutableArray array];
//    for (int i = 0; i < randomMaxCount; i++) {
//        NSInteger randomIndex = arc4random()%titles.count;
//        [resultArray addObject:titles[randomIndex]];
//        [titles removeObjectAtIndex:randomIndex];
//    }
//    return resultArray;
    NSMutableArray *titles = @[@"我上报的", @"待处理", @"已处理"].mutableCopy;
    return titles;
}
/**
 重载数据源：比如从服务器获取新的数据、否则用户对分类进行了排序等
 */

- (void)reloadData {
    self.titles = [self getRandomTitles];
    
    //重载之后默认回到0，你也可以指定一个index
    self.categoryView.defaultSelectedIndex = 0;
    self.categoryView.titles = self.titles;
    [self.categoryView reloadData];
    
    self.listContainerView.defaultSelectedIndex = 0;
    [self.listContainerView reloadData];
}
-(void)reportBtClick{
    ReportFaultVC *reportVC = [[ReportFaultVC alloc]init];
    [self.navigationController pushViewController:reportVC animated:YES];
}
#pragma mark ****************************** HTTP Server         ******************************

#pragma mark ****************************** getter and setter   ******************************
- (void)setSubViewsProperty {
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, kStatusBarHeight+10, 80, 30)];
    nameLabel.backgroundColor= [UIColor clearColor];
    nameLabel.font = [UIFont systemFontOfSize:17.f];
    nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    nameLabel.text = @"安全管理";
    [self.view addSubview:nameLabel];
    
    UIButton *reportBt = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, kStatusBarHeight+10, 83, 30)];
    reportBt.backgroundColor = [UIColor colorWithHexString:@"148aff"];
    [reportBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reportBt setTitle:@"上报隐患" forState:UIControlStateNormal];
    [reportBt addTarget:self action:@selector(reportBtClick) forControlEvents:UIControlEventTouchUpInside];
    reportBt.titleLabel.font = [UIFont systemFontOfSize:15.f];
    reportBt.layer.cornerRadius = 6.f;
    [self.view addSubview:reportBt];
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:NO];
}

- (void)dealloc {
    self.navigationController.delegate = nil;
}
@end

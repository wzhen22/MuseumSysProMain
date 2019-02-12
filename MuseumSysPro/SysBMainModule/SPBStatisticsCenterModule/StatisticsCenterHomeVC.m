//
//  StatisticsCenterHomeVC.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/28.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "StatisticsCenterHomeVC.h"
#import "JXCategoryView.h"
#import "UIWindow+JXSafeArea.h"
#import "JXCategoryListContainerView.h"
#import "StatisticsDetailVC.h"
#import "SPBLoginVC.h"

@interface StatisticsCenterHomeVC ()<UINavigationControllerDelegate,JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>{
    BOOL isFirstOpen;
}

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSArray <NSString *> *titles;

@end

@implementation StatisticsCenterHomeVC

#pragma mark ****************************** life cycle          ******************************
-(void)viewDidLoad{
    [super viewDidLoad];
    isFirstOpen = YES;
    self.navigationController.delegate = self;
//    [self setSubViewsProperty];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    if ([SysPubSingleThings getLoginStatus]) {
        if (isFirstOpen) {
            isFirstOpen = NO;
            [self setSubViewsProperty];
        }
    }else{
        SPBLoginVC *sVC = [[SPBLoginVC alloc]init];
        [self.navigationController pushViewController:sVC animated:YES];
    }
    if ([SysPubSingleThings sharePublicSingle].isChangeLogin) {
        //重新更新网络数据
        
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ****************************** System Delegate     ******************************
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
    
    StatisticsDetailVC *newVC = [[StatisticsDetailVC alloc] init];
    newVC.currentInt = index;
    newVC.naviController = self.navigationController;
    return newVC;
//    return nil;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

#pragma mark ****************************** event   Response    ******************************

#pragma mark ****************************** private Methods     ******************************
- (NSArray <NSString *> *)getRandomTitles {
    NSMutableArray *titles = @[@"今日", @"本周", @"本月"].mutableCopy;
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
#pragma mark ****************************** HTTP Server         ******************************

#pragma mark ****************************** getter and setter   ******************************
- (void)setSubViewsProperty {
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2.f, kStatusBarHeight+10, 80, 30)];
    nameLabel.backgroundColor= [UIColor clearColor];
    nameLabel.font = [UIFont systemFontOfSize:17.f];
    nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    nameLabel.text = @"统计详情";
    [self.view addSubview:nameLabel];
    //
    self.view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    CGFloat naviHeight = [UIApplication.sharedApplication.keyWindow jx_navigationHeight];
    self.titles = [self getRandomTitles];
    CGFloat categoryViewHeight = 50;
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = SCREEN_HEIGHT - naviHeight - categoryViewHeight;
    
    self.categoryView = [[JXCategoryTitleView alloc] init];
    self.categoryView.frame = CGRectMake(0, kStatusBarHeight+35, SCREEN_WIDTH, categoryViewHeight);
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
@end

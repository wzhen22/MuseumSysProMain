//
//  StatisticsDetailVC.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/28.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "StatisticsDetailVC.h"
#import "WDLineChartView.h"
#import "StatisticsSubLabelView.h"
#import "MJRefresh.h"

@interface StatisticsDetailVC ()

@property (strong, nonatomic) UIScrollView  * baseScrollView;
@property (nonatomic,weak) WDLineChartView * cView1;
@property (nonatomic,weak) WDLineChartView * cView2;
@end

@implementation StatisticsDetailVC

#pragma mark ****************************** life cycle          ******************************
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setSubViewsProperty];
    [self setupRefresh];
    //
    [self httpRequestDataAboutPeople];
    [self httpRequestDataAboutAddress];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

#pragma mark ****************************** Custom Delegate     ******************************
#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"%ld", (long)self.currentInt);
    if ([SysPubSingleThings sharePublicSingle].isChangeLogin) {
        //重新更新网络数据
        [self httpRequestDataAboutPeople];
        [self httpRequestDataAboutAddress];
    }
}

- (void)listDidDisappear {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"%ld", (long)self.currentInt);
}
#pragma mark ****************************** event   Response    ******************************

#pragma mark ****************************** private Methods     ******************************
-(void)changeViewStatus:(NSDictionary *)dic andIndex:(NSInteger )idex{
    switch (self.currentInt) {
        case 0:{
            NSArray *dayCountList = [dic safeObjectForKey:@"dayCountList"];
            NSArray *dayPersonList = [dic safeObjectForKey:@"dayPersonList"];
            NSArray *dayLocationList = [dic safeObjectForKey:@"dayLocationList"];
            if (idex == 1) {
                _cView1.xValues = dayPersonList;
                _cView1.yValues = dayCountList;
                [_cView1 drawChartView];
            }else{
                _cView2.xValues = dayLocationList;
                _cView2.yValues = dayCountList;
                [_cView2 drawChartView];
            }
            break;
        }
        case 1:{
            NSArray *weekCountList = [dic safeObjectForKey:@"weekCountList"];
            NSArray *weekPersonCountList = [dic safeObjectForKey:@"weekPersonCountList"];
            NSArray *weekLocationCountList = [dic safeObjectForKey:@"weekLocationCountList"];
            if (idex == 1) {
                _cView1.xValues = weekPersonCountList;
                _cView1.yValues = weekCountList;
                [_cView1 drawChartView];
            }else{
                _cView2.xValues = weekLocationCountList;
                _cView2.yValues = weekCountList;
                [_cView2 drawChartView];
            }
            break;
        }
        case 2:{
            NSArray *monthCountList = [dic safeObjectForKey:@"monthCountList"];
            NSArray *monthPersonList = [dic safeObjectForKey:@"monthPersonList"];
            NSArray *monthLocationList = [dic safeObjectForKey:@"monthLocationList"];
            if (idex == 1) {
                _cView1.xValues = monthPersonList;
                _cView1.yValues = monthCountList;
                [_cView1 drawChartView];
            }else{
                _cView2.xValues = monthLocationList;
                _cView2.yValues = monthCountList;
                [_cView2 drawChartView];
            }
            break;
        }
        default:
            break;
    }
}
#pragma mark ****************************** HTTP Server         ******************************
-(void)httpRequestDataAboutPeople{
    //    NSDictionary * dic = @{@"mobile":[SysPubSingleThings getUserName]};
    [SVProgressHUD show];
    NSDictionary * dic = @{};
    [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithGetBaseURL:BASE_HTTP_SERVER andMethond:@"/inspection/record/personCount" andParams:dic andSuccessBlock:^(id  _Nonnull retValue) {
        NSLog(@"andSuccessBlock:%@",retValue);
        [SVProgressHUD dismiss];
        [self.baseScrollView.mj_header endRefreshing];
        NSString *statusStr = [retValue safeObjectForKey:@"success"];
        if (statusStr.boolValue) {
            [self changeViewStatus:[retValue safeObjectForKey:@"obj"] andIndex:1];
        }else{
            
        }
    } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
        NSLog(@"andFailBlock:%@",error);
        [self.baseScrollView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
    }];
}
-(void)httpRequestDataAboutAddress{
    [SVProgressHUD show];
    NSDictionary * dic = @{};
    [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithGetBaseURL:BASE_HTTP_SERVER andMethond:@"/inspection/record/locationCount" andParams:dic andSuccessBlock:^(id  _Nonnull retValue) {
        NSLog(@"andSuccessBlock:%@",retValue);
        [SVProgressHUD dismiss];
        [self.baseScrollView.mj_header endRefreshing];
        NSString *statusStr = [retValue safeObjectForKey:@"success"];
        if (statusStr.boolValue) {
            [self changeViewStatus:[retValue safeObjectForKey:@"obj"] andIndex:2];
        }else{

        }
    } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
        NSLog(@"andFailBlock:%@",error);
        [self.baseScrollView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
    }];
}
#pragma mark ****************************** getter and setter   ******************************
- (void)setCurrentInt:(NSInteger)currentInt{
    _currentInt = currentInt;
    NSLog(@"_currentInt:%ld",(long)_currentInt);
}
- (void)setupRefresh {
    @weakify(self);
    self.baseScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self httpRequestDataAboutPeople];
        [self httpRequestDataAboutAddress];
    }];
}
-(void)setSubViewsProperty{
    self.baseScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.baseScrollView.backgroundColor = [UIColor clearColor];
    self.baseScrollView.showsVerticalScrollIndicator = YES;
    self.baseScrollView.showsHorizontalScrollIndicator = YES;
    self.baseScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 850);
    [self.view addSubview:self.baseScrollView];
    
    StatisticsSubLabelView *statisticsSubLabelView1 = [[StatisticsSubLabelView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 50)];
    [self.baseScrollView addSubview:statisticsSubLabelView1];
    
    WDLineChartView *newView1= [WDLineChartView lineChartViewWithFrame:CGRectMake(0,statisticsSubLabelView1.bottom,[UIScreen mainScreen].bounds.size.width,280)];
    [self.baseScrollView addSubview:newView1];
    self.cView1 = newView1;
//    _cView1.xValues = @[@1, @2, @3, @4, @5, @6, @7, @8, @9];
//    _cView1.yValues = @[@13.09,@20, @10, @14, @15, @13, @5, @7,@2];
    _cView1.showGrid = NO;
    _cView1.showFoldLine = NO;
    _cView1.showPoint = NO;
    _cView1.pointType = WDPointType_Circel;
    [_cView1 drawChartView];
    
    StatisticsSubLabelView *statisticsSubLabelView2 = [[StatisticsSubLabelView alloc] initWithFrame:CGRectMake(0, _cView1.bottom+5, SCREEN_WIDTH, 50)];
    statisticsSubLabelView2.leftImageView.backgroundColor = [UIColor greenColor];
    statisticsSubLabelView2.showLabel.text = @"巡检点概览";
    [self.baseScrollView addSubview:statisticsSubLabelView2];
    
    WDLineChartView *newView2= [WDLineChartView lineChartViewWithFrame:CGRectMake(0,statisticsSubLabelView2.bottom,[UIScreen mainScreen].bounds.size.width,280)];
    [self.baseScrollView addSubview:newView2];
     self.cView2 = newView2;
//    _cView2.xValues = @[@1, @2, @3, @4, @5, @6, @7, @8, @9];
//    _cView2.yValues = @[@903.09,@1000, @80, @400, @50, @130, @50, @75,@25];
    _cView2.showGrid = NO;
    _cView2.showFoldLine = NO;
    _cView2.showPoint = NO;
    _cView2.pillarColor = [UIColor greenColor];
    _cView2.pointType = WDPointType_Circel;
    [_cView2 drawChartView];
    
}
@end

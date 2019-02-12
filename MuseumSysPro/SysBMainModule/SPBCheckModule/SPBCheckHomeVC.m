//
//  SPBCheckHomeVC.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SPBCheckHomeVC.h"
#import <QuartzCore/QuartzCore.h>
#import "ReportFaultVC.h"
#import "ShowSuccessView.h"
#import "ReportFaultView.h"
#import "PubTimeLineTViewCell.h"
#import "SPBLoginVC.h"

@interface SPBCheckHomeVC ()<UINavigationControllerDelegate,UITableViewDelegate, UITableViewDataSource>{
    NSArray *dataArray;
    NSTimer *timeNow;
    BOOL isFirstOpen;
}
@property (strong, nonatomic) MJRefreshAutoNormalFooter     * footerView;
@property(nonatomic,strong) ShowSuccessView *showView ;
@property(nonatomic,strong) ReportFaultView *reportFaultView ;
@property(nonatomic,strong) NSMutableArray *deviceIDArray;
@property(nonatomic,assign) BOOL isShow;//是否展示正常打卡
@property(nonatomic,strong) MinewBeacon *currentDevice;//当前打卡设备
@end

@implementation SPBCheckHomeVC

#pragma mark ****************************** life cycle          ******************************
-(void)viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.baseScrollView.backgroundColor = [UIColor clearColor];
    isFirstOpen = YES;
    self.isShow = NO;
    self.deviceIDArray = [[NSMutableArray alloc]initWithCapacity:10];
    self.navigationController.delegate = self;
    self.view.backgroundColor = [UIColor colorWithHexString:@"ededed"];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.estimatedRowHeight = 0;
    self.mainTableView.estimatedSectionHeaderHeight = 0;
    self.mainTableView.estimatedSectionFooterHeight = 0;
    self.mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.mainTableView registerClass:[PubTimeLineTViewCell class] forCellReuseIdentifier:@"PubTimeLineTViewCell"];
    self.mainTableView.backgroundColor = [UIColor clearColor];
    //
    [self setBaseViewData];
    [self setupRefresh];
    //网络请求
//    [self httpRequestFromServers];
    
    //测试蓝牙扫描
    __weak typeof(self) weakSelf = self;
    [BeaconManager sharedInstance].awnVC = self;
    [BeaconManager sharedInstance].scanResultBlock = ^(NSArray * _Nonnull deviceArray) {
        NSLog(@"deviceArray:%@",deviceArray);
        if (deviceArray.count) {
            for (MinewBeacon *device in deviceArray) {
                BOOL isAble = [device getBeaconValue:BeaconValueIndex_InRage].boolValue;
                if (isAble == YES) {
                    weakSelf.isShow = YES;
                    weakSelf.currentDevice = device;
                    break;
                }else{
                    weakSelf.isShow = NO;
                }
            }
            [weakSelf changeViewStatues:nil andIsContent:weakSelf.isShow];
        }else{
            [weakSelf changeViewStatues:nil andIsContent:NO];
        }
        
    };
//    [[BeaconManager sharedInstance] scanBeaconAboutArray:@[]];
    //获取绑定的蓝牙设备列表
    [self getHttpAboutMarkList];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if ([SysPubSingleThings getLoginStatus]) {
        if (isFirstOpen) {
            isFirstOpen = NO;
            [self.baseScrollView.mj_header beginRefreshing];
        }

    }else{
        SPBLoginVC *sVC = [[SPBLoginVC alloc]init];
        [self.navigationController pushViewController:sVC animated:YES];
    }
    if ([SysPubSingleThings sharePublicSingle].isChangeLogin) {
        //重新更新网络数据
        [self httpRequestFromServers];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.baseScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 700);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ****************************** System Delegate     ******************************
/**
 *  告诉tableView一共有多少组数据
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [tableView tableViewDisplayWitMsg:@"暂无更多记录" ifNecessaryForRowCount:dataArray.count];
    return 1;
}

/**
 *  告诉tableView第section组有多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 被static修饰的局部变量：只会初始化一次，在整个程序运行过程中，只有一份内存
    static NSString *ID = @"PubTimeLineTViewCell";
    // 1.去缓存池中查找cell
    PubTimeLineTViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PubTimeLineTViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    bool isFirst = indexPath.row == 0;
    bool isLast = indexPath.row == dataArray.count-1;
//    NSString *testStr = @"测完飞洒发达考虑过";
//    [cell setDataSource:testStr isFirst:isFirst isLast:isLast];
    NSDictionary *ssDic = [dataArray objectAtIndex:indexPath.row];
    NSString *inspectTime = [ssDic safeObjectForKey:@"inspectTime"];
    NSDate *newDate = [SwTools stringToDate:inspectTime DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [SwTools dateToString:newDate DateFormat:@"HH:mm"];
    NSString *addressName = [ssDic safeObjectForKey:@"addressName"];
    NSDictionary *dic = @{@"inspectTime":dateStr?dateStr:@"..",@"addressName":addressName?addressName:@".."};
    [cell setDataSourceDic:dic isFirst:isFirst isLast:isLast];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index:%ld",(long)indexPath.section);
    
}
#pragma mark ****************************** Custom Delegate     ******************************

#pragma mark ****************************** event   Response    ******************************

- (IBAction)reportBtClick:(id)sender {
    DLog(@"reportBtClick");
    ReportFaultVC *reportVC = [[ReportFaultVC alloc]init];
    [self.navigationController pushViewController:reportVC animated:YES];
}
-(void) tapGestureClick{
    DLog(@"tapGestureClick");
    __weak typeof(self) weakSelf = self;
    if (self.isShow) {
        //
        NSString *deviceId =  [self.currentDevice getBeaconValue:BeaconValueIndex_UUID].stringValue;
        NSString *remaining_electricity =  [NSString stringWithFormat:@"%ld",(long)[self.currentDevice getBeaconValue:BeaconValueIndex_BatteryLevel].intValue];
        self.reportFaultView = nil;
        [[UIApplication sharedApplication].keyWindow addSubview:self.reportFaultView];
        self.reportFaultView.deviceId = deviceId;
        self.reportFaultView.remaining_electricity = remaining_electricity;
        self.reportFaultView.showViewBlock = ^(){
            NSLog(@"申请补卡");
            [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.showView];
        };
    }
    
//    [self changeViewStatues:nil andIsContent:YES];
}
#pragma mark ****************************** private Methods     ******************************

-(void)changeViewDataAboutDic:(NSDictionary *)dic{
    self.userNameLabel.text = [[SysPubSingleThings sharePublicSingle].loginDic safeObjectForKey:@"userName"];
    NSString *daysCount = [dic safeObjectForKey:@"daysCount"];
    NSArray *listArray = [dic safeObjectForKey:@"dayRecord"];
    dataArray = listArray;
    self.daysLabel.text = [NSString stringWithFormat:@"%@%@",daysCount,@"天"];
    [self.mainTableView reloadData];
}
-(void)changeViewStatues:(NSDictionary *)dic andIsContent:(BOOL)isContent{
    NSString *dateStr = [SwTools dateToString:[NSDate date] DateFormat:@"yyyy-MM-dd"];
    NSString *deviceName =  [self.currentDevice getBeaconValue:BeaconValueIndex_Name].stringValue;
    self.showBeaconLabel.text = deviceName;
    NSLog(@"%@",dateStr);
    if (isContent) {
        //在打卡范围
        self.circleView.layer.cornerRadius = self.circleView.frame.size.width / 2;
        self.circleView.backgroundColor = [UIColor colorWithHexString:@"cfe7ff"];
        self.subCircleView.layer.cornerRadius = self.subCircleView.frame.size.width / 2;
        self.subCircleView.backgroundColor = [UIColor colorWithHexString:@"148aff"];
        self.showImageView.image = [UIImage imageNamed:@"提示-已经进入打卡范围"];
        self.showLabel.text = @"已进入打卡范围";
        self.showBeaconLabel.hidden = NO;
    }else{
        self.circleView.layer.cornerRadius = self.circleView.frame.size.width / 2;
        self.circleView.backgroundColor = [UIColor colorWithHexString:@"f9e2ca"];
        self.subCircleView.layer.cornerRadius = self.subCircleView.frame.size.width / 2;
        self.subCircleView.backgroundColor = [UIColor colorWithHexString:@"ff8e14"];
        self.showImageView.image = [UIImage imageNamed:@"提示：当前不在打卡范围"];
        self.showLabel.text = @"当前不在打卡范围";
        self.showBeaconLabel.hidden = YES;
    }
}
#pragma mark ****************************** HTTP Server         ******************************
-(void)httpRequestFromServers{
    //    [SVProgressHUD showWithStatus:@"正在获取"];
    NSString *dateStr = [SwTools dateToString:[NSDate date] DateFormat:@"yyyy-MM-dd"];
    NSLog(@"%@",dateStr);
    NSDictionary * dic = @{@"dateTime":dateStr};
    [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithGetBaseURL:BASE_HTTP_SERVER andMethond:@"/inspection/record/getDayList" andParams:dic andSuccessBlock:^(id  _Nonnull retValue) {
        NSLog(@"andSuccessBlock:%@",retValue);
        [self.baseScrollView.mj_header endRefreshing];
        [self changeViewDataAboutDic:[retValue safeObjectForKey:@"obj"]];
        //        [SVProgressHUD showInfoWithStatus:[retValue safeObjectForKey:@"msg"]];
    } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
        NSLog(@"andFailBlock:%@",error);
        //        [SVProgressHUD showErrorWithStatus:@"请求数据失败"];
        [self.baseScrollView.mj_header endRefreshing];
    }];
}
//获取系统支持的巡检点
-(void)getHttpAboutMarkList{
    __weak typeof(self) weakSelf = self;
    NSDictionary * dic = @{};
    [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithPostBaseURL:BASE_HTTP_SERVER andMethond:@"/inspection/location/listAll" andParams:dic andSuccessBlock:^(id  _Nonnull retValue) {
        NSLog(@"andSuccessBlock:%@",retValue);
        NSString *statusStr = [retValue safeObjectForKey:@"success"];
        if (statusStr.boolValue) {
            NSArray *bindedList = retValue[@"obj"][@"bindedList"];
            if ([bindedList isKindOfClass:[NSArray class]] && bindedList.count) {
                for (NSDictionary *dic in bindedList) {
                    NSString *deviceId = [dic safeObjectForKey:@"deviceId"];
                    [weakSelf.deviceIDArray addObject:deviceId];
                }
            }
            [[BeaconManager sharedInstance] scanBeaconAboutArray:weakSelf.deviceIDArray];
        }else{
            
        }
    } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
        NSLog(@"andFailBlock:%@",error);
        
    }];
}
//查询蓝牙设备对应的巡检点名称
-(void)acchiveHttpAboutDetailMark:(NSString *)deviceId{
    NSDictionary * dic = @{@"deviceId":deviceId};
    [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithGetBaseURL:BASE_HTTP_SERVER andMethond:@"/inspection/location/getAddressName" andParams:dic andSuccessBlock:^(id  _Nonnull retValue) {
        NSLog(@"andSuccessBlock:%@",retValue);
        NSString *statusStr = [retValue safeObjectForKey:@"success"];
        if (statusStr.boolValue) {
            
        }else{
            
        }
    } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
        NSLog(@"andFailBlock:%@",error);
       
    }];
}
#pragma mark ****************************** getter and setter   ******************************
-(void)setBaseViewData{
    self.userNameLabel.text = @"您好";
    self.reportBt.backgroundColor = [UIColor colorWithHexString:@"148aff"];
    self.reportBt.layer.cornerRadius = 6.f;
    [self.reportBt setTitle:@"上报隐患" forState:UIControlStateNormal];
    [self.reportBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.daysLabel.textColor = [UIColor colorWithHexString:@"148aff"];
    
    self.leftShowView1.backgroundColor = [UIColor colorWithHexString:@"afd1f2"];
    [self.leftShowView1 setTitle:@"巡检打卡" forState:UIControlStateNormal];
    [self.leftShowView1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leftShowView1.layer.cornerRadius = 18.f;
    self.leftShowView2.backgroundColor = [UIColor colorWithHexString:@"afd1f2"];
    [self.leftShowView2 setTitle:@"打卡记录" forState:UIControlStateNormal];
    [self.leftShowView2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leftShowView2.layer.cornerRadius = 18.f;
    //正常打卡范围的色值
    self.circleView.layer.cornerRadius = self.circleView.frame.size.width / 2;
    self.circleView.backgroundColor = [UIColor colorWithHexString:@"cfe7ff"];
    self.subCircleView.layer.cornerRadius = self.subCircleView.frame.size.width / 2;
    self.subCircleView.backgroundColor = [UIColor colorWithHexString:@"148aff"];
    //设置初始视图状态值
    
    [self changeViewStatues:nil andIsContent:NO];
    //添加响应手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick)];
    [self.circleView addGestureRecognizer:tapGesture];
    //
    timeNow = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];
    
}
- (void)timerFunc
{
    NSString *dateStr = [SwTools dateToString:[NSDate date] DateFormat:@"HH:mm"];
    self.timeLabel.text = dateStr;
}
- (void)setupRefresh {
    @weakify(self);
    _baseScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self httpRequestFromServers];
    }];
    
    if (!_footerView) {
        self.footerView = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
//            [self requestMoreData];
            [self.footerView endRefreshingWithNoMoreData];
        }];
        [_footerView setTitle:@"." forState:MJRefreshStateIdle];//闲置
        [_footerView setTitle:@"Loading ..." forState:MJRefreshStateRefreshing  ];//正在加载
        [_footerView setTitle:@"—— 没有更多数据了! ——" forState:MJRefreshStateNoMoreData  ];//没有数据
        [_footerView setTitle:@"" forState:MJRefreshStateWillRefresh ];//将要刷新
        [_footerView setTitle:@"" forState:MJRefreshStatePulling     ];//松手刷新
        _footerView.automaticallyRefresh = YES;
        _footerView.automaticallyHidden = YES;  // 隐藏刷新状态的文字
        _footerView.refreshingTitleHidden = NO;
        _footerView.hidden = YES;
    }
    _baseScrollView.mj_footer = _footerView;
}

- (ShowSuccessView *)showView {
    if (!_showView) {
        ShowSuccessView *secView = [ShowSuccessView loadView];
        _showView = secView;
//        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"ShowSuccessView" owner:self options:nil];
//        if (nibArray.count > 0) {
//            _showView = (ShowSuccessView *)nibArray.firstObject;
//        }
    }
    return _showView;
}
- (ReportFaultView *)reportFaultView {
    if (!_reportFaultView) {
        ReportFaultView *secView = [ReportFaultView loadView];
        _reportFaultView = secView;
    }
    return _reportFaultView;
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

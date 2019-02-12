//
//  SPBSIgnInHomeVC.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SPBSIgnInHomeVC.h"
#import "YXCalendarView.h"
#import "PubCellDetailView.h"
#import "SPBRequestSignVC.h"
#import "PubTimeLineTViewCell.h"

@interface SPBSIgnInHomeVC ()<UINavigationControllerDelegate,UITableViewDelegate, UITableViewDataSource>{
    NSArray *dataArray;
    NSMutableArray *muMarkArray;
    NSString *cSelectDate;
}
@property (strong, nonatomic) UIScrollView  * baseScrollView;
@property (nonatomic, strong) YXCalendarView *calendar;
@property(nonatomic,strong) PubCellDetailView *pubCellDetailView1;
@property(nonatomic,strong) PubCellDetailView *pubCellDetailView2;
@property (strong, nonatomic) UITableView  * mainTableView;

@end

@implementation SPBSIgnInHomeVC

#pragma mark ****************************** life cycle          ******************************
-(void)viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.delegate = self;
    self.baseScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.baseScrollView.backgroundColor = [UIColor clearColor];
    self.baseScrollView.showsVerticalScrollIndicator = YES;
    self.baseScrollView.showsHorizontalScrollIndicator = YES;
    self.baseScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 800);
    [self.view addSubview:self.baseScrollView];
    
    muMarkArray = [[NSMutableArray alloc]initWithCapacity:10];
    self.view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
//    self.view.backgroundColor = [UIColor RandomColor];
    _calendar = [[YXCalendarView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+10, [UIScreen mainScreen].bounds.size.width, [YXCalendarView getMonthTotalHeight:[NSDate date] type:CalendarType_Month]+30) Date:[NSDate date] Type:CalendarType_Month];
    _calendar.markArray = @[@"01-25"];
    __weak typeof(_calendar) weakCalendar = _calendar;
     __weak typeof(self) weakSelf = self;
    _calendar.refreshH = ^(CGFloat viewH) {
        [UIView animateWithDuration:0.3 animations:^{
            weakCalendar.frame = CGRectMake(0, kStatusBarHeight+10, [UIScreen mainScreen].bounds.size.width, viewH);
        }];
        
    };
    _calendar.changeMonth = ^(NSDate *date) {
        NSString *dateStr = [SwTools dateToString:date DateFormat:@"yyyy-MM"];
        NSLog(@"changeMonth:%@",dateStr);
        [weakSelf httpRequestFromServers:date];
    };
    _calendar.sendSelectDate = ^(NSDate *selDate) {
        NSLog(@"%@",[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM-dd" Date:selDate]);
        [weakSelf httpRequestFromDate: [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM-dd" Date:selDate]];
    };
    [self.baseScrollView addSubview:_calendar];
    [self setSubViewsProperty];
    [self setupRefresh];
//    [self.baseScrollView.mj_header beginRefreshing];
    [self httpRequestFromServers:[NSDate date]];
    NSString *dateStr = [SwTools dateToString:[NSDate date] DateFormat:@"yyyy-MM-dd"];
    [self httpRequestFromDate:dateStr];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([SysPubSingleThings sharePublicSingle].isChangeLogin) {
        //重新更新网络数据
        [self httpRequestFromServers:[NSDate date]];
        NSString *dateStr = [SwTools dateToString:[NSDate date] DateFormat:@"yyyy-MM-dd"];
        [self httpRequestFromDate:dateStr];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
//    headView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 被static修饰的局部变量：只会初始化一次，在整个程序运行过程中，只有一份内存
    static NSString *pubID = @"PubTimeLineTViewCell";
    // 1.去缓存池中查找cell
    PubTimeLineTViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pubID];
    if (cell == nil) {
        cell = [[PubTimeLineTViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pubID];
    }
    bool isFirst = indexPath.row == 0;
    bool isLast = indexPath.row == dataArray.count-1;
    NSDictionary *ssDic = [dataArray objectAtIndex:indexPath.row];
    NSString *inspectTime = [ssDic safeObjectForKey:@"inspectTime"];
    NSDate *newDate = [SwTools stringToDate:inspectTime DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [SwTools dateToString:newDate DateFormat:@"HH:mm"];
    NSString *addressName = [ssDic safeObjectForKey:@"addressName"];
//    NSDictionary *dic = @{@"inspectTime":dateStr,@"addressName":addressName};
    NSDictionary *dic = @{@"inspectTime":dateStr?dateStr:@"..",@"addressName":addressName?addressName:@".."};
    cell.backgroundColor = [UIColor clearColor];
    [cell setDataSourceDic:dic isFirst:isFirst isLast:isLast];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index:%ld",(long)indexPath.section);
    
}
#pragma mark ****************************** Custom Delegate     ******************************

#pragma mark ****************************** event   Response    ******************************

#pragma mark ****************************** private Methods     ******************************
-(void)jumpNewSingVC{
    SPBRequestSignVC *signVC = [[SPBRequestSignVC alloc]init];
    signVC.title = [NSString stringWithFormat:@"申请补卡(%@)",cSelectDate];
    signVC.selectDateStr = cSelectDate;
    [self.navigationController pushViewController:signVC animated:YES];
}
-(void)changeViewStatus:(NSDictionary *)dic{
    NSString *daysStr = [NSString stringWithFormat:@"%@天",[dic safeObjectForKey:@"days"]];
    _pubCellDetailView1.subLable.text = daysStr;
    NSArray *dayList = [dic safeObjectForKey:@"attendaceDateList"];
    [muMarkArray removeAllObjects];
    if ([dayList isKindOfClass:[NSArray class]] && dayList.count) {
        for (NSDictionary *dateDic in dayList) {
            NSString *dateString = [dateDic safeObjectForKey:@"date"];
            NSDate *newDate = [SwTools stringToDate:dateString DateFormat:@"yyyy-MM-dd"];
            NSString *dateStr = [SwTools dateToString:newDate DateFormat:@"MM-dd"];
            [muMarkArray addObject:dateStr];
        }
    }
    _calendar.markArray = muMarkArray;
}
-(void)changeTableViewDada:(NSDictionary *)dic{
    NSString *daysCount = [dic safeObjectForKey:@"daysCount"];
    NSString *daysStr = [NSString stringWithFormat:@"%@天",daysCount];
    _pubCellDetailView1.subLable.text = daysStr;
    NSArray *listArray = [dic safeObjectForKey:@"dayRecord"];
    dataArray = listArray;
    if (!dataArray.count) {
        _pubCellDetailView2.subLable.hidden = YES;
        _pubCellDetailView2.rightBT.hidden = NO;
    }else{
        _pubCellDetailView2.subLable.hidden = NO;
        _pubCellDetailView2.rightBT.hidden = YES;
    }
    [self.mainTableView reloadData];
}
#pragma mark ****************************** HTTP Server         ******************************
-(void)httpRequestFromServers:(NSDate *)date{
    [SVProgressHUD show];
    NSString *dateStr = [SwTools dateToString:date DateFormat:@"yyyy-MM"];
    NSDictionary * dic = @{@"mouth":dateStr
                           };
    [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithPostBaseURL:BASE_HTTP_SERVER andMethond:@"/inspection/attendance/getListByMonth" andParams:dic andSuccessBlock:^(id  _Nonnull retValue) {
        NSLog(@"andSuccessBlock:%@",retValue);
        [SVProgressHUD dismiss];
        [self.baseScrollView.mj_header endRefreshing];
        NSString *statusStr = [retValue safeObjectForKey:@"success"];
        if (statusStr.boolValue) {
            [self changeViewStatus:[retValue safeObjectForKey:@"obj"]];
        }else{
            [SVProgressHUD showInfoWithStatus:[retValue safeObjectForKey:@"msg"]];
        }
    } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
        NSLog(@"andFailBlock:%@",error);
        [self.baseScrollView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
    }];
}
-(void)httpRequestFromDate:(NSString *)dateString{
    //    [SVProgressHUD showWithStatus:@"正在获取"];
//    NSString *dateStr = [SwTools dateToString:[NSDate date] DateFormat:@"yyyy-MM-dd"];
//    NSLog(@"%@",dateStr);
    cSelectDate = dateString;
    NSDictionary * dic = @{@"dateTime":dateString};
    [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithGetBaseURL:BASE_HTTP_SERVER andMethond:@"/inspection/record/getDayList" andParams:dic andSuccessBlock:^(id  _Nonnull retValue) {
        NSLog(@"andSuccessBlock:%@",retValue);
        [self changeTableViewDada:[retValue safeObjectForKey:@"obj"]];
    } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
        NSLog(@"andFailBlock:%@",error);
        
    }];
}

#pragma mark ****************************** getter and setter   ******************************
-(void)setSubViewsProperty{
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _calendar.bottom+10, SCREEN_WIDTH, 46)];
    nameLabel.backgroundColor= [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:13.f];
    nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    nameLabel.text = @"             温馨提示：蓝色小圆点“ . ”为当日已巡检执勤";
    [self.baseScrollView addSubview:nameLabel];
    UIImageView *ddImagev= [[UIImageView alloc]initWithFrame:CGRectMake(20, _calendar.bottom+10+15, 16, 16)];
    ddImagev.image = [UIImage imageNamed:@"提示：当前不在打卡范围"];
    ddImagev.backgroundColor = [UIColor clearColor];
    [self.baseScrollView addSubview:ddImagev];
    
    _pubCellDetailView1 = [[PubCellDetailView alloc]initWithFrame:CGRectMake(0, nameLabel.bottom+10, SCREEN_WIDTH, 46)];
    _pubCellDetailView1.mainImageView.image = [UIImage imageNamed:@"icon-当月累计打卡天数"];
    _pubCellDetailView1.mainLable.text = @"当月累计打卡天数";
    _pubCellDetailView1.subLable.textColor = [UIColor colorWithHexString:@"148aff"];
    _pubCellDetailView1.subLable.text = @"20天";
    _pubCellDetailView1.rightBT.hidden = YES;
    _pubCellDetailView2 = [[PubCellDetailView alloc]initWithFrame:CGRectMake(0, _pubCellDetailView1.bottom, SCREEN_WIDTH, 46)];
    _pubCellDetailView2.mainImageView.image = [UIImage imageNamed:@"icon-当日巡检记录"];
    _pubCellDetailView2.mainLable.text = @"当日巡检记录";
    _pubCellDetailView2.subLable.textColor = [UIColor colorWithHexString:@"148aff"];
    _pubCellDetailView2.subLable.text = @"正常";
    _pubCellDetailView2.subLable.hidden = YES;
    _pubCellDetailView2.rightBT.hidden = NO;
    [_pubCellDetailView2.rightBT setImage:[UIImage imageNamed:@"移动考勤页-标签-未打卡按钮"] forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    _pubCellDetailView2.rightBtBlock = ^(){
        NSLog(@"申请补卡");
        [weakSelf jumpNewSingVC];
    };
    [self.baseScrollView addSubview:_pubCellDetailView1];
    [self.baseScrollView addSubview:_pubCellDetailView2];
    [self.baseScrollView addSubview:self.mainTableView];
}
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _pubCellDetailView2.bottom, SCREEN_WIDTH-25, SCREEN_HEIGHT-_pubCellDetailView2.bottom) style:UITableViewStylePlain];
//        _mainTableView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
        // 注册某个标识对应的cell类型
        [_mainTableView registerClass:[PubTimeLineTViewCell class] forCellReuseIdentifier:@"PubTimeLineTViewCell"];
        //        [_mainTableView registerNib:[UINib nibWithNibName:@"AddCollectionTabeCell" bundle:nil] forCellReuseIdentifier:@"addCollectionTableCell"];
    }
    return _mainTableView;
}
- (void)setupRefresh {
    @weakify(self);
    self.baseScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self httpRequestFromServers:[NSDate date]];
    }];
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

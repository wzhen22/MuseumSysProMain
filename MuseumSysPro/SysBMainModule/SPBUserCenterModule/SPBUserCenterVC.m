//
//  SPBUserCenterVC.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SPBUserCenterVC.h"
#import "SPBResetPasswordVC.h"
#import "SPBAboutWeVC.h"
#import "SPBLoginVC.h"
#import "SPBMainUserHeaderView.h"
#import "UserCTableViewCell.h"

@interface SPBUserCenterVC ()<UINavigationControllerDelegate,UITableViewDelegate, UITableViewDataSource>{
    NSArray *dataArray;
    NSArray *imageArray;
}
@property (strong, nonatomic) UITableView  * mainTableView;
@property (strong, nonatomic) SPBMainUserHeaderView  * tableHeaderUserView;

@end

@implementation SPBUserCenterVC

#pragma mark ****************************** life cycle          ******************************
-(void)viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 设置导航控制器的代理为self
    dataArray = @[@"重置密码",@"关于我们",@"退出登录"];
    imageArray = @[@"icon-重置密码",@"icon-关于我们",@"icon-退出登录"];
    self.navigationController.delegate = self;
//    self.view.backgroundColor = [UIColor RandomColor];
    [self.view addSubview:self.mainTableView];
    //初始化数据
    [self setHeaderViewData:nil];
    [self setupRefresh];
//    [self.mainTableView.mj_header beginRefreshing];
    [self httpRequestData];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    if ([SysPubSingleThings sharePublicSingle].isChangeLogin) {
        //重新更新网络数据
        [self httpRequestData];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
}

#pragma mark ****************************** System Delegate     ******************************
/**
 *  告诉tableView一共有多少组数据
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

/**
 *  告诉tableView第section组有多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    return headView;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 被static修饰的局部变量：只会初始化一次，在整个程序运行过程中，只有一份内存
    static NSString *ID = @"UserCTableViewCell";
    // 1.去缓存池中查找cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    // 2.覆盖数据
    NSString *imageStr = [imageArray objectAtIndex:indexPath.section];
    NSString *dataStr = [dataArray objectAtIndex:indexPath.section];
    cell.imageView.image = [UIImage imageNamed:imageStr];
    cell.textLabel.text = dataStr;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index:%ld",(long)indexPath.section);
    if (indexPath.section==0) {
        SPBResetPasswordVC *sVC = [[SPBResetPasswordVC alloc]init];
        sVC.title = @"重置密码";
        [self.navigationController pushViewController:sVC animated:YES];
    }else if (indexPath.section == 1){
        SPBAboutWeVC *sVC = [[SPBAboutWeVC alloc]init];
        [self.navigationController pushViewController:sVC animated:YES];
    }else if (indexPath.section == 2){
        //退出登录
        [SVProgressHUD showWithStatus:@"正在登出"];
        [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithPostBaseURL:BASE_HTTP_SERVER andMethond:@"/logout" andParams:nil andSuccessBlock:^(id  _Nonnull retValue) {
            NSLog(@"andSuccessBlock:%@",retValue);
            [SVProgressHUD dismiss];
            [SysPubSingleThings saveLoginStatus:NO];
            [SysPubSingleThings sharePublicSingle].isChangeLogin = YES;
            SPBLoginVC *sVC = [[SPBLoginVC alloc]init];
            [self.navigationController pushViewController:sVC animated:YES];
        } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
            NSLog(@"andFailBlock:%@",error);
            [SVProgressHUD dismiss];
        }];

        
    }else{
        
    }
}
#pragma mark ****************************** Custom Delegate     ******************************

#pragma mark ****************************** event   Response    ******************************

#pragma mark ****************************** private Methods     ******************************

#pragma mark ****************************** HTTP Server         ******************************
-(void)httpRequestData{
//    NSDictionary * dic = @{@"mobile":[SysPubSingleThings getUserName]};
    [SVProgressHUD show];
    NSDictionary * dic = @{};
    [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithGetBaseURL:BASE_HTTP_SERVER andMethond:@"/inspection/loophole/statistics" andParams:dic andSuccessBlock:^(id  _Nonnull retValue) {
        NSLog(@"andSuccessBlock:%@",retValue);
        [SVProgressHUD dismiss];
        [self.mainTableView.mj_header endRefreshing];
        NSString *statusStr = [retValue safeObjectForKey:@"success"];
        if (statusStr.boolValue) {
            [self changeViewStatus:[retValue safeObjectForKey:@"obj"]];
        }else{
            
        }
    } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
        NSLog(@"andFailBlock:%@",error);
        [self.mainTableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
    }];
}
-(void)changeViewStatus:(NSDictionary *)dic{
    _tableHeaderUserView.userNameLable.text = [[SysPubSingleThings sharePublicSingle].loginDic safeObjectForKey:@"userName"];
    NSString *days = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"days"]];
    [_tableHeaderUserView.userHeaderSubShowView1.subBT setTitle:days forState:UIControlStateNormal];
    NSString *reportCount = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"reportCount"]];
    [_tableHeaderUserView.userHeaderSubShowView2.subBT setTitle:reportCount forState:UIControlStateNormal];
    NSString *solveCount = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"solveCount"]];
    [_tableHeaderUserView.userHeaderSubShowView3.subBT setTitle:solveCount forState:UIControlStateNormal];
}
#pragma mark ****************************** getter and setter   ******************************
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _mainTableView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
        //设置header
        _tableHeaderUserView = [[SPBMainUserHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 270)];
        _mainTableView.tableHeaderView = _tableHeaderUserView;
        // 注册某个标识对应的cell类型
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UserCTableViewCell"];
//        [_mainTableView registerNib:[UINib nibWithNibName:@"AddCollectionTabeCell" bundle:nil] forCellReuseIdentifier:@"addCollectionTableCell"];
    }
    return _mainTableView;
}
-(void) setHeaderViewData:(NSDictionary *)dict{
    _tableHeaderUserView.userNameLable.text = @"您好";
    [_tableHeaderUserView.userHeaderSubShowView1.subBT setTitle:@"0" forState:UIControlStateNormal];
    _tableHeaderUserView.userHeaderSubShowView1.subLable.text = @"当月打卡数";
    
    [_tableHeaderUserView.userHeaderSubShowView2.subBT setTitle:@"0" forState:UIControlStateNormal];
    _tableHeaderUserView.userHeaderSubShowView2.subLable.text = @"累计上报隐患数";
    
    [_tableHeaderUserView.userHeaderSubShowView3.subBT setTitle:@"0" forState:UIControlStateNormal];
    _tableHeaderUserView.userHeaderSubShowView3.subLable.text = @"累计处理隐患数";
}
- (void)setupRefresh {
    @weakify(self);
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self httpRequestData];
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

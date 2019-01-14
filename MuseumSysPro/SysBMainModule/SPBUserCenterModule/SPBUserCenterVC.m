//
//  SPBUserCenterVC.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SPBUserCenterVC.h"
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
    // 设置导航控制器的代理为self
    dataArray = @[@"重置密码",@"关于我们",@"退出登录"];
    imageArray = @[@"",@"",@""];
    self.navigationController.delegate = self;
//    self.view.backgroundColor = [UIColor RandomColor];
    [self.view addSubview:self.mainTableView];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    cell.imageView.image = [UIImage imageNamed:@"04-个人中心-norma"];
    cell.textLabel.text = [NSString stringWithFormat:@"testdata - %zd", indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index:%ld",(long)indexPath.section);
}
#pragma mark ****************************** Custom Delegate     ******************************

#pragma mark ****************************** event   Response    ******************************

#pragma mark ****************************** private Methods     ******************************

#pragma mark ****************************** HTTP Server         ******************************

#pragma mark ****************************** getter and setter   ******************************
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mainTableView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 10;
        _mainTableView.estimatedSectionFooterHeight = 0;
        //设置header
        _tableHeaderUserView = [[SPBMainUserHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
        _mainTableView.tableHeaderView = _tableHeaderUserView;
        // 注册某个标识对应的cell类型
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UserCTableViewCell"];
//        [_mainTableView registerNib:[UINib nibWithNibName:@"AddCollectionTabeCell" bundle:nil] forCellReuseIdentifier:@"addCollectionTableCell"];
    }
    return _mainTableView;
}
#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)dealloc {
    self.navigationController.delegate = nil;
}
@end

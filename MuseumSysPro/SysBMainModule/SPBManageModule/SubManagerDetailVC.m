//
//  SubManagerDetailVC.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/11.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SubManagerDetailVC.h"
#import "MJRefresh.h"
#import "SubSignManagerCell.h"
#import "WillOperateVC.h"
#import "BeOperateVC.h"

@interface SubManagerDetailVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) MJRefreshAutoNormalFooter     * footerView;
@property (nonatomic, strong) UICollectionView *collectionV;
@property (nonatomic, assign) NSInteger currentPage;
@property(nonatomic,strong) NSMutableArray *objDataArray;
@end

@implementation SubManagerDetailVC

#pragma mark ****************************** life cycle          ******************************
-(void)viewDidLoad{
    [super viewDidLoad];
    _currentPage = 1;
    self.objDataArray = [[NSMutableArray alloc]initWithCapacity:10];
    self.view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    [self setSubViewsProperty];
    [self setupRefresh];
    [self httpRequestFromServers: self.currentInt];
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.objDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SubSignManagerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SubSignManagerCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    cell.layer.cornerRadius = 6.f;
    NSDictionary *ddDic = [self.objDataArray objectAtIndex:indexPath.row];
    NSString *uploadTime = [ddDic safeObjectForKey:@"reportTime"];
    NSDate *newDate = [SwTools stringToDate:uploadTime DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [SwTools dateToString:newDate DateFormat:@"yyyy-MM-dd"];
    cell.lable1.text = dateStr;
    NSString *loopholeTypeName = [ddDic safeObjectForKey:@"loopholeTypeName"];
    cell.label2.text = loopholeTypeName;
    NSString *loopholeAddress = [ddDic safeObjectForKey:@"loopholeAddress"];
    cell.label4.text = loopholeAddress;
    switch (self.currentInt) {
        case 0:
        {
            cell.changeLabel.text = @"处理状态";
            NSString *dealState = [ddDic safeObjectForKey:@"dealState"];//（0:未处理，1:已处理，2:已结束）
            switch (dealState.integerValue) {
                case 0:
                {
                    cell.label3.text = @"待处理";
                    cell.label3.textColor = [UIColor redColor];
                    break;
                }
                case 1:
                {
                    cell.label3.text = @"已处理";
                    cell.label3.textColor = [UIColor colorWithHexString:@"148aff"];
                    break;
                }
                case 2:
                {
                    cell.label3.text = @"已结束";
                    cell.label3.textColor = [UIColor redColor];
                    break;
                }
                default:
                    cell.label3.text = @"未知";
                    break;
            }
            
            break;
        }
        case 1:{
            cell.changeLabel.text = @"上报人员";
            NSString *reporter = [ddDic safeObjectForKey:@"reporter"];
            cell.label3.text = reporter;
            cell.label3.textColor = [UIColor darkGrayColor];
            break;
        }
        case 2:{
            cell.changeLabel.text = @"处理人员";
            NSString *handler = [ddDic safeObjectForKey:@"handler"];
            cell.label3.text = handler;
            cell.label3.textColor = [UIColor darkGrayColor];
            break;
        }
        default:{
            
          break;
        }
    }
    
    return cell;
    
}

//MARK: - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath:%ld",(long)indexPath.row);
    NSDictionary *ddDic = [self.objDataArray objectAtIndex:indexPath.row];
    NSString *mid = [ddDic safeObjectForKey:@"mid"];
    switch (self.currentInt) {
        case 0:
        {
            NSString *dealState = [ddDic safeObjectForKey:@"dealState"];
            if (dealState.integerValue == 1) {
                BeOperateVC *willVC = [[BeOperateVC alloc]init];
                willVC.midString = [NSString stringWithFormat:@"%@",mid];
                [self.naviController pushViewController:willVC animated:YES];
            }else{
                WillOperateVC *willVC = [[WillOperateVC alloc]init];
                willVC.isBeClosed = YES;
                willVC.midString = [NSString stringWithFormat:@"%@",mid];
                [self.naviController pushViewController:willVC animated:YES];
            }
        }
            break;
        case 1:{
            WillOperateVC *willVC = [[WillOperateVC alloc]init];
            willVC.midString = [NSString stringWithFormat:@"%@",mid];
            [self.naviController pushViewController:willVC animated:YES];
            break;
        }
        default:{
            BeOperateVC *willVC = [[BeOperateVC alloc]init];
            willVC.midString = [NSString stringWithFormat:@"%@",mid];
            [self.naviController pushViewController:willVC animated:YES];
        }
            break;
    }
    
}

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
        [self httpRequestFromServers: self.currentInt];
    }
}

- (void)listDidDisappear {
     NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"%ld", (long)self.currentInt);
}
#pragma mark ****************************** event   Response    ******************************

#pragma mark ****************************** private Methods     ******************************

#pragma mark ****************************** HTTP Server         ******************************
//查询安全隐患列表
-(void)httpRequestFromServers:(NSInteger) currentInt{
    NSString *dealState;//0:未处理，1:已处理，2:已结束
    NSString *selfStr;//目前都设置为查询自己上报的，如果不,传@"0"
    switch (currentInt) {
        case 0:{
            dealState = @"";
            selfStr = @"1";
            break;
        }
        case 1:{
            dealState = @"0";
            selfStr = @"1";
            break;
        }
        case 2:{
            dealState = @"1";
            selfStr = @"1";
            break;
        }
        default:
            break;
    }
    [SVProgressHUD show];
    NSDictionary * dic;
    if (currentInt==0) {
        dic = @{@"self":selfStr,
                @"currentPage":[NSString stringWithFormat:@"%ld",(long)_currentPage],
                @"pageSize":@"10"
                };
    }else{
        dic = @{@"dealState":dealState,
                @"self":selfStr,
                @"currentPage":[NSString stringWithFormat:@"%ld",(long)_currentPage],
                @"pageSize":@"10"
                };
    }
    [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithPostBaseURL:BASE_HTTP_SERVER andMethond:@"/inspection/loophole/dataGrid" andParams:dic andSuccessBlock:^(id  _Nonnull retValue) {
        NSLog(@"andSuccessBlock:%@",retValue);
        [SVProgressHUD dismiss];
        [self.collectionV.mj_header endRefreshing];
        [self.collectionV.mj_footer endRefreshing];
        NSString *statusStr = [retValue safeObjectForKey:@"success"];
        if (statusStr.boolValue) {
            NSArray *objArray = [retValue safeObjectForKey:@"obj"];
            if ([objArray isKindOfClass:[NSArray class]]) {
                if (objArray.count) {
                    if (self.currentPage<2) {
                        [self.objDataArray removeAllObjects];
                    }
                    [self.objDataArray addObjectsFromArray:objArray];
                    [self.collectionV reloadData];
                    if (objArray.count<10) {
                        [self.footerView endRefreshingWithNoMoreData];
                    }else{
                        if (self.currentPage<2) {
                            self.collectionV.mj_footer = self.footerView;
                        }
                    }
                }else{
                    [self.footerView endRefreshingWithNoMoreData];
                }
            }
        }else{
            [SVProgressHUD showInfoWithStatus:[retValue safeObjectForKey:@"msg"]];
        }
    } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
        NSLog(@"andFailBlock:%@",error);
        [self.collectionV.mj_header endRefreshing];
        [self.collectionV.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
    }];
}
#pragma mark ****************************** getter and setter   ******************************
-(void)setSubViewsProperty{
    [self setCollectionView];
}
- (void)setCurrentInt:(NSInteger)currentInt{
    _currentInt = currentInt;
    NSLog(@"_currentInt:%ld",(long)_currentInt);
}
- (void)setCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 20;
    layout.itemSize = CGSizeMake((self.view.frame.size.width - 20), 163);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kTabBarHeight-(kStatusBarHeight+90)) collectionViewLayout:layout];
//    _collectionV.scrollEnabled = NO;
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    _collectionV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionV];
    
    [_collectionV registerNib:[UINib nibWithNibName:@"SubSignManagerCell" bundle:nil] forCellWithReuseIdentifier:@"SubSignManagerCell"];
    
}
- (void)setupRefresh {
    @weakify(self);
    _collectionV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.currentPage = 1;
        [self httpRequestFromServers: self.currentInt];
    }];
    
    if (!_footerView) {
        self.footerView = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            self.currentPage++;
            [self httpRequestFromServers: self.currentInt];
            
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
//    _collectionV.mj_footer = _footerView;
}

@end

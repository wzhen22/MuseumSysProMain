//
//  WillOperateVC.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/18.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "WillOperateVC.h"
#import "OperateFaultPublishVC.h"
#import "HXPhotoPicker.h"

@interface WillOperateVC ()<HXPhotoViewDelegate>{
    NSMutableArray *baseImageArray;
}

@property (strong, nonatomic) HXPhotoManager *manager;
@property (weak, nonatomic) HXPhotoView *photoView;

@end

@implementation WillOperateVC

#pragma mark ****************************** life cycle          ******************************
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"详 情";
    baseImageArray = [[NSMutableArray alloc]initWithCapacity:10];
    [self setSubViewsProperty];
    [self setBaseViewsData];
    //添加响应手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mainTapGestureClick)];
    [self.topBackView addGestureRecognizer:tapGesture];
    [self.middleBackView addGestureRecognizer:tapGesture];
    if (self.midString) {
        [self httpRequestFromServers:self.midString];
    }
}
-(void) mainTapGestureClick{
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:19],NSFontAttributeName, nil];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)viewDidLayoutSubviews
{
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT+100);
}
#pragma mark ****************************** System Delegate     ******************************

#pragma mark ****************************** Custom Delegate     ******************************
- (void)didClickAlertView:(NSInteger)buttonIndex value:(id)value{
    NSLog(@"委托代理=当前点击--%zi",buttonIndex);
    
}
-(void)photoListViewControllerDidDone:(HXPhotoView *)photoView allList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal{
    NSLog(@"allList:%@",allList);
}
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    NSSLog(@"所有:%ld - 照片:%ld - 视频:%ld",allList.count,photos.count,videos.count);
    
}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame
{
    NSSLog(@"%@",NSStringFromCGRect(frame));
}
#pragma mark ****************************** event   Response    ******************************

- (IBAction)commitBtClick:(id)sender {
    OperateFaultPublishVC *willVC = [[OperateFaultPublishVC alloc]init];
    willVC.midString = self.midString;
    [self.navigationController pushViewController:willVC animated:YES];
}
#pragma mark ****************************** private Methods     ******************************
- (void)navBackAction
{
    UIViewController *ctrl = [self.navigationController popViewControllerAnimated:YES];
    if (ctrl == nil)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
-(void)changeSubViewsStatues:(NSDictionary *)dataDic{
    NSString *dealState = [dataDic safeObjectForKey:@"dealState"];
    if (dealState.integerValue == 2) {
        self.isBeClosed = YES;
    }else{
        self.isBeClosed = NO;
    }
    [self setBaseViewsData];
    //
    NSString *uploadTime = [dataDic safeObjectForKey:@"reportTime"];
    NSDate *newDate = [SwTools stringToDate:uploadTime DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [SwTools dateToString:newDate DateFormat:@"yyyy-MM-dd"];
    NSString *loopholeTypeName = [dataDic safeObjectForKey:@"loopholeTypeName"];
    NSString *reporter = [dataDic safeObjectForKey:@"reporter"];
    NSString *loopholeAddress = [dataDic safeObjectForKey:@"loopholeAddress"];
    NSString *description = [dataDic safeObjectForKey:@"description"];
    NSArray *loophole_imgIds = [dataDic safeObjectForKey:@"loophole_imgIds"];
    [baseImageArray removeAllObjects];
    if ([loophole_imgIds isKindOfClass:[NSArray class]] && loophole_imgIds.count) {
        for (NSDictionary *subDicd in loophole_imgIds) {
            NSString *htmlUrl = [subDicd safeObjectForKey:@"htmlUrl"];
            [baseImageArray addObject:[htmlUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    self.showLabel1.text = dateStr;
    self.showLabel2.text = reporter;
    self.showLabel3.text = loopholeTypeName;
    self.textField.text = loopholeAddress;
    self.textView.text = description;
    [self.manager addNetworkingImageToAlbum:baseImageArray selected:YES];
    [self.photoView refreshView];
    
}
#pragma mark ****************************** HTTP Server         ******************************
-(void)httpRequestFromServers:(NSString *)midStr{
    [SVProgressHUD show];
    NSDictionary * dic = @{@"mid":self.midString
                           };
    [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithPostBaseURL:BASE_HTTP_SERVER andMethond:@"/inspection/loophole/detail" andParams:dic andSuccessBlock:^(id  _Nonnull retValue) {
        NSLog(@"andSuccessBlock:%@",retValue);
        [SVProgressHUD dismiss];
        NSString *statusStr = [retValue safeObjectForKey:@"success"];
        if (statusStr.boolValue) {
            [self changeSubViewsStatues:[retValue safeObjectForKey:@"obj"]];
        }else{
            [SVProgressHUD showInfoWithStatus:[retValue safeObjectForKey:@"msg"]];
        }
    } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
        NSLog(@"andFailBlock:%@",error);
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
    }];
}
#pragma mark ****************************** getter and setter   ******************************
-(void)setBaseViewsData{
    if (self.isBeClosed) {
        self.commitBt.hidden = self.isBeClosed;
        self.showImageView.image = [UIImage imageNamed:@"处理状态-已关闭"];
        self.textField.enabled = NO;
        [self.textView setEditable:NO];
        self.photoView.showAddCell = NO;
        self.photoView.hideDeleteButton = YES;
    }else{
        self.commitBt.hidden = self.isBeClosed;
        self.showImageView.image = [UIImage imageNamed:@"处理状态-待处理"];
    }
}
- (void)setSubViewsProperty {
//    UIButton *backButton = [UIButton new];
//    backButton.frame = CGRectMake(10, kStatusBarHeight+3, 21.f, 23.f);
//    [backButton setBackgroundImage:[UIImage imageNamed:@"icon-返回箭头"] forState:UIControlStateNormal];//150610gai,home_status_back
//    [backButton addTarget:self action:@selector(navBackAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backButton];
//    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, kStatusBarHeight+5, 80, 25)];
//    nameLabel.backgroundColor= [UIColor clearColor];
//    nameLabel.font = [UIFont systemFontOfSize:19.f];
//    nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
//    nameLabel.textAlignment = NSTextAlignmentCenter;
//    nameLabel.text = @"详 情";
//    [self.view addSubview:nameLabel];
    self.view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    CGFloat width = self.mainPicView.frame.size.width;
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    CGFloat photoViewMargin = 12;
    photoView.frame = CGRectMake(photoViewMargin, photoViewMargin+40, width - photoViewMargin * 2, self.mainPicView.frame.size.height-60);
    photoView.lineCount = 5;
    photoView.delegate = self;
//    photoView.showAddCell = NO;
//    photoView.hideDeleteButton = YES;
    photoView.backgroundColor = [UIColor whiteColor];
    [self.mainPicView addSubview:photoView];
    self.photoView = photoView;
    
    self.textField.enabled = NO;
    [self.textView setEditable:NO];
    self.photoView.showAddCell = NO;
    self.photoView.hideDeleteButton = YES;
    
//    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"http://oss-cn-hangzhou.aliyuncs.com/tsnrhapp/shop/photos/857980fd0acd3caf9e258e42788e38f5_0.gif",@"http://tsnrhapp.oss-cn-hangzhou.aliyuncs.com/0034821a-6815-4d64-b0f2-09103d62630d.jpg",@"http://tsnrhapp.oss-cn-hangzhou.aliyuncs.com/0be5118d-f550-403e-8e5c-6d0badb53648.jpg",@"http://tsnrhapp.oss-cn-hangzhou.aliyuncs.com/1466408576222.jpg", nil];
//    [self.manager addNetworkingImageToAlbum:array selected:YES];
    [self.photoView refreshView];
}
- (HXPhotoManager *)manager
{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        //        _manager.openCamera = NO;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.photoMaxNum = 9; //
        _manager.configuration.videoMaxNum = 5;  //
        _manager.configuration.maxNum = 14;
    }
    return _manager;
}


@end

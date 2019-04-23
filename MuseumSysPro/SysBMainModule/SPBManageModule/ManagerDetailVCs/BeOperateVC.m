//
//  BeOperateVC.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/18.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "BeOperateVC.h"
#import "HXPhotoPicker.h"

@interface BeOperateVC ()<HXPhotoViewDelegate>{
    NSMutableArray *baseImageArray;//上报的现场图片
    NSMutableArray *baseImageArray2;//处理的图片留证
    NSMutableArray *solveimgArray;
}

@property (strong, nonatomic) HXPhotoManager *manager;
@property (weak, nonatomic) HXPhotoView *photoView;

@property (strong, nonatomic) HXPhotoManager *manager2;
@property (weak, nonatomic) HXPhotoView *photoView2;

@end

@implementation BeOperateVC

#pragma mark ****************************** life cycle          ******************************
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"详 情";
    baseImageArray = [[NSMutableArray alloc]initWithCapacity:10];
    baseImageArray2 = [[NSMutableArray alloc]initWithCapacity:10];
    solveimgArray = [[NSMutableArray alloc]initWithCapacity:10];
    [self setSubViewsProperty];
    if (self.midString) {
        [self httpRequestFromServers:self.midString];
    }
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
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT+600);
}
#pragma mark ****************************** System Delegate     ******************************

#pragma mark ****************************** Custom Delegate     ******************************

#pragma mark ****************************** event   Response    ******************************

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
//    NSString *dealState = [dataDic safeObjectForKey:@"dealState"];
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
            [baseImageArray addObject:htmlUrl];
        }
    }
    self.timeLabel1.text = dateStr;
    self.fNameLabel.text = reporter;
    self.faultKindLabel.text = loopholeTypeName;
    self.addressTextField.text = loopholeAddress;
    self.fTextView.text = description;
    [self.manager addNetworkingImageToAlbum:baseImageArray selected:YES];
    [self.photoView refreshView];
    //处理信息
    NSString *handler = [dataDic safeObjectForKey:@"handler"];
    NSString *instructions = [dataDic safeObjectForKey:@"instructions"];
    NSArray *solve_imgIds = [dataDic safeObjectForKey:@"solve_imgIds"];
    [baseImageArray2 removeAllObjects];
    if ([solve_imgIds isKindOfClass:[NSArray class]] && solve_imgIds.count) {
        for (NSDictionary *subDicd in solve_imgIds) {
            NSString *htmlUrl = [subDicd safeObjectForKey:@"htmlUrl"];
            [baseImageArray2 addObject:htmlUrl];
        }
    }
    self.cNameLabel.text = handler;
    self.sTextView.text = instructions;
    [self.manager2 addNetworkingImageToAlbum:baseImageArray2 selected:YES];
    [self.photoView2 refreshView];
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
- (void)setSubViewsProperty {
    self.view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    self.addressTextField.enabled = NO;
    [self.fTextView setEditable:NO];
    [self.sTextView setEditable:NO];
    CGFloat width = self.fPicBackView.frame.size.width;
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    CGFloat photoViewMargin = 12;
    photoView.frame = CGRectMake(photoViewMargin, photoViewMargin+40, width - photoViewMargin * 2, self.fPicBackView.frame.size.height-60);
    photoView.lineCount = 5;
    photoView.delegate = self;
    photoView.showAddCell = NO;
    photoView.hideDeleteButton = YES;
    photoView.backgroundColor = [UIColor whiteColor];
    [self.fPicBackView addSubview:photoView];
    self.photoView = photoView;
//    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"http://oss-cn-hangzhou.aliyuncs.com/tsnrhapp/shop/photos/857980fd0acd3caf9e258e42788e38f5_0.gif",@"http://tsnrhapp.oss-cn-hangzhou.aliyuncs.com/0034821a-6815-4d64-b0f2-09103d62630d.jpg",@"http://tsnrhapp.oss-cn-hangzhou.aliyuncs.com/0be5118d-f550-403e-8e5c-6d0badb53648.jpg",@"http://tsnrhapp.oss-cn-hangzhou.aliyuncs.com/1466408576222.jpg", nil];
//    [self.manager addNetworkingImageToAlbum:array selected:YES];
    [self.photoView refreshView];
    //================================
    HXPhotoView *photoView2 = [HXPhotoView photoManager:self.manager2];
    photoView2.frame = CGRectMake(photoViewMargin, photoViewMargin+40, width - photoViewMargin * 2, self.sPicBackView.frame.size.height-60);
    photoView2.lineCount = 5;
    photoView2.delegate = self;
    photoView2.showAddCell = NO;
    photoView2.hideDeleteButton = YES;
    photoView2.backgroundColor = [UIColor whiteColor];
    [self.sPicBackView addSubview:photoView2];
    self.photoView2 = photoView2;
//    NSMutableArray *array2 = [NSMutableArray arrayWithObjects:@"http://oss-cn-hangzhou.aliyuncs.com/tsnrhapp/shop/photos/857980fd0acd3caf9e258e42788e38f5_0.gif",@"http://tsnrhapp.oss-cn-hangzhou.aliyuncs.com/0034821a-6815-4d64-b0f2-09103d62630d.jpg",@"http://tsnrhapp.oss-cn-hangzhou.aliyuncs.com/0be5118d-f550-403e-8e5c-6d0badb53648.jpg",@"http://tsnrhapp.oss-cn-hangzhou.aliyuncs.com/1466408576222.jpg", nil];
//    [self.manager2 addNetworkingImageToAlbum:array2 selected:YES];
    [self.photoView2 refreshView];
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
- (HXPhotoManager *)manager2
{
    if (!_manager2) {
        _manager2 = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        //        _manager.openCamera = NO;
        _manager2.configuration.saveSystemAblum = YES;
        _manager2.configuration.photoMaxNum = 9; //
        _manager2.configuration.videoMaxNum = 5;  //
        _manager2.configuration.maxNum = 14;
    }
    return _manager2;
}
@end

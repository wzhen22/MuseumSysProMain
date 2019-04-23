//
//  ReportFaultVC.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/15.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "ReportFaultVC.h"
#import "HXPhotoPicker.h"
#import "HQMUploadRequest.h"
#import "AlertPublishSView.h"

static const CGFloat kPhotoViewMargin = 12.0;

@interface ReportFaultVC ()<YWAlertViewDelegate,HXPhotoViewDelegate>{
    
}
@property(nonatomic,strong) AlertPublishSView *alertPublishSView ;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (weak, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (strong, nonatomic) NSMutableArray *mPhotoImages;//相册选择的数组
@property (strong, nonatomic) NSMutableArray *mPicMidArray;//上传成功后保存图片主键
@property (strong, nonatomic) NSArray *faultDicType;
@property (strong, nonatomic) NSString *currentFaultType;
@end

@implementation ReportFaultVC
#pragma mark ****************************** life cycle          ******************************
-(void)viewDidLoad{
    [super viewDidLoad];
    self.mPhotoImages = [[NSMutableArray alloc]initWithCapacity:10];
    self.mPicMidArray = [[NSMutableArray alloc]initWithCapacity:10];
    self.currentFaultType = @"1";
    self.title = @"安全隐患上报";
    self.view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    [self setSubViewsProperty];
    [self httpRequestFromServers];
    //添加响应手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mainTapGestureClick)];
    [self.middleView addGestureRecognizer:tapGesture];
}
-(void) mainTapGestureClick{
    [self.faultAddressField resignFirstResponder];
    [self.faultTextView resignFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:19],NSFontAttributeName, nil];
    self.navigationController.navigationBar.translucent = NO;
//    self.view.frame = CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kNavBarAndStatusBarHeight);
//    self.fMainViewTop.constant = 10;
    NSLog(@"%@AND:%@",self.view,self.fMainView);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.view.frame = CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kNavBarAndStatusBarHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ****************************** System Delegate     ******************************

#pragma mark ****************************** Custom Delegate     ******************************
- (void)didClickAlertView:(NSInteger)buttonIndex value:(id)value{
    NSLog(@"委托代理=当前点击--%zi",buttonIndex);
    switch (buttonIndex) {
        case 0:{
            //走取消流程
            break;
        }
        default:{
            [self.faultKindBt setTitle:value forState:UIControlStateNormal];
            if ([self.faultDicType isKindOfClass:[NSArray class]] && self.faultDicType.count) {
                NSDictionary *fDic = [self.faultDicType objectAtIndex:(buttonIndex-1)];
                self.currentFaultType = [NSString stringWithFormat:@"%@",[fDic safeObjectForKey:@"code"]];
            }
            break;
        }
    }
}
-(void)photoListViewControllerDidDone:(HXPhotoView *)photoView allList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal{
    NSLog(@"allList:%@",allList);
}
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    NSSLog(@"所有:%ld - 照片:%ld - 视频:%ld",allList.count,photos.count,videos.count);
//    HXPhotoModel *photeModel = [photos lastObject];
    [self.mPhotoImages removeAllObjects];
    __weak typeof(self) weakSelf = self;
    for (HXPhotoModel *photeModel in photos) {
        NSLog(@"photeModel.fileURL:%@",photeModel.fileURL);
        [[PHImageManager defaultManager] requestImageDataForAsset:photeModel.asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            NSData *data = [NSData dataWithData:imageData];
            UIImage *image = [UIImage imageWithData:data]; // 取得图片
            [weakSelf.mPhotoImages addObject:image];
        }];
        
//        NSData *data = [NSData dataWithContentsOfFile:photeModel.fileURL.absoluteString];
//        UIImage *image = [UIImage imageWithData:data]; // 取得图片
//        [mPhotoImages addObject:image];
    }
//    UIImage *urlImage = [UIImage ]
    
    //    [self.toolManager writeSelectModelListToTempPathWithList:allList requestType:0 success:^(NSArray<NSURL *> *allURL, NSArray<NSURL *> *photoURL, NSArray<NSURL *> *videoURL) {
    //        NSSLog(@"%@",allURL);
    //    } failed:^{
    //
    //    }];
    
    
    //    [self.view showLoadingHUDText:nil];
    //    __weak typeof(self) weakSelf = self;
    //    [self.toolManager getSelectedImageList:allList success:^(NSArray<UIImage *> *imageList) {
    //        [weakSelf.view handleLoading];
    //        NSSLog(@"%@",imageList);
    //    } failed:^{
    //        [weakSelf.view handleLoading];
    //    }];
}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame
{
    NSSLog(@"%@",NSStringFromCGRect(frame));
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
}
#pragma mark ****************************** event   Response    ******************************

- (IBAction)publishBtClick:(id)sender {
    if (!self.faultAddressField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"隐患地址不能为空"];
        return;
    }
    if (!self.faultTextView.text.length) {
        [SVProgressHUD showInfoWithStatus:@"隐患内容不能为空"];
        return;
    }
    if (self.mPhotoImages.count) {
        //    UIImage *img1 = [UIImage imageNamed:@"qidong@2x.png"];
        //    UIImage *img2 = [UIImage imageNamed:@"qidong@2x.png"];
        //    NSArray<UIImage *> *images = [NSArray arrayWithObjects:img1, img2, nil];
        @weakify(self);
        HQMUploadRequest *req = [[HQMUploadRequest alloc] init];
        [req startUploadTaskWithSuccess:^(NSInteger errCode, NSDictionary *responseDict, id model) {
            DLog(@"errCode:%ld---dict:%@---model:%@", errCode, responseDict, model);
            @strongify(self);
            NSArray *upArray = [responseDict safeObjectForKey:@"obj"];
            if ([upArray isKindOfClass:[NSArray class]]&&upArray.count) {
                [self.mPicMidArray removeAllObjects];
                for (NSDictionary *dic in upArray) {
                    NSString *midString = [dic safeObjectForKey:@"mid"];
                    [self.mPicMidArray addObject:midString];
                }
            }
            [self upHttpRequest];
//            [SVProgressHUD showImage:[UIImage imageNamed:@"112.jpg"] status:@"图片上传成功"];
        } failure:^(NSError *error) {
            DLog(@"error:%@", error.localizedFailureReason);
        } uploadProgress:^(NSProgress *progress) {
            DLog(@"progress:%lld,%lld,%f", progress.totalUnitCount, progress.completedUnitCount, progress.fractionCompleted);
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                @strongify(self);
                
            });
        }];
        req.showHUD = YES;
        req.images = self.mPhotoImages;
        [req startRequest];
    }else{
        //直接走上传表单流程
        [self upHttpRequest];
    }

}
-(void) tapGestureClick{
    DLog(@"");
    [self mainTapGestureClick];
    [self sheet_no_msg];
}
- (void)sheet_no_msg{
    NSArray *titlesArray = @[@"展厅灯未关闭",@"展厅门未关闭",@"空调未关闭",@"烤火炉未关闭"];
    if ([self.faultDicType isKindOfClass:[NSArray class]] && self.faultDicType.count) {
        NSMutableArray *muAFF= [[NSMutableArray alloc]initWithCapacity:10];
        for (NSDictionary *dic in self.faultDicType) {
            NSString *name = [dic safeObjectForKey:@"name"];
            [muAFF addObject:name];
        }
        NSDictionary *fDic = [self.faultDicType objectAtIndex:0];
        self.currentFaultType = [NSString stringWithFormat:@"%@",[fDic safeObjectForKey:@"code"]];
        titlesArray = muAFF;
    }
   
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"隐患类型" message:nil delegate:self preferredStyle:YWAlertViewStyleActionSheet footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"取消" otherButtonTitles:titlesArray];
    [alert setMessageTitleColor:[UIColor redColor]];
    [alert show];
}
#pragma mark ****************************** private Methods     ******************************
-(void) showSuccessView{
    self.alertPublishSView = nil;
    __weak typeof(self) weakSelf = self;
    self.alertPublishSView.dissViewBlock = ^(id  _Nonnull obj) {
        [weakSelf navBackAction];
//        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:self.alertPublishSView];
}
#pragma mark ****************************** HTTP Server         ******************************
-(void)upHttpRequest{
    if (!self.faultAddressField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"隐患地址不能为空"];
        return;
    }
    if (!self.faultTextView.text.length) {
        [SVProgressHUD showInfoWithStatus:@"隐患内容不能为空"];
        return;
    }
    [SVProgressHUD show];
//    __weak typeof(self) weakSelf = self;
    NSString *imageIdString;
    if (self.mPicMidArray.count) {
        imageIdString = [self.mPicMidArray componentsJoinedByString:@","];
    }else{
        imageIdString = @"";
    }
    NSString *dateStr = [SwTools dateToString:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDictionary * dic = @{@"loopholeType":self.currentFaultType,
                           @"loopholeAddress":self.faultAddressField.text,
                           @"description":self.faultTextView.text,
                           @"reportTime":dateStr,
                           @"loophole_imgId":imageIdString
                           };
    [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithPostBaseURL:BASE_HTTP_SERVER andMethond:@"/inspection/loophole/add" andParams:dic andSuccessBlock:^(id  _Nonnull retValue) {
        NSLog(@"andSuccessBlock:%@",retValue);
        [SVProgressHUD dismiss];
        NSString *statusStr = [retValue safeObjectForKey:@"success"];
        if (statusStr.boolValue) {
            [self showSuccessView];
        }else{
            [SVProgressHUD showInfoWithStatus:[retValue safeObjectForKey:@"msg"]];
        }
    } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
        NSLog(@"andFailBlock:%@",error);
        [SVProgressHUD showErrorWithStatus:@"提交失败"];
    }];
}
-(void)httpRequestFromServers{
    __weak typeof(self) weakSelf = self;
    NSDictionary * dic = @{};
    [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithPostBaseURL:BASE_HTTP_SERVER andMethond:@"/inspection/loophole/getLoopholeType" andParams:dic andSuccessBlock:^(id  _Nonnull retValue) {
        NSLog(@"andSuccessBlock:%@",retValue);
        NSString *statusStr = [retValue safeObjectForKey:@"success"];
        if (statusStr.boolValue) {
            weakSelf.faultDicType = [retValue safeObjectForKey:@"obj"];
            if ([self.faultDicType isKindOfClass:[NSArray class]] && self.faultDicType.count) {
                NSDictionary *fDic = [self.faultDicType objectAtIndex:0];
                self.currentFaultType = [NSString stringWithFormat:@"%@",[fDic safeObjectForKey:@"code"]];
                [weakSelf.faultKindBt setTitle:[fDic safeObjectForKey:@"name"] forState:UIControlStateNormal];
            }
            
        }else{
            
        }
    } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
        NSLog(@"andFailBlock:%@",error);
    }];
}
#pragma mark ****************************** getter and setter   ******************************

- (void)setSubViewsProperty {
    //添加响应手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick)];
    [self.fMainView addGestureRecognizer:tapGesture];
    //
    self.faultKindBt.enabled = NO;
//    self.automaticallyAdjustsScrollViewInsets = YES;
    CGFloat width = self.picSuperView.frame.size.width;
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(kPhotoViewMargin, kPhotoViewMargin+40, width - kPhotoViewMargin * 2, self.picSuperView.frame.size.height-60);
    photoView.lineCount = 5;
    photoView.delegate = self;
//    photoView.showAddCell = NO;
    photoView.backgroundColor = [UIColor whiteColor];
    self.picSuperView.userInteractionEnabled = YES;
    [self.picSuperView addSubview:photoView];
    self.photoView = photoView;
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
- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}
- (AlertPublishSView *)alertPublishSView {
    if (!_alertPublishSView) {
        AlertPublishSView *secView = [AlertPublishSView loadView];
        _alertPublishSView = secView;
    }
    return _alertPublishSView;
}
@end

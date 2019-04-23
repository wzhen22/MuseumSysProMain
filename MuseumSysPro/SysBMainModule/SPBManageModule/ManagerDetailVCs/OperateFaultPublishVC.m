//
//  OperateFaultPublishVC.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/18.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "OperateFaultPublishVC.h"
#import "HXPhotoPicker.h"
#import "HQMUploadRequest.h"

@interface OperateFaultPublishVC ()<HXPhotoViewDelegate>

@property (strong, nonatomic) HXPhotoManager *manager;
@property (weak, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (strong, nonatomic) NSMutableArray *mPhotoImages;//相册选择的数组
@property (strong, nonatomic) NSMutableArray *mPicMidArray;//上传成功后保存图片主键

@end

@implementation OperateFaultPublishVC

#pragma mark ****************************** life cycle          ******************************
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"隐患处理报告";
    [self setSubViewsProperty];
    self.mPhotoImages = [[NSMutableArray alloc]initWithCapacity:10];
    self.mPicMidArray = [[NSMutableArray alloc]initWithCapacity:10];
    //添加响应手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mainTapGestureClick)];
    [self.fbackView addGestureRecognizer:tapGesture];
}
-(void) mainTapGestureClick{
    [self.mainTextView resignFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:19],NSFontAttributeName, nil];
    self.navigationController.navigationBar.translucent = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    [self.mPhotoImages removeAllObjects];
    __weak typeof(self) weakSelf = self;
    for (HXPhotoModel *photeModel in photos) {
        NSLog(@"photeModel.fileURL:%@",photeModel.fileURL);
        [[PHImageManager defaultManager] requestImageDataForAsset:photeModel.asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            NSData *data = [NSData dataWithData:imageData];
            UIImage *image = [UIImage imageWithData:data]; // 取得图片
            [weakSelf.mPhotoImages addObject:image];
        }];
    }
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

- (IBAction)commitBtClick:(id)sender {
    if (self.mPhotoImages.count) {
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
#pragma mark ****************************** private Methods     ******************************

#pragma mark ****************************** HTTP Server         ******************************
-(void)upHttpRequest{
    if (!self.mainTextView.text.length) {
        [SVProgressHUD showInfoWithStatus:@"处理记录不能为空"];
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
    NSDictionary * dic = @{@"mid":self.midString?self.midString:@"0",
                           @"instructions":self.mainTextView.text,
                           @"handerTime":dateStr,
                           @"solve_imgId":imageIdString
                           };
    [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithPostBaseURL:BASE_HTTP_SERVER andMethond:@"/inspection/loophole/solve" andParams:dic andSuccessBlock:^(id  _Nonnull retValue) {
        NSLog(@"andSuccessBlock:%@",retValue);
        [SVProgressHUD dismiss];
        NSString *statusStr = [retValue safeObjectForKey:@"success"];
        if (statusStr.boolValue) {
            [SVProgressHUD showSuccessWithStatus:@"处理记录上报成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
//            [self navBackAction];
        }else{
            [SVProgressHUD showInfoWithStatus:[retValue safeObjectForKey:@"msg"]];
        }
        
    } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
        NSLog(@"andFailBlock:%@",error);
        [SVProgressHUD showErrorWithStatus:@"提交失败"];
    }];
}
#pragma mark ****************************** getter and setter   ******************************
- (void)setSubViewsProperty {
    self.view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    CGFloat width = self.picBackView.frame.size.width;
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    CGFloat photoViewMargin = 12;
    photoView.frame = CGRectMake(photoViewMargin, photoViewMargin+40, width - photoViewMargin * 2, self.picBackView.frame.size.height-60);
    photoView.lineCount = 5;
    photoView.delegate = self;
    //        photoView.showAddCell = NO;
    photoView.backgroundColor = [UIColor whiteColor];
    [self.picBackView addSubview:photoView];
    self.photoView = photoView;
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
@end

//
//  ReportFaultView.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/17.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "ReportFaultView.h"

@interface ReportFaultView ()<YWAlertViewDelegate>

@end

@implementation ReportFaultView
#pragma mark ****************************** life cycle          ******************************
+(instancetype)loadView
{
    return  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setSubViewsProperty];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setSubViewsProperty];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViewsProperty];
    }
    return self;
}
-(void)dealloc{
#ifdef DEBUG
    NSLog(@"Dealloc %@",self);
#endif
}

#pragma mark ****************************** System Delegate     ******************************

#pragma mark ****************************** Custom Delegate     ******************************
- (void)didClickAlertView:(NSInteger)buttonIndex value:(id)value{
    NSLog(@"委托代理=当前点击--%zi",buttonIndex);
    if (buttonIndex == 0){
        [self removeFromSuperview];
    }
}
#pragma mark ****************************** event   Response    ******************************
-(void) tapGestureClick{
    [self.textView resignFirstResponder];
//    [self removeFromSuperview];
    [self alert_not_title];
}
-(void) tapGestureClick1{
    [self.textView resignFirstResponder];
}

- (IBAction)sureBtClick:(id)sender {
    [self httpRequestFromServers];
//    if (self.showViewBlock) {
//        [self removeFromSuperview];
//        self.showViewBlock();
//    }
}
#pragma mark ****************************** private Methods     ******************************
- (void)alert_not_title{
    
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:nil message:@"是否放弃提交报告" delegate:self preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"放弃" otherButtonTitles:@[@"再等等"]];
    [alert setButtionTitleFontWithName:@"AmericanTypewriter" size:16 index:1];
    [alert setButtionTitleFontWithName:@"AmericanTypewriter-Bold" size:16 index:0];
    
    [alert show];
}

#pragma mark ****************************** HTTP Server         ******************************
-(void)httpRequestFromServers{
    [SVProgressHUD show];
    NSString *dateStr = [SwTools dateToString:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDictionary * dic = @{@"inspectTime":dateStr,
                           @"emsi":@"",
                           @"deviceId":self.deviceId,
                           @"remaining_electricity":self.remaining_electricity,
                           @"report":self.textView.text
                           };
    [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithPostBaseURL:BASE_HTTP_SERVER andMethond:@"/inspection/record/report" andParams:dic andSuccessBlock:^(id  _Nonnull retValue) {
        NSLog(@"andSuccessBlock:%@",retValue);
        [SVProgressHUD dismiss];
        NSString *statusStr = [retValue safeObjectForKey:@"success"];
        NSLog(@"statusStr:%d",statusStr.boolValue);
        if (statusStr.boolValue) {
            [self removeFromSuperview];
            if (self.showViewBlock) {
                self.showViewBlock();
            }
//            [SVProgressHUD showSuccessWithStatus:[retValue safeObjectForKey:@"msg"]];
        }else{
            [SVProgressHUD showInfoWithStatus:[retValue safeObjectForKey:@"msg"]];
        }
    } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
        NSLog(@"andFailBlock:%@",error);
        [SVProgressHUD showErrorWithStatus:@"提交失败"];
    }];
}
#pragma mark ****************************** getter and setter   ******************************
- (void)setSubViewsProperty{
    //添加响应手势
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor clearColor];
    self.BackBaseView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick1)];
    [self.mainBackView addGestureRecognizer:tapGesture1];
}


@end

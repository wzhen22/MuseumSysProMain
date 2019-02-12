//
//  SPBResetPasswordVC.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/10.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SPBResetPasswordVC.h"

@interface SPBResetPasswordVC ()

@end

@implementation SPBResetPasswordVC

#pragma mark ****************************** life cycle          ******************************
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    
    [self.getNumBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.getNumBt setTitle:@"  获取验证码  " forState:UIControlStateNormal];
    self.getNumBt.titleLabel.font = [UIFont systemFontOfSize:12];
    self.getNumBt.layer.cornerRadius = 10.f;
    self.getNumBt.backgroundColor = [UIColor colorWithHexString:@"ff8e14"];
    
    [self.commitBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.commitBt setTitle:@"提交" forState:UIControlStateNormal];
    self.commitBt.layer.cornerRadius = 10.f;
    self.commitBt.backgroundColor = [UIColor colorWithHexString:@"148aff"];
    //添加响应手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mainTapGestureClick)];
    [self.view addGestureRecognizer:tapGesture];
}
-(void) mainTapGestureClick{
    [self.fTextField resignFirstResponder];
    [self.sTextField resignFirstResponder];
    [self.sTextField resignFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:19],NSFontAttributeName, nil];
//    self.navigationController.navigationBar.subviews.firstObject.alpha = 0.0;
//    UIView * barBackground = self.navigationController.navigationBar.subviews.firstObject;
//    if (@available(iOS 11.0, *))
//    {
//        [barBackground.subviews setValue:@(0) forKeyPath:@"alpha"];
//    } else {
//        barBackground.alpha = 0;
//    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:19],NSFontAttributeName, nil];
//    self.navigationController.navigationBar.subviews.firstObject.alpha = 1.0;
//    UIView * barBackground = self.navigationController.navigationBar.subviews.firstObject;
//    if (@available(iOS 11.0, *))
//    {
//        [barBackground.subviews setValue:@(1) forKeyPath:@"alpha"];
//    } else {
//        barBackground.alpha = 1;
//    }
    
}

#pragma mark ****************************** System Delegate     ******************************

#pragma mark ****************************** Custom Delegate     ******************************

#pragma mark ****************************** event   Response    ******************************

- (IBAction)getNumBtClick:(id)sender {
    NSString *mobileStr = [SysPubSingleThings getUserName];
    if (mobileStr.length<5) {
        [SVProgressHUD showInfoWithStatus:@"您从未登录过，不支持重置密码！"];
        return;
    }
    //获取验证码
    [SVProgressHUD showWithStatus:@"正在获取"];
    NSDictionary * dic = @{@"mobile":[SysPubSingleThings getUserName]};
    [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithGetBaseURL:BASE_HTTP_SERVER andMethond:@"/password/random" andParams:dic andSuccessBlock:^(id  _Nonnull retValue) {
        NSLog(@"andSuccessBlock:%@",retValue);
        [SVProgressHUD showInfoWithStatus:[retValue safeObjectForKey:@"msg"]];
    } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
        NSLog(@"andFailBlock:%@",error);
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}
- (IBAction)summitBtClick:(id)sender {
    [SVProgressHUD show];
    NSDictionary * dic = @{@"phoneCode":self.fTextField.text,
                           @"newPassword":self.tTextField.text
                           };
    [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithPostBaseURL:BASE_HTTP_SERVER andMethond:@"/password/edit" andParams:dic andSuccessBlock:^(id  _Nonnull retValue) {
        NSLog(@"andSuccessBlock:%@",retValue);
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:[retValue safeObjectForKey:@"msg"]];
        NSString *statusStr = [retValue safeObjectForKey:@"success"];
        NSLog(@"statusStr:%d",statusStr.boolValue);
        if (statusStr.boolValue) {
            [self navBackAction];
        }else{
        }
    } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
        NSLog(@"andFailBlock:%@",error);
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}
#pragma mark ****************************** private Methods     ******************************

#pragma mark ****************************** HTTP Server         ******************************

#pragma mark ****************************** getter and setter   ******************************
@end

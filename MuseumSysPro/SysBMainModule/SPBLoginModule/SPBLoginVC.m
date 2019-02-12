//
//  SPBLoginVC.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/10.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SPBLoginVC.h"
#import "SPBResetPasswordVC.h"

@interface SPBLoginVC ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation SPBLoginVC

#pragma mark ****************************** life cycle          ******************************
-(void)viewDidLoad{
    [super viewDidLoad];
    // 设置导航控制器的代理为self
//    self.navigationController.delegate = self;
    UIButton *backButton = [UIButton new];
    backButton.frame = CGRectMake(20, kStatusBarHeight, 23.f, 23.f);
    [backButton setBackgroundImage:[UIImage imageNamed:@"icon-返回箭头"] forState:UIControlStateNormal];//150610gai,home_status_back
    [backButton addTarget:self action:@selector(navBackAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backButton];
    //
    [self setBaseViewDate];
    //添加响应手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mainTapGestureClick)];
    [self.view addGestureRecognizer:tapGesture];
}
-(void) mainTapGestureClick{
    [self.fSubTextfield resignFirstResponder];
    [self.SSubTextfield resignFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController) {
        self.navigationController.delegate = self;
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.navigationController) {
        self.navigationController.delegate = nil;
    }
}
- (void)dealloc {
    self.navigationController.delegate = nil;
}
#pragma mark ****************************** System Delegate     ******************************
#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:NO];
}
#pragma mark ****************************** Custom Delegate     ******************************

#pragma mark ****************************** event   Response    ******************************

- (IBAction)findPasswordBtClick:(id)sender {
    SPBResetPasswordVC *sVC = [[SPBResetPasswordVC alloc]init];
    sVC.title = @"找回密码";
    [self.navigationController pushViewController:sVC animated:YES];
}
- (IBAction)loginBtClick:(id)sender {
    [self httpRequestFromServers];
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
#pragma mark ****************************** HTTP Server         ******************************
-(void)httpRequestFromServers{
//    NSString *login = @"15826291996";
//    NSString *ste = @"123456";
    [SVProgressHUD showWithStatus:@"正在登录"];
    NSString *login = self.fSubTextfield.text;
    NSString *ste = self.SSubTextfield.text;
    NSString *passStr = [SwTools encodeMD5:ste];
    NSLog(@"%@",[SwTools encodeMD5:ste]);
    NSDictionary * dic = @{
                           @"loginname":login,
                           @"password":passStr};
    [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithPostBaseURL:BASE_HTTP_SERVER andMethond:@"/login" andParams:dic andSuccessBlock:^(id  _Nonnull retValue) {
//        NSLog(@"andSuccessBlock:%@",retValue);
        NSString *statusStr = [retValue safeObjectForKey:@"success"];
         NSLog(@"statusStr:%d",statusStr.boolValue);
        if (statusStr.boolValue) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [SysPubSingleThings sharePublicSingle].loginDic =  [retValue safeObjectForKey:@"obj"];
        }else{
            [SVProgressHUD showInfoWithStatus:[retValue safeObjectForKey:@"msg"]];
            [SysPubSingleThings saveLoginStatus:NO];
            return ;
        }
        [SysPubSingleThings saveLoginStatus:YES];
        [SysPubSingleThings saveUserNameAndPwd:self.fSubTextfield.text andPwd:self.SSubTextfield.text];
        [self navBackAction];
    } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
//        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        [SysPubSingleThings saveLoginStatus:NO];
        NSLog(@"andFailBlock:%@",error);
    }];
}
#pragma mark ****************************** getter and setter   ******************************
-(void)setBaseViewDate{
    self.fMainView.backgroundColor =[[UIColor whiteColor] colorWithAlphaComponent:0.5];
    self.fMainView.layer.cornerRadius = 6.f;
    self.SMainView.backgroundColor =[[UIColor whiteColor] colorWithAlphaComponent:0.5];
    self.SMainView.layer.cornerRadius = 6.f;
    self.fSubLineView.backgroundColor = [UIColor whiteColor];
    self.SSubLineView.backgroundColor = [UIColor whiteColor];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"忘记密码？"];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [self.FindPasswordBt setAttributedTitle:title
                      forState:UIControlStateNormal];
    [self.FindPasswordBt setBackgroundColor:[UIColor clearColor]];
    [self.FindPasswordBt.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.FindPasswordBt.titleLabel.textColor = [UIColor whiteColor];
    
    self.fSubTextfield.backgroundColor = [UIColor clearColor];
    self.SSubTextfield.backgroundColor = [UIColor clearColor];
    
    self.loginBt.backgroundColor = [UIColor whiteColor];
    [self.loginBt setTitleColor:[UIColor colorWithHexString:@"148aff"] forState:UIControlStateNormal];
    [self.loginBt setTitle:@"登 录" forState:UIControlStateNormal];
    self.loginBt.layer.cornerRadius = 6.f;
}
@end

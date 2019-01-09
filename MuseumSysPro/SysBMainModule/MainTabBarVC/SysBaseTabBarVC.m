//
//  SysBaseTabBarVC.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SysBaseTabBarVC.h"

@interface SysBaseTabBarVC ()

@end

@implementation SysBaseTabBarVC

#pragma mark ****************************** life cycle          ******************************
-(instancetype)init{
    self = [super init];
    if (self) {
        self.delegate = self;
        [self setChildViewControllers];
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
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
#pragma mark UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
}
#pragma mark ****************************** Custom Delegate     ******************************

#pragma mark ****************************** event   Response    ******************************

#pragma mark ****************************** private Methods     ******************************
/**
 * 初始化所有的子控制器
 */
-(void) setChildViewControllers{
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"777777"], NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:13],NSFontAttributeName,nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"148aff"], NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:13],NSFontAttributeName,nil] forState:UIControlStateSelected];
    
    self.checkHomeVC  = [[SPBCheckHomeVC alloc]init];
    self.checkHomeVC.title = @"寻更巡检";
    [self setupOneChildViewController:_checkHomeVC title:@"寻更巡检" image:@"01-巡检巡更-normal" selectedImage:@"01-巡检巡更-active"];
    
    self.manageHomeVC = [[SPBManageHomeVC alloc]init];
    self.manageHomeVC.title = @"安全管理";
    [self setupOneChildViewController:self.manageHomeVC title:@"安全管理" image:@"02-安全管理-normal" selectedImage:@"02-安全管理-active"];
    
    self.signInVC = [SPBSIgnInHomeVC new];
    self.signInVC.title = @"移动考勤";
    [self setupOneChildViewController:self.signInVC title:@"移动考勤" image:@"03-移动考勤-normal" selectedImage:@"03-移动考勤-active"];
    
    self.userCenterVC = [[SPBUserCenterVC alloc]init];
    self.userCenterVC.title = @"个人中心";
    [self setupOneChildViewController:self.userCenterVC title:@"个人中心" image:@"04-个人中心-norma" selectedImage:@"04-个人中心-active"];
}

#pragma mark ****************************** private Methods     ******************************
- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:[[SgdBaseNavigationController  alloc] initWithRootViewController:vc]];
}
#pragma mark ****************************** HTTP Server         ******************************

#pragma mark ****************************** getter and setter   ******************************

@end

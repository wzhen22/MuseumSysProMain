//
//  SgdBaseNavigationController.m
//  ARCapacityPro
//
//  Created by 王臻 on 2018/1/18.
//  Copyright © 2018年 sgd. All rights reserved.
//

#import "SgdBaseNavigationController.h"

@interface SgdBaseNavigationController ()

@end

@implementation SgdBaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏字体
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:19],NSFontAttributeName, nil];//[UIFont fontWithName:@"Marion-Italic" size:20.0],NSFontAttributeName,
//    UIColor *bColor = [UIColor colorWithHexString:@"#ffffff"];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:bColor] forBarMetrics:UIBarMetricsDefault];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        //第二级则隐藏底部Tab
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

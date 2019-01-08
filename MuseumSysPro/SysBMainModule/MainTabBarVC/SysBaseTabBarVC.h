//
//  SysBaseTabBarVC.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPBUserCenterVC.h"
#import "SPBSIgnInHomeVC.h"
#import "SPBManageHomeVC.h"
#import "SPBCheckHomeVC.h"

#import "SgdBaseNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SysBaseTabBarVC : UITabBarController <UITabBarControllerDelegate,UITabBarDelegate>

@property(nonatomic,strong) SPBUserCenterVC *userCenterVC;
@property(nonatomic,strong) SPBSIgnInHomeVC *signInVC;
@property(nonatomic,strong) SPBManageHomeVC *manageHomeVC;
@property(nonatomic,strong) SPBCheckHomeVC *checkHomeVC;

@end

NS_ASSUME_NONNULL_END

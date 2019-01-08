//
//  SysPBaseViewController.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SysPBaseViewController : UIViewController

- (void)navBackAction;
- (void)hideTabBar;
- (void)showTabBar;

-(void) resetBodySize;

@end

NS_ASSUME_NONNULL_END

//
//  SubManagerDetailVC.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/11.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SysPBaseViewController.h"
#import "JXCategoryListContainerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubManagerDetailVC : SysPBaseViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, strong) UINavigationController *naviController;
@property (nonatomic,assign) NSInteger currentInt;
@end

NS_ASSUME_NONNULL_END

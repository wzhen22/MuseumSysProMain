//
//  StatisticsDetailVC.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/28.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SysPBaseViewController.h"
#import "JXCategoryListContainerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatisticsDetailVC : SysPBaseViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, strong) UINavigationController *naviController;
@property (nonatomic,assign) NSInteger currentInt;

@end

NS_ASSUME_NONNULL_END

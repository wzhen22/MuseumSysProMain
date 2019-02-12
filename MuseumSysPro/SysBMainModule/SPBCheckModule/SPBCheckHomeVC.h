//
//  SPBCheckHomeVC.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeaconManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPBCheckHomeVC : UIViewController
//顶部子视图
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *reportBt;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
//中部子视图
@property (weak, nonatomic) IBOutlet UIButton *leftShowView1;
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UIView *subCircleView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *showBeaconLabel;

//底部子视图
@property (weak, nonatomic) IBOutlet UIButton *leftShowView2;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;

@end

NS_ASSUME_NONNULL_END

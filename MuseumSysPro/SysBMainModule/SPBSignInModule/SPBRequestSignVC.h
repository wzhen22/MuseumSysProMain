//
//  SPBRequestSignVC.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/17.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SysPBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPBRequestSignVC : SysPBaseViewController
@property (weak, nonatomic) IBOutlet UIView *FchooseView;
@property (weak, nonatomic) IBOutlet UIView *SchooseView;
@property (weak, nonatomic) IBOutlet UIButton *UptimeBt;
@property (weak, nonatomic) IBOutlet UIButton *DownTimeBt;
@property (weak, nonatomic) IBOutlet UITextView *mainTextView;
@property (weak, nonatomic) IBOutlet UIButton *publishBt;
@property (nonatomic,strong) NSString *selectDateStr;
@end

NS_ASSUME_NONNULL_END

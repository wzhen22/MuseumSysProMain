//
//  ReportFaultVC.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/15.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SysPBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReportFaultVC : SysPBaseViewController
@property (weak, nonatomic) IBOutlet UIView *fMainView;
@property (weak, nonatomic) IBOutlet UIButton *faultKindBt;
@property (weak, nonatomic) IBOutlet UITextField *faultAddressField;
@property (weak, nonatomic) IBOutlet UITextView *faultTextView;
@property (weak, nonatomic) IBOutlet UIView *picSuperView;
@property (weak, nonatomic) IBOutlet UIButton *publishBt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fMainViewTop;
@property (weak, nonatomic) IBOutlet UIView *middleView;

@end

NS_ASSUME_NONNULL_END

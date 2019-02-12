//
//  BeOperateVC.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/18.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SysPBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BeOperateVC : SysPBaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *faultKindLabel;
@property (weak, nonatomic) IBOutlet UIImageView *showOperateImageView;
@property (weak, nonatomic) IBOutlet UILabel *fNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextView *fTextView;
@property (weak, nonatomic) IBOutlet UIView *fPicBackView;
@property (weak, nonatomic) IBOutlet UILabel *cNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *sTextView;
@property (weak, nonatomic) IBOutlet UIView *sPicBackView;
@property (nonatomic,strong) NSString *midString;

@end

NS_ASSUME_NONNULL_END

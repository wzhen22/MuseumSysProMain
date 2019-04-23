//
//  SPBLoginVC.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/10.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SysPBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LoginResult)(UIViewController *cViewC);

@interface SPBLoginVC : SysPBaseViewController
@property (weak, nonatomic) IBOutlet UIView *fMainView;
@property (weak, nonatomic) IBOutlet UIImageView *fSubImageVIew;
@property (weak, nonatomic) IBOutlet UITextField *fSubTextfield;
@property (weak, nonatomic) IBOutlet UIView *fSubLineView;
@property (weak, nonatomic) IBOutlet UIView *SMainView;
@property (weak, nonatomic) IBOutlet UIImageView *SSubImageView;
@property (weak, nonatomic) IBOutlet UITextField *SSubTextfield;
@property (weak, nonatomic) IBOutlet UIView *SSubLineView;
@property (weak, nonatomic) IBOutlet UIButton *FindPasswordBt;
@property (weak, nonatomic) IBOutlet UIButton *loginBt;
@property (nonatomic, copy) LoginResult loginResult;
@end

NS_ASSUME_NONNULL_END

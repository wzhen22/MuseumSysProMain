//
//  SPBResetPasswordVC.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/10.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SysPBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPBResetPasswordVC : SysPBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *fTextField;
@property (weak, nonatomic) IBOutlet UITextField *sTextField;
@property (weak, nonatomic) IBOutlet UITextField *tTextField;
@property (weak, nonatomic) IBOutlet UIButton *getNumBt;
@property (weak, nonatomic) IBOutlet UIButton *commitBt;

@end

NS_ASSUME_NONNULL_END

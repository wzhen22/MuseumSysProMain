//
//  OperateFaultPublishVC.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/18.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SysPBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OperateFaultPublishVC : SysPBaseViewController
@property (weak, nonatomic) IBOutlet UIView *fbackView;
@property (weak, nonatomic) IBOutlet UITextView *mainTextView;
@property (weak, nonatomic) IBOutlet UIView *picBackView;
@property (weak, nonatomic) IBOutlet UIButton *commitBt;

@property (nonatomic,strong) NSString *midString;

@end

NS_ASSUME_NONNULL_END

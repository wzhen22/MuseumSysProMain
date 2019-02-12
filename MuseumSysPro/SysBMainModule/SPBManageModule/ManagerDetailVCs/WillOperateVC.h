//
//  WillOperateVC.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/18.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SysPBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WillOperateVC : SysPBaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *showLabel1;
@property (weak, nonatomic) IBOutlet UILabel *showLabel2;
@property (weak, nonatomic) IBOutlet UILabel *showLabel3;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *mainPicView;
@property (weak, nonatomic) IBOutlet UIButton *commitBt;

//
@property(nonatomic,assign) BOOL isBeClosed;
@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UIView *middleBackView;
@property (nonatomic,strong) NSString *midString;
@end

NS_ASSUME_NONNULL_END

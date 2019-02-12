//
//  ShowSuccessView.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/17.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowSuccessView : UIView

+(instancetype)loadView;
@property (weak, nonatomic) IBOutlet UIView *BackBaseView;
@property (weak, nonatomic) IBOutlet UIView *ShowBackView;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBt;

@end

NS_ASSUME_NONNULL_END

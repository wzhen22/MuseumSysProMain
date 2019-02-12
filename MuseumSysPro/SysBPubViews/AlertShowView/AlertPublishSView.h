//
//  AlertPublishSView.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/18.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DissViewBlock)(id obj);

@interface AlertPublishSView : UIView
@property (weak, nonatomic) IBOutlet UIView *backBaseView;

@property (weak, nonatomic) IBOutlet UIView *topBaseView;
@property (weak, nonatomic) IBOutlet UIButton *sureBt;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (nonatomic, copy) DissViewBlock dissViewBlock;

+(instancetype)loadView;
@end

NS_ASSUME_NONNULL_END

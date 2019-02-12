//
//  ReportFaultView.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/17.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReportFaultView : UIView

typedef void(^ShowViewBlock)();

+(instancetype)loadView;
@property (weak, nonatomic) IBOutlet UIView *BackBaseView;
@property (weak, nonatomic) IBOutlet UIView *mainBackView;
@property (weak, nonatomic) IBOutlet UIButton *sureBt;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic,strong) NSString *deviceId;
@property(nonatomic,strong) NSString *remaining_electricity;
@property (nonatomic, copy) ShowViewBlock showViewBlock;
@end

NS_ASSUME_NONNULL_END

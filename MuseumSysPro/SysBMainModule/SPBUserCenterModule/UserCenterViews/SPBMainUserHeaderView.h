//
//  SPBMainUserHeaderView.h
//  MuseumSysPro
//
//  Created by 王臻 on 2019/1/13.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserHeaderSubShowView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPBMainUserHeaderView : UITableViewHeaderFooterView

@property(nonatomic,strong) UIImageView *userImageView;
@property(nonatomic,strong) UILabel *userNameLable;
@property(nonatomic,strong) UserHeaderSubShowView *userHeaderSubShowView1;
@property(nonatomic,strong) UserHeaderSubShowView *userHeaderSubShowView2;
@property(nonatomic,strong) UserHeaderSubShowView *userHeaderSubShowView3;

@end

NS_ASSUME_NONNULL_END

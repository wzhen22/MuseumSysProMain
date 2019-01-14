//
//  UserCTableViewCell.h
//  MuseumSysPro
//
//  Created by 王臻 on 2019/1/13.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PubCellDetailView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserCTableViewCell : UITableViewCell

@property(nonatomic,strong) PubCellDetailView *pubCellDetailView;

@end

NS_ASSUME_NONNULL_END

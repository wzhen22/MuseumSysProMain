//
//  PubCellDetailView.h
//  MuseumSysPro
//
//  Created by 王臻 on 2019/1/13.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^RightBtBlock)();

@interface PubCellDetailView : UIView

@property(nonatomic,strong) UIImageView *mainImageView;
@property(nonatomic,strong) UILabel *mainLable;
@property(nonatomic,strong) UILabel *subLable;
@property(nonatomic,strong) UIButton *rightBT;

@property (nonatomic, copy) RightBtBlock rightBtBlock;

@end

NS_ASSUME_NONNULL_END

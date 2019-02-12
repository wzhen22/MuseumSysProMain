//
//  PubTimeLineTViewCell.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/22.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PubTimeLineTViewCell : UITableViewCell{
    UIView *verticalLineTopView;
    UIView *dotView;
    UIView *verticalLineBottomView;
    
    UIButton *showLab;
    UIButton *showCheckAddress;
}
+ (float)cellHeightWithString:(NSString *)str isContentHeight:(BOOL)b;

- (void)setDataSource:(NSString *)dic isFirst:(BOOL)isFirst isLast:(BOOL)isLast;
- (void)setDataSourceDic:(NSDictionary *)dic isFirst:(BOOL)isFirst isLast:(BOOL)isLast;
@end

NS_ASSUME_NONNULL_END

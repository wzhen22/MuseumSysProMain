//
//  StatisticsSubLabelView.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/28.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "StatisticsSubLabelView.h"

@implementation StatisticsSubLabelView

#pragma mark ****************************** life cycle          ******************************
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setSubViewsProperty];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setSubViewsProperty];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViewsProperty];
    }
    return self;
}
-(void)dealloc{
#ifdef DEBUG
    NSLog(@"Dealloc %@",self);
#endif
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    _leftImageView.frame = CGRectMake(20, (frame.size.height-16)/2, 5, 16);
    _showLabel.frame  =  CGRectMake(_leftImageView.right +20, (frame.size.height-35)/2, 160, 35);
}
#pragma mark ****************************** System Delegate     ******************************

#pragma mark ****************************** Custom Delegate     ******************************

#pragma mark ****************************** event   Response    ******************************

#pragma mark ****************************** private Methods     ******************************
-(void) tapGestureClick{
    DLog(@"");
}
#pragma mark ****************************** HTTP Server         ******************************

#pragma mark ****************************** getter and setter   ******************************
- (void)setSubViewsProperty{
    _leftImageView = [[UIView alloc]init];
    _leftImageView.backgroundColor = [UIColor colorWithHexString:@"148aff"];
    [self addSubview:_leftImageView];
    
    _showLabel = [[UILabel alloc]init];
    _showLabel.backgroundColor = [UIColor clearColor];
    _showLabel.font = [UIFont systemFontOfSize:17.f];
    _showLabel.textColor = [UIColor colorWithHexString:@"333333"];
    _showLabel.textAlignment = NSTextAlignmentLeft;
    _showLabel.text = @"巡检人概览";
    [self addSubview:_showLabel];
    //添加响应手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick)];
    [self addGestureRecognizer:tapGesture];
}


@end

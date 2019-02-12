//
//  AlertPublishSView.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/18.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "AlertPublishSView.h"

@implementation AlertPublishSView

#pragma mark ****************************** life cycle          ******************************
+(instancetype)loadView
{
    return  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
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

#pragma mark ****************************** System Delegate     ******************************

#pragma mark ****************************** Custom Delegate     ******************************

#pragma mark ****************************** event   Response    ******************************

- (IBAction)sureBtClick:(id)sender {
    [self removeFromSuperview];
    if (self.dissViewBlock) {
        self.dissViewBlock(sender);
    }
}
-(void) tapGestureClick{
//    [self removeFromSuperview];
}
#pragma mark ****************************** private Methods     ******************************

#pragma mark ****************************** HTTP Server         ******************************

#pragma mark ****************************** getter and setter   ******************************
- (void)setSubViewsProperty{
    //添加响应手势
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor clearColor];
    self.backBaseView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
}


@end

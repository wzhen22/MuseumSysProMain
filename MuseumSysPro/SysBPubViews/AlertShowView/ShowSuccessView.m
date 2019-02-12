//
//  ShowSuccessView.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/17.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "ShowSuccessView.h"

@implementation ShowSuccessView

#pragma mark ****************************** life cycle          ******************************
+(instancetype)loadView
{
//    NSString *className = NSStringFromClass([self class]);
//    UINib *nib = [UINib nibWithNibName:className bundle:nil];
//    return [nib instantiateWithOwner:nil options:nil].firstObject;
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
-(void) tapGestureClick{
//    [self removeFromSuperview];
}
- (IBAction)sureBtClick:(id)sender {
    [self removeFromSuperview];
}

#pragma mark ****************************** private Methods     ******************************

#pragma mark ****************************** HTTP Server         ******************************

#pragma mark ****************************** getter and setter   ******************************
- (void)setSubViewsProperty{
    //添加响应手势
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor clearColor];
    self.BackBaseView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
}


@end

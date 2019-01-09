//
//  GuideView.m
//  mobile_tv
//
//  Created by wangqiang on 13-5-16.
//  Copyright (c) 2013年 wangqiang. All rights reserved.
//

#import "GuideView.h"

@implementation GuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        float guideWidth = [[UIScreen mainScreen] bounds].size.width;
        float guideHeight = [[UIScreen mainScreen] bounds].size.height;
        
        UIScrollView *guideScroll = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        guideScroll.backgroundColor = [UIColor clearColor];
        guideScroll.delegate = self;
        guideScroll.showsHorizontalScrollIndicator = NO;
        guideScroll.showsVerticalScrollIndicator = NO;
        guideScroll.bounces = NO;
        guideScroll.pagingEnabled = YES;
        guideScroll.contentSize = CGSizeMake(guideWidth*3, guideHeight);
        [self addSubview:guideScroll];
        
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, guideWidth, guideHeight)];
        imageView1.image=[UIImage imageNamed:@"00-A引导页-01智能巡更巡检"];
        [guideScroll addSubview:imageView1];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(guideWidth, 0.0, guideWidth, guideHeight)];
        imageView2.image=[UIImage imageNamed:@"00-B引导页-02安全管理"];
        [guideScroll addSubview:imageView2];
        
        UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(guideWidth*2, 0.0, guideWidth, guideHeight)];
        imageView3.image=[UIImage imageNamed:@"00-C引导页-03移动考勤"];
        imageView3.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapTouchGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startButtonDidPressed)];
        [imageView3 addGestureRecognizer:tapTouchGesture];
        [guideScroll addSubview:imageView3];
        
        UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [startButton setBackgroundColor:[UIColor clearColor]];
        [startButton setBackgroundImage:[UIImage imageNamed:@"start_begin"] forState:UIControlStateNormal];
        startButton.frame = CGRectMake(guideWidth*2+(guideWidth-120.0)/2, guideHeight-98.0, 120.0, 38.0);
//        [startButton setTitle:@"点击进入" forState:UIControlStateNormal];
        [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [startButton addTarget:self action:@selector(startButtonDidPressed) forControlEvents:UIControlEventTouchUpInside];
        startButton.hidden = YES;
        [guideScroll addSubview:startButton];
    }
    return self;
}

- (void)startButtonDidPressed
{
    [self startMain];
    
    [UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.alpha = 0.0;
        
    }completion:^(BOOL finished)
     {
         // 完成后执行code
         [self removeFromSuperview];
     }];
}

-(void)startMain
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"one",@"type",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WRefreshHomeNotification" object:self userInfo:dictionary];
}

@end

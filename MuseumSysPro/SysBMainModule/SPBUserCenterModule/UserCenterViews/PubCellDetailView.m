//
//  PubCellDetailView.m
//  MuseumSysPro
//
//  Created by 王臻 on 2019/1/13.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "PubCellDetailView.h"

@implementation PubCellDetailView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup{
    _mainImageView = [[UIImageView alloc]init];
    _mainImageView.backgroundColor = [UIColor clearColor];
    _mainImageView.image = [UIImage imageNamed:@"04-个人中心-active"];
    [self addSubview:_mainImageView];
    
    _mainLable = [[UILabel alloc]init];
    _mainLable.backgroundColor = [UIColor clearColor];
    _mainLable.font = [UIFont systemFontOfSize:13.f];
    _mainLable.textColor = [UIColor blackColor];
    _mainLable.textAlignment = NSTextAlignmentCenter;
    _mainLable.text = @"累计上报隐患数";
    [self addSubview:_mainLable];
    
    _subLable = [[UILabel alloc]init];
    _subLable.backgroundColor = [UIColor clearColor];
    _subLable.font = [UIFont systemFontOfSize:13.f];
    _subLable.textColor = [UIColor blackColor];
    _subLable.textAlignment = NSTextAlignmentCenter;
    _subLable.text = @"上报隐患数";
    [self addSubview:_subLable];
    
    _rightBT = [[UIButton alloc]init];
    _rightBT.backgroundColor = [UIColor blueColor];
    _rightBT.layer.cornerRadius = 5.f;
    [_rightBT setTitle:@"" forState:UIControlStateNormal];
    [self addSubview:_rightBT];
    //添加响应手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick)];
    [self addGestureRecognizer:tapGesture];
}
-(void) tapGestureClick{
    DLog(@"");
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    //    CGSize size =  [_subLable sizeThatFits:_subLable.bounds.size];
    CGRect frame = self.bounds;
    
    _mainImageView.frame = CGRectMake(5, (frame.size.height-35)/2, 35, 35);
    _mainLable.frame  =  CGRectMake(_mainImageView.right +10, (frame.size.height-35)/2, 100, 35);
    _subLable.frame  =  CGRectMake(_mainLable.right+10, (frame.size.height-35)/2, 100, 35);
    _rightBT.frame = CGRectMake((frame.size.width-50), (frame.size.height-35)/2, 40, 35);
}

@end

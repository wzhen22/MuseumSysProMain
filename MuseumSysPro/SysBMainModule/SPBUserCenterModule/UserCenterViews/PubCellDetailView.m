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
    _mainLable.font = [UIFont systemFontOfSize:15.f];
    _mainLable.textColor = [UIColor colorWithHexString:@"333333"];
    _mainLable.textAlignment = NSTextAlignmentLeft;
    _mainLable.text = @"累计上报隐患数";
    [self addSubview:_mainLable];
    
    _subLable = [[UILabel alloc]init];
    _subLable.backgroundColor = [UIColor clearColor];
    _subLable.font = [UIFont systemFontOfSize:15.f];
    _subLable.textColor = [UIColor colorWithHexString:@"333333"];
    _subLable.textAlignment = NSTextAlignmentRight;
    _subLable.text = @"上报隐患数";
    [self addSubview:_subLable];
    
    _rightBT = [[UIButton alloc]init];
    _rightBT.backgroundColor = [UIColor clearColor];
    _rightBT.layer.cornerRadius = 5.f;
    [_rightBT addTarget:self action:@selector(rightBtClick) forControlEvents:UIControlEventTouchUpInside];
    [_rightBT setTitle:@"" forState:UIControlStateNormal];
    [self addSubview:_rightBT];
    //添加响应手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick)];
    [self addGestureRecognizer:tapGesture];
}
-(void) tapGestureClick{
    DLog(@"");
}
-(void)rightBtClick{
    if (self.rightBtBlock) {
        self.rightBtBlock();
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    //    CGSize size =  [_subLable sizeThatFits:_subLable.bounds.size];
    CGRect frame = self.bounds;
    
    _mainImageView.frame = CGRectMake(20, (frame.size.height-16)/2, 16, 16);
    _mainLable.frame  =  CGRectMake(_mainImageView.right +10, (frame.size.height-35)/2, 160, 35);
    _rightBT.frame = CGRectMake((frame.size.width-40-70), (frame.size.height-32)/2, 70, 32);
    _subLable.frame  =  CGRectMake(_mainLable.right+10, (frame.size.height-35)/2, (frame.size.width-30-_mainLable.right-30), 35);
}

@end

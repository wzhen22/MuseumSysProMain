//
//  SPBMainUserHeaderView.m
//  MuseumSysPro
//
//  Created by 王臻 on 2019/1/13.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SPBMainUserHeaderView.h"

@implementation SPBMainUserHeaderView
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
    self.backgroundColor = [UIColor grayColor];
    
    _userImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"个人中心-管理员默认大头像"]];
    _userImageView.backgroundColor = [UIColor clearColor];
    _userImageView.layer.cornerRadius = 80.f;
    [self addSubview:_userImageView];
    
    _userNameLable = [[UILabel alloc]init];
    _userNameLable.backgroundColor = [UIColor clearColor];
    _userNameLable.font = [UIFont systemFontOfSize:13.f];
    _userNameLable.textColor = [UIColor blackColor];
    _userNameLable.textAlignment = NSTextAlignmentCenter;
    _userNameLable.text = @"累计上报隐患数hhh";
    [self addSubview:_userNameLable];
    
    _userHeaderSubShowView1 = [[UserHeaderSubShowView alloc]init];
    [self addSubview:_userHeaderSubShowView1];
    _userHeaderSubShowView2 = [[UserHeaderSubShowView alloc]init];
    [self addSubview:_userHeaderSubShowView2];
    _userHeaderSubShowView3 = [[UserHeaderSubShowView alloc]init];
    [self addSubview:_userHeaderSubShowView3];
    
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
    CGRect frame = self.bounds;
    _userImageView.frame = CGRectMake((frame.size.width-100)/2.f, 30, 100, 100);
    _userNameLable.frame = CGRectMake(0, _userImageView.bottom, frame.size.width, 40);
    CGFloat subWidth = (frame.size.width-20)/3.f;
    _userHeaderSubShowView1.frame = CGRectMake(10, _userNameLable.bottom, subWidth, 80);
    _userHeaderSubShowView2.frame = CGRectMake(_userHeaderSubShowView1.right, _userNameLable.bottom, subWidth, 80);
    _userHeaderSubShowView3.frame = CGRectMake(_userHeaderSubShowView2.right, _userNameLable.bottom, subWidth, 80);
}

@end

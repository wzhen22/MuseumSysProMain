//
//  UserHeaderSubShowView.m
//  MuseumSysPro
//
//  Created by 王臻 on 2019/1/13.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "UserHeaderSubShowView.h"

@implementation UserHeaderSubShowView

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
+(instancetype)loadView
{
    return  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
- (void)setup{
    
    self.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    
    _subBT = [[UIButton alloc]init];
    _subBT.backgroundColor = [UIColor colorWithHexString:@"148aff"];
    _subBT.layer.cornerRadius = 6.f;
    [_subBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_subBT setTitle:@"78" forState:UIControlStateNormal];
    [self addSubview:_subBT];
    
    _subLable = [[UILabel alloc]init];
    _subLable.backgroundColor = [UIColor clearColor];
    _subLable.font = [UIFont systemFontOfSize:13.f];
    _subLable.textColor = [UIColor blackColor];
    _subLable.textAlignment = NSTextAlignmentCenter;
    _subLable.text = @"累计上报隐患数";
    [self addSubview:_subLable];
    
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
    
    _subBT.frame  =  CGRectMake((frame.size.width-38)/2, 5, 38, 38);
    _subLable.frame  =  CGRectMake(0, 38, frame.size.width, frame.size.height-48);
}


@end

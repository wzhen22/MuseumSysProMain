//
//  PubTimeLineTViewCell.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/22.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "PubTimeLineTViewCell.h"

@implementation PubTimeLineTViewCell

#pragma mark ****************************** life cycle          ******************************
#define DotViewCentX 20//圆点中心 x坐标
#define VerticalLineWidth 1//时间轴 线条 宽度
#define ShowLabTop 10//cell间距
#define ShowLabWidth (320 - DotViewCentX - 20)
#define ShowLabFont [UIFont systemFontOfSize:15]

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self DynamicLiveNoticeTBCell_setSubViewsProperty];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    super.frame = frame;
//    dotView.center = CGPointMake(DotViewCentX, ShowLabTop + 13);
    dotView.center = CGPointMake(DotViewCentX, frame.size.height/2.0);
    int cutHeight = dotView.frame.size.height/2.0 - 2;
    verticalLineTopView.frame = CGRectMake(DotViewCentX - VerticalLineWidth/2.0, 0, VerticalLineWidth, dotView.center.y - cutHeight);
    verticalLineBottomView.frame = CGRectMake(DotViewCentX - VerticalLineWidth/2.0, dotView.center.y + cutHeight, VerticalLineWidth, frame.size.height - (dotView.center.y + cutHeight));
    showLab.frame = CGRectMake(dotView.right+10, 5, 80, frame.size.height-10);
    showCheckAddress.frame = CGRectMake(showLab.right+0, 5, (frame.size.width-showLab.right-30), frame.size.height-10);
}

- (void)setDataSource:(NSString *)content isFirst:(BOOL)isFirst isLast:(BOOL)isLast {
    showLab.frame = CGRectMake(DotViewCentX - VerticalLineWidth/2.0 + 5, ShowLabTop, ShowLabWidth, [PubTimeLineTViewCell cellHeightWithString:content isContentHeight:YES]);
    [showLab setTitle:content forState:UIControlStateNormal];
    [showLab setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    verticalLineTopView.hidden = isFirst;
    verticalLineBottomView.hidden = isLast;
    dotView.backgroundColor = [UIColor colorWithHexString:@"148aff"];
//    dotView.backgroundColor = isFirst ? [UIColor orangeColor] : [UIColor grayColor];
//    UIImage *img = [UIImage imageNamed:isFirst ? @"AttenceTimelineCellMessage" : @"AttenceTimelineCellMessage2"];
//    img = [img stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//    [showLab setBackgroundImage:img forState:UIControlStateNormal];
}
- (void)setDataSourceDic:(NSDictionary *)dic isFirst:(BOOL)isFirst isLast:(BOOL)isLast{
    NSString *inspectTime = [dic safeObjectForKey:@"inspectTime"];
    NSString *addressName = [dic safeObjectForKey:@"addressName"];
    [showLab setTitle:inspectTime forState:UIControlStateNormal];
    [showLab setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [showCheckAddress setTitle:addressName forState:UIControlStateNormal];
    [showCheckAddress setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    verticalLineTopView.hidden = isFirst;
    verticalLineBottomView.hidden = isLast;
}
+ (float)cellHeightWithString:(NSString *)content isContentHeight:(BOOL)b{
    NSDictionary *attribute = @{NSFontAttributeName: ShowLabFont};
    
    CGSize retSize = [content boundingRectWithSize:CGSizeMake(ShowLabWidth - 20, 100)
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    float height = retSize.height;
    return (b ? height : (height + ShowLabTop * 2)) + 15;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self DynamicLiveNoticeTBCell_setSubViewsProperty];
    }
    return self;
}

- (void)DynamicLiveNoticeTBCell_setSubViewsProperty {
    verticalLineTopView = [[UIView alloc] init];
    verticalLineTopView.backgroundColor = [UIColor colorWithHexString:@"148aff"];
    [self addSubview:verticalLineTopView];
    
    int dotViewRadius = 4;
    dotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dotViewRadius * 2, dotViewRadius * 2)];
    dotView.backgroundColor = [UIColor colorWithHexString:@"148aff"];
    dotView.layer.cornerRadius = dotViewRadius;
    [self addSubview:dotView];
    
    verticalLineBottomView = [[UIView alloc] init];
    verticalLineBottomView.backgroundColor = [UIColor colorWithHexString:@"148aff"];
    [self addSubview:verticalLineBottomView];
    
    showLab = [[UIButton alloc] init];
//    UIImage *img = [UIImage imageNamed:@"AttenceTimelineCellMessage2"];
//    img = [img stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//    [showLab setBackgroundImage:img forState:UIControlStateNormal];
//    showLab.titleLabel.font = ShowLabFont;
//    showLab.titleLabel.numberOfLines = 20;
//    showLab.titleLabel.textAlignment = NSTextAlignmentLeft;
//    showLab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    showLab.titleEdgeInsets = UIEdgeInsetsMake(5, 15, 5, 5);
    
    showLab.titleLabel.font = ShowLabFont;
    showLab.titleLabel.textAlignment = NSTextAlignmentLeft;
    showLab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    showLab.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self addSubview:showLab];
    
    showCheckAddress = [[UIButton alloc] init];
    showCheckAddress.titleLabel.font = ShowLabFont;
    showCheckAddress.titleLabel.textAlignment = NSTextAlignmentRight;
    showCheckAddress.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:showCheckAddress];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
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

#pragma mark ****************************** private Methods     ******************************

#pragma mark ****************************** HTTP Server         ******************************

#pragma mark ****************************** getter and setter   ******************************
- (void)setSubViewsProperty{
    
}

@end

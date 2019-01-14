//
//  UserCTableViewCell.m
//  MuseumSysPro
//
//  Created by 王臻 on 2019/1/13.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "UserCTableViewCell.h"

@implementation UserCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self DynamicLiveNoticeTBCell_setSubViewsProperty];
    }
    return self;
}

- (void)DynamicLiveNoticeTBCell_setSubViewsProperty {
    [self.contentView addSubview:self.pubCellDetailView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (PubCellDetailView *)pubCellDetailView {
    if (!_pubCellDetailView) {
        _pubCellDetailView = [[PubCellDetailView alloc]init];
        _pubCellDetailView.frame = self.contentView.bounds;
    }
    return _pubCellDetailView;
}
@end

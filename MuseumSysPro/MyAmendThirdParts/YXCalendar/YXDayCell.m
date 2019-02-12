//
//  YXDayCell.m
//  Calendar
//
//  Created by Vergil on 2017/7/6.
//  Copyright © 2017年 Vergil. All rights reserved.
//

#import "YXDayCell.h"

@interface YXDayCell ()

@property (weak, nonatomic) IBOutlet UILabel *dayL;     //日期
@property (weak, nonatomic) IBOutlet UIView *pointV;    //点

@end

@implementation YXDayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //10是距离cell底部的高度
    _dayL.layer.cornerRadius = (dayCellH-10) / 2;
    _pointV.layer.cornerRadius = 1.5;
    
}

//MARK: - setmethod

- (void)setCellDate:(NSDate *)cellDate {
    _cellDate = cellDate;
    if (_type == CalendarType_Week) {
        [self showDateFunction];
    } else {
        if ([[YXDateHelpObject manager] checkSameMonth:_cellDate AnotherMonth:_currentDate]) {
            [self showDateFunction];
        } else {
            [self showSpaceFunction];
        }
    }
    
}

//MARK: - otherMethod

- (void)showSpaceFunction {
    self.userInteractionEnabled = NO;
    _dayL.text = @"";
    _dayL.backgroundColor = [UIColor clearColor];
    _dayL.layer.borderWidth = 0;
    _dayL.layer.borderColor = [UIColor clearColor].CGColor;
    _pointV.hidden = YES;
}

- (void)showDateFunction {
    
    self.userInteractionEnabled = YES;
//    _dayL.layer.cornerRadius = (_dayL.frame.size.width) / 2.f;
    _dayL.text = [[YXDateHelpObject manager] getStrFromDateFormat:@"d" Date:_cellDate];
    if ([[YXDateHelpObject manager] isSameDate:_cellDate AnotherDate:[NSDate date]]) {
        _dayL.layer.borderWidth = 1.5;
        _dayL.layer.borderColor = [UIColor colorWithHexString:@"148aff"].CGColor;
    } else {
        _dayL.layer.borderWidth = 0;
        _dayL.layer.borderColor = [UIColor clearColor].CGColor;
    }
    if (_selectDate) {
        
        if ([[YXDateHelpObject manager] isSameDate:_cellDate AnotherDate:_selectDate]) {
            _dayL.backgroundColor = [UIColor colorWithHexString:@"148aff"];
            _dayL.textColor = [UIColor whiteColor];
            _pointV.backgroundColor = [UIColor colorWithHexString:@"148aff"];
        } else {
            _dayL.backgroundColor = [UIColor clearColor];
            _dayL.textColor = [UIColor blackColor];
            _pointV.backgroundColor = [UIColor colorWithHexString:@"148aff"];
        }
        
    }
    NSString *currentDate = [[YXDateHelpObject manager] getStrFromDateFormat:@"MM-dd" Date:_cellDate];
    _pointV.hidden = YES;
    if (_eventArray.count) {
        for (NSString *strDate in _eventArray) {
            if ([strDate isEqualToString:currentDate]) {
                _pointV.hidden = NO;
            }
        }
    }
    
}

@end

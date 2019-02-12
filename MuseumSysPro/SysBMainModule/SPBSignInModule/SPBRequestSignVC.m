//
//  SPBRequestSignVC.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/17.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SPBRequestSignVC.h"
#import "BRPickerView.h"

@interface SPBRequestSignVC (){
    NSInteger selectInt;
}

@end

@implementation SPBRequestSignVC

#pragma mark ****************************** life cycle          ******************************
-(void)viewDidLoad{
    [super viewDidLoad];
//    self.title = @"申请补卡(2019.01.11)";
    selectInt = 0;
    self.view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    
    [self setSubViewsProperty];
    //添加响应手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mainTapGestureClick)];
    [self.view addGestureRecognizer:tapGesture];
}
-(void) mainTapGestureClick{
    [self.mainTextView resignFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:19],NSFontAttributeName, nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark ****************************** System Delegate     ******************************

#pragma mark ****************************** Custom Delegate     ******************************

#pragma mark ****************************** event   Response    ******************************

- (IBAction)publishBtClick:(id)sender {
    NSString *uString = [NSString stringWithFormat:@"%@ %@",self.selectDateStr,self.UptimeBt.titleLabel.text];
    NSString *dString = [NSString stringWithFormat:@"%@ %@",self.selectDateStr,self.DownTimeBt.titleLabel.text];
    NSDate *newDate1 = [SwTools stringToDate:uString DateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr1 = [SwTools dateToString:newDate1 DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *newDate2 = [SwTools stringToDate:dString DateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr2 = [SwTools dateToString:newDate2 DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"%@",dateStr1);
    NSLog(@"%@",dateStr2);
    NSLog(@"%@",self.mainTextView.text);
    [self httpRequestFromServers:dateStr1 and:dateStr2];
}
#pragma mark ****************************** private Methods     ******************************
-(void) tapGestureClick{
    DLog(@"");
    selectInt = 0;
    [self date_defalut_yearMoth];
}
-(void) tapGestureClick2{
    DLog(@"");
    selectInt = 1;
    [self date_defalut_yearMoth];
}
- (void)date_defalut_yearMoth{
    [self.mainTextView resignFirstResponder];
//    id <YWAlertViewProtocol>_dateAlert = [YWAlertView alertViewWithTitle:@"请选择日期" preferredStyle:YWAlertViewStyleDatePicker2 footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertStyleShowHourMinuteSecond cancelButtonTitle:@"取消" sureButtonTitles:@"确定" handler:^(NSInteger buttonIndex, id  _Nullable value) {
//        NSLog(@"选择日期 %@",value);
//        if (buttonIndex == 101) {
//            //选择了确定
//            [self changeTime:value andTapIndex:self->selectInt];
//        }
//
//    }];
//    [(id<YWAlertDatePickerViewProtocol>)_dateAlert setPickerHeightOnDatePickerView:200];
//    [_dateAlert show];
    NSDate *minDate = [NSDate br_setHour:0 minute:1];
    NSDate *maxDate = [NSDate br_setHour:23 minute:59];
    [BRDatePickerView showDatePickerWithTitle:@"选择时间" dateType:BRDatePickerModeHM defaultSelValue:@"" minDate:minDate maxDate:maxDate isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
        NSLog(@"selectValue:%@",selectValue);
        [self changeTime:selectValue andTapIndex:self->selectInt];
    } cancelBlock:^{
        NSLog(@"点击了背景或取消按钮");
    }];
}
-(void)changeTime:(NSString *)dateStr andTapIndex:(NSInteger)beSelcetInt{
    NSLog(@"tapGesture:%ld",(long)beSelcetInt);
    if (beSelcetInt == 0) {
        [self.UptimeBt setTitle:dateStr forState:UIControlStateNormal];
    }else{
        [self.DownTimeBt setTitle:dateStr forState:UIControlStateNormal];
    }
}

#pragma mark ****************************** HTTP Server         ******************************
-(void)httpRequestFromServers:(NSString *)str1 and:(NSString *)str2{
    [SVProgressHUD show];
//    NSString *dateStr = [SwTools dateToString:[NSDate date] DateFormat:@"yyyy-MM"];
    NSDictionary * dic = @{@"startTime":str1,
                           @"endTime":str2,
                           @"content":self.mainTextView.text
                           };
    [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithPostBaseURL:BASE_HTTP_SERVER andMethond:@"/inspection/loophole/apply" andParams:dic andSuccessBlock:^(id  _Nonnull retValue) {
        NSLog(@"andSuccessBlock:%@",retValue);
        NSString *statusStr = [retValue safeObjectForKey:@"success"];
        if (statusStr.boolValue) {
            [SVProgressHUD showSuccessWithStatus:@"成功提交申请"];
        }else{
            [SVProgressHUD showInfoWithStatus:[retValue safeObjectForKey:@"msg"]];
        }
    } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
        NSLog(@"andFailBlock:%@",error);
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
    }];
}

#pragma mark ****************************** getter and setter   ******************************
- (void)setSubViewsProperty {
    self.publishBt.layer.cornerRadius = 6.f;
    self.mainTextView.backgroundColor = [UIColor colorWithHexString:@"fbfbfb"];
    self.mainTextView.layer.cornerRadius = 5.f;
    
    //添加响应手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick)];
    [self.FchooseView addGestureRecognizer:tapGesture];
    //添加响应手势
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick2)];
    [self.SchooseView addGestureRecognizer:tapGesture2];
    self.UptimeBt.enabled = NO;
    self.DownTimeBt.enabled = NO;
}
@end

//
//  SPBAboutWeVC.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/10.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SPBAboutWeVC.h"

@interface SPBAboutWeVC ()<UITextViewDelegate>

@end

@implementation SPBAboutWeVC

#pragma mark ****************************** life cycle          ******************************
-(void)viewDidLoad{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于我们";
    //
//    [self setBaseViewData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:19],NSFontAttributeName, nil];
//    self.navigationController.navigationBar.subviews.firstObject.alpha = 0.0;
//    UIView * barBackground = self.navigationController.navigationBar.subviews.firstObject;
//    if (@available(iOS 11.0, *))
//    {
//        [barBackground.subviews setValue:@(0) forKeyPath:@"alpha"];
//    } else {
//        barBackground.alpha = 0;
//    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:19],NSFontAttributeName, nil];
//    self.navigationController.navigationBar.subviews.firstObject.alpha = 1.0;
//    UIView * barBackground = self.navigationController.navigationBar.subviews.firstObject;
//    if (@available(iOS 11.0, *))
//    {
//        [barBackground.subviews setValue:@(1) forKeyPath:@"alpha"];
//    } else {
//        barBackground.alpha = 1;
//    }
    
}

#pragma mark ****************************** System Delegate     ******************************
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
//    if ([[URL scheme] isEqualToString:@"官网："]) {
//        NSString *username = [URL host];
//        // do something with this username
//        // ...
//        return NO;
//    }
    return YES; // let the system open this URL
}
#pragma mark ****************************** Custom Delegate     ******************************

#pragma mark ****************************** event   Response    ******************************

#pragma mark ****************************** private Methods     ******************************

#pragma mark ****************************** HTTP Server         ******************************

#pragma mark ****************************** getter and setter   ******************************
-(void)setBaseViewData{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"\t智能巡更巡检系统是由重庆常朝科技有限公司根据博物馆需求自主研发的智能系统，全面满足博物馆对巡更、安全隐患上报、隐患处理以及考勤管理的要求。系统无须外接电源即插即用并且支持离线巡检，特别适用于对安全和消防管理要求较高的使用场景。\n\t本系统是“i博物馆”智慧博物馆解决方案的组成部分，希望了解更多智慧博物馆系统请您访问官网：http://www.chinamuseum.cn"];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"官网：http://www.chinamuseum.cn"
                             range:[[attributedString string] rangeOfString:@"http://www.chinamuseum.cn"]];
    
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"148aff"],
                                     NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    
    // assume that textView is a UITextView previously created (either by code or Interface Builder)
    self.mainTextView.linkTextAttributes = linkAttributes; // customizes the appearance of links
    self.mainTextView.attributedText = attributedString;
    self.mainTextView.delegate = self;
    self.mainTextView.editable = NO;  // 非编辑状态下才可以点击Url
    
//    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
//    paragraphStyle.lineSpacing = 20;// 字体的行间距
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],
//                                 NSParagraphStyleAttributeName:paragraphStyle};
//    self.mainTextView.typingAttributes = attributes;
}
@end

//
//  SubManagerDetailVC.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/11.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SubManagerDetailVC.h"
#import "MJRefresh.h"

@interface SubManagerDetailVC ()

@end

@implementation SubManagerDetailVC

#pragma mark ****************************** life cycle          ******************************
-(void)viewDidLoad{
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ****************************** System Delegate     ******************************

#pragma mark ****************************** Custom Delegate     ******************************
#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)listDidDisappear {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
#pragma mark ****************************** event   Response    ******************************

#pragma mark ****************************** private Methods     ******************************

#pragma mark ****************************** HTTP Server         ******************************

#pragma mark ****************************** getter and setter   ******************************

@end

//
//  SysPBaseViewController.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SysPBaseViewController.h"

@interface SysPBaseViewController ()

@property (nonatomic,assign) BOOL isHidden;

@end

@implementation SysPBaseViewController
- (id) init {
    if (self == [super init]) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//#if (isIOS7)
//    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
//    {
//        self.edgesForExtendedLayout = UIExtendedEdgeNone;
//    }
//#else
//    float barHeight =0;
//    if (!isIPad()&& ![[UIApplication sharedApplication] isStatusBarHidden]) {
//        barHeight+=([[UIApplication sharedApplication]statusBarFrame]).size.height;
//    }
//    if(self.navigationController &&!self.navigationController.navigationBarHidden) {    barHeight+=self.navigationController.navigationBar.frame.size.height;
//    }
//    for (UIView *view in self.view.subviews) {
//        if ([view isKindOfClass:[UIScrollView class]]) {
//            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y +barHeight, view.frame.size.width, view.frame.size.height - barHeight);
//        } else {
//            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y +barHeight, view.frame.size.width, view.frame.size.height);
//        }
//    }
//#endif
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:19.0],NSFontAttributeName, nil];
    
    UIButton *backButton = [UIButton new];
    backButton.frame = CGRectMake(0, 0, 23.f, 25.f);
    [backButton setBackgroundImage:[UIImage imageNamed:@"icon-返回箭头"] forState:UIControlStateNormal];//150610gai,home_status_back
    [backButton addTarget:self action:@selector(navBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    if (!self.navigationController) {
//        backButton.frame = CGRectMake(10, 30, 23.f, 25.f);
//        [self.view addSubview:backButton];
//    }
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake )
    {
        // User was shaking the device. Post a notification named "shake".
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"shakeIdentifier" object:nil];
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
}

- (void)viewWillAppear:(BOOL)animated

{
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:19.0],NSFontAttributeName, nil];
    [super viewWillAppear:animated];
    [self hideTabBar];
    _isHidden=YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)dealloc{
    NSLog(@"销毁了 ----- %@", NSStringFromClass(self.class));
}
#pragma mark - action

- (void)navBackAction
{
    UIViewController *ctrl = [self.navigationController popViewControllerAnimated:YES];
    if (ctrl == nil)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

-(void) resetBodySize{
    
}
//截屏响应
- (void)userDidTakeScreenshot:(NSNotification *)notification
{
    NSLog(@"检测到截屏");
    
    //人为截屏, 模拟用户截屏行为, 获取所截图片
    UIImage *image_ = [self imageWithScreenshot];
    UIWindow *keyWindow=[[UIApplication sharedApplication]keyWindow];
    if (_isHidden) {
       
    }else{
        
    }
}
/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
- (UIImage *)imageWithScreenshot
{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}


- (void)hideTabBar {
    //    if (self.tabBarController.tabBar.hidden == YES) {
    //        return;
    //    }
    //    UIView *contentView;
    //    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
    //        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    //    else
    //        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    //    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    //    self.tabBarController.tabBar.hidden = YES;
}

- (void)showTabBar

{
    //    if (self.tabBarController.tabBar.hidden == NO)
    //    {
    //        return;
    //    }
    //    UIView *contentView;
    //    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
    //
    //        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    //
    //    else
    //
    //        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    //    //    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    //    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height);
    //    self.tabBarController.tabBar.hidden = NO;
    
}
@end

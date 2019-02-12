//
//  AppDelegate.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/7.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "AppDelegate.h"
#import "SysBaseTabBarVC.h"
#import "GuideView.h"
#import "SPBLoginVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    if ([SysPubSingleThings getLoginStatus]) {
//        [self loginHttpRequest];
//        [self testUpdateAppSystemConfig];
        [self updateAppSystemConfig];//同步方式
    }
    SysBaseTabBarVC *yTabBarController = [[SysBaseTabBarVC alloc]init];
    self.window.rootViewController = yTabBarController;
    self.window.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    [self.window makeKeyAndVisible];
    [self setGuiteMethord];
    
    return YES;
}

-(void)loginHttpRequest{
    NSString *login = [SysPubSingleThings getUserName];
    NSString *ste = [SysPubSingleThings getPassword];
    NSString *passStr = [SwTools encodeMD5:ste];
    NSLog(@"%@",[SwTools encodeMD5:ste]);
    NSDictionary * dic = @{
                           @"loginname":login,
                           @"password":passStr};
    [[SysPubHttpKit shareHttpKit] sPubInvokeApiWithPostBaseURL:BASE_HTTP_SERVER andMethond:@"/login" andParams:dic andSuccessBlock:^(id  _Nonnull retValue) {
        NSLog(@"andSuccessBlock:%@",retValue);
        NSString *statusStr = [retValue safeObjectForKey:@"success"];
        if (statusStr.boolValue) {
            [SysPubSingleThings sharePublicSingle].loginDic =  [retValue safeObjectForKey:@"obj"];
        }else{

        }
    } andFailBlock:^(NSError * _Nonnull error, id  _Nonnull contextInfo) {
        NSLog(@"andFailBlock:%@",error);
    }]; 
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark Private methord
-(void)setGuiteMethord{
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"firstLaunched"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunched"]) {
        
    }else{
        //用户引导
        [self.window makeKeyAndVisible];
        GuideView *guideView = [[GuideView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [guideView setBackgroundColor:[UIColor clearColor]];
        [self.window addSubview:guideView];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunched"];
    }
}
- (void)updateAppSystemConfig{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSLog(@"0");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"1");
//        dispatch_semaphore_signal(semaphore);
        //在这里设置请求属性
        NSString *_path;
        NSDictionary *dict;
        _path = [NSString stringWithFormat:@"%@/login",BASE_HTTP_SERVER];
        NSString *login = [SysPubSingleThings getUserName];
        NSString *ste = [SysPubSingleThings getPassword];
        NSString *passStr = [SwTools encodeMD5:ste];
        dict =@{
                @"loginname":login,
                @"password":passStr};
        
        NSLog(@"dict:%@",dict);
        NSLog(@"_path:%@",_path);
        
        NSMutableURLRequest *httpRequst = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[_path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [httpRequst setHTTPMethod:@"POST"];
        NSData *jsonData;
        if(dict != nil && [NSJSONSerialization isValidJSONObject:dict])
        {
            jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            [httpRequst setHTTPBody:jsonData];
        }
        //在这里添加请求Header
        [httpRequst setValue:[@([jsonData length]) stringValue] forHTTPHeaderField:@"Content-Length"];
        [httpRequst setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [httpRequst setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSLog(@"httpRequst  Authorization:%@",[httpRequst valueForHTTPHeaderField:@"Authorization"]);
        //创建会话对象通过单例方法实现
        NSURLSession *session=[NSURLSession sharedSession];
        //执行会话的任务
        NSURLSessionTask *task = [session dataTaskWithRequest:httpRequst completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"请求配置失败了");
            }else{
                NSDictionary *responData=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                if ([_path hasSuffix:@"/login"]) {
                    NSHTTPURLResponse *responseE = (NSHTTPURLResponse *)response;
                    NSDictionary *allHeaders = responseE.allHeaderFields;
                    NSString *cookieStr = [allHeaders safeObjectForKey:@"Set-Cookie"];
                    if (cookieStr.length) {
                        [SysPubSingleThings sharePublicSingle].loginCookie = allHeaders;
                    }
                }
                NSString *statusStr = [responData safeObjectForKey:@"success"];
                if (statusStr.boolValue) {
                    [SysPubSingleThings sharePublicSingle].loginDic =  [responData safeObjectForKey:@"obj"];
                }else{
                    
                }
                dispatch_semaphore_signal(semaphore);
            }
            // 2.在网络请求结束后发送通知信号
            dispatch_semaphore_signal(semaphore);
        }];
        //开始执行任务
        [task resume];
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"2");
}
- (void)testUpdateAppSystemConfig{
    // 1.创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSLog(@"0");
    // 开始异步请求操作（部分代码略）
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"1");
        // This function returns non-zero if a thread is woken. Otherwise, zero is returned.
        // 2.在网络请求结束后发送通知信号
        dispatch_semaphore_signal(semaphore);
    });
    // Returns zero on success, or non-zero if the timeout occurred.
    // 3.发送等待信号
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"2");
}
/**
 * 网络状态
 */
- (BOOL)isNetWorkReachable
{
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         NSLog(@"网络发生了1 改变 %ld", (long)status);
         switch (status)
         {
             case AFNetworkReachabilityStatusNotReachable:
             {
//                 [Singleton sharedSingleton].network_status = WNetworkStatusUnknow;
                 
                 break;
             }
             case AFNetworkReachabilityStatusReachableViaWiFi:
             {
//                 [Singleton sharedSingleton].network_status = WNetworkStatusWIFI;
                 
                 break;
             }
             case AFNetworkReachabilityStatusReachableViaWWAN:
             {
//                 [Singleton sharedSingleton].network_status = WNetworkStatusWWAN;
                 
                 break;
             }
                 
             default:
                 break;
         }
         
     }];
    
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}
@end

//
//  SysPubSingleThings.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SysPubSingleThings.h"

static dispatch_once_t getSysPubSharePublicSingle;//保证单例只创建一次

@implementation SysPubSingleThings

+(SysPubSingleThings *)sharePublicSingle{
    static SysPubSingleThings *sharePublicSingleWork=nil;
    
    @synchronized(self)
    {
        if (!sharePublicSingleWork){
            dispatch_once(&getSysPubSharePublicSingle, ^{
                sharePublicSingleWork = [[SysPubSingleThings alloc] init];
                sharePublicSingleWork.isChangeLogin = NO;
            });
        }
        return sharePublicSingleWork;
    }
    
}

+(void)saveUserNameAndPwd:(NSString *)userName andPwd:(NSString *)pwd{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"UserName"];
    [settings removeObjectForKey:@"Password"];
    [settings setObject:userName forKey:@"UserName"];
    [settings setObject:pwd forKey:@"Password"];
    [settings synchronize];
}
+(NSString *)getUserName{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *value = [settings objectForKey:@"UserName"];
    if (value)
        return value;
    else
        return @"";

}
+(NSString *)getPassword{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *value = [settings objectForKey:@"Password"];
    if (value)
        return value;
    else
        return @"";

}
+(void)saveLoginStatus:(BOOL)login{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"LoginStatus"];
    [settings setBool:login forKey:@"LoginStatus"];
    [settings synchronize];
}
+(BOOL)getLoginStatus{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    return [settings boolForKey:@"LoginStatus"];
}
@end

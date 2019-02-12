//
//  SysPubSingleThings.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface SysPubSingleThings : NSObject

@property (nonatomic,strong) NSDictionary *loginCookie;
@property (nonatomic,strong) NSDictionary *loginDic;
@property (nonatomic,assign) BOOL isChangeLogin;//记录是否切换了登录状态

+(SysPubSingleThings *)sharePublicSingle;
+(void)saveUserNameAndPwd:(NSString *)userName andPwd:(NSString *)pwd;
+(NSString *)getUserName;
+(NSString *)getPassword;
+(void)saveLoginStatus:(BOOL)login;
+(BOOL)getLoginStatus;
@end

NS_ASSUME_NONNULL_END

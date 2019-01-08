//
//  SysPubHttpKit.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SysPubNeedPrintNetRetValue 1

NS_ASSUME_NONNULL_BEGIN

@interface SysPubHttpKit : NSObject

@property (nonatomic, strong)NSMutableDictionary * operationDic;

/**
 *  获取shareHttpKit单个实例
 *
 *  @return 返回shareHttpKit的单例对象
 */
+ (instancetype) shareHttpKit;

/**
 *  取消某个HTTP
 *
 *  @param key key
 */
-(void)sPubInvokeApiCancelNetWWithCommandKey:(NSString *)CommandKey;

/**
 *  删除全部
 */
- (void)cancelAllRequest;

/**
 *  网络基础层的HTTPGet请求
 *
 *  @param targetApiName     要请求的接口Api名称或者路径
 *  @param targetRequestInfo 请求的参数
 *  @param successBlock      请求成功后的闭包块
 *  @param failBlock         请求失败后的闭包块
 */
- (void)sPubInvokeApiWithGetMethond:(NSString*)targetApiName
                         andParams:(NSDictionary*)targetRequestInfo
                   andSuccessBlock:(void (^)(id retValue))successBlock
                      andFailBlock:(void (^)(NSError *error, id contextInfo))failBlock;


/**
 *  网络基础层的HTTPPost请求
 *
 *  @param targetApiName     要请求的接口Api名称或者路径
 *  @param targetRequestInfo 要请求的参数
 *  @param successBlock      请求成功后的闭包块
 *  @param failBlock         请求失败后的闭包块
 */
- (void)sPubInvokeApiWithPostMethod:(NSString*)targetApiName
                         andParams:(NSDictionary*)targetRequestInfo
                   andSuccessBlock:(void (^)(id retValue))successBlock
                      andFailBlock:(void (^)(NSError *error, id contextInfo))failBlock;

//带baseurl的请求

/**
 *  网络基础层的HTTPGet请求
 *
 *  @param targetApiName     要请求的接口Api名称或者路径
 *  @param targetRequestInfo 请求的参数
 *  @param successBlock      请求成功后的闭包块
 *  @param failBlock         请求失败后的闭包块
 */
- (void)sPubInvokeApiWithGetBaseURL:(NSString *)baseURL
                        andMethond:(NSString*)targetApiName
                         andParams:(NSDictionary*)targetRequestInfo
                   andSuccessBlock:(void (^)(id retValue))successBlock
                      andFailBlock:(void (^)(NSError *error, id contextInfo))failBlock;


/**
 *  网络基础层的HTTPPost请求
 *
 *  @param targetApiName     要请求的接口Api名称或者路径
 *  @param targetRequestInfo 要请求的参数
 *  @param successBlock      请求成功后的闭包块
 *  @param failBlock         请求失败后的闭包块
 */
- (void)sPubInvokeApiWithPostBaseURL:(NSString *)baseURL
                         andMethond:(NSString*)targetApiName
                          andParams:(NSDictionary*)targetRequestInfo
                    andSuccessBlock:(void (^)(id retValue))successBlock
                       andFailBlock:(void (^)(NSError *error, id contextInfo))failBlock;


@end

NS_ASSUME_NONNULL_END

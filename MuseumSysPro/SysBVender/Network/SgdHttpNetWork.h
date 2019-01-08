//
//  SgdHttpNetWork.h
//  ARCapacityPro
//
//  Created by 王臻 on 2018/1/16.
//  Copyright © 2018年 sgd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailureBlock)(NSString *error);

@interface SgdHttpNetWork : NSObject

@property (nonatomic,strong) NSString *restip;//动态IP
@property (nonatomic,strong) NSString *restport;//动态端口号

+(SgdHttpNetWork *)shareGetSgdUrlWork;

- (void)netHttpRequestWithURL:(NSString *)strURL body:(NSString *)body method:(NSString *)method success:(void(^)(NSDictionary *jsonDictionNary))success failure:(void(^)(NSString* returncode, NSString* errormsg))failure;

//原生GET网络请求
+ (void)getWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)PostWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

@end

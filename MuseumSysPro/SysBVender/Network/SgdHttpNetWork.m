//
//  SgdHttpNetWork.m
//  ARCapacityPro
//
//  Created by 王臻 on 2018/1/16.
//  Copyright © 2018年 sgd. All rights reserved.
//

#import "SgdHttpNetWork.h"

NSString *const ResponseErrorKey = @"com.alamofire.serialization.response.error.response";
NSInteger const Interval = 3;

static dispatch_once_t getSgdUrlPredicate;//保证单例只创建一次

@implementation SgdHttpNetWork

+(SgdHttpNetWork *)shareGetSgdUrlWork{
    static SgdHttpNetWork *shareAchieveSgdPlayUrlWork=nil;
    
    @synchronized(self)
    {
        if (!shareAchieveSgdPlayUrlWork){
            dispatch_once(&getSgdUrlPredicate, ^{
                shareAchieveSgdPlayUrlWork = [[SgdHttpNetWork alloc] init];
                //赋值默认端口号
                shareAchieveSgdPlayUrlWork.restip = @"";
                shareAchieveSgdPlayUrlWork.restport = @"8080";
            });
        }
        return shareAchieveSgdPlayUrlWork;
    }
    
}

- (BOOL)StringIsEmpt:(NSString *)str
{
    if (!str) {
        return YES;
    }
    
    if([str isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if (![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if ([str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        return YES;
    }
    
    return NO;
}

// 将JSON串转化为字典
- (NSMutableDictionary *)dictionaryWithJsonStr:(NSString *)jsonStr{
    if (jsonStr == nil) {
        return nil;
    }
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString : @"\r\n" withString : @"" ];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString : @"\n" withString : @"" ];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString : @"\t" withString : @"" ];
    NSLog ( @"jsonStr = %@" ,jsonStr);
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSMutableDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                      options:NSJSONReadingMutableLeaves
                                                                        error:&error];
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }
    else{
        return nil;
    }
}

/**
 *  发起查询，根据url
 */
- (void)netHttpRequestWithURL:(NSString *)strURL body:(NSString *)body method:(NSString *)method success:(void(^)(NSDictionary *jsonDictionNary))success failure:(void(^)(NSString* returncode, NSString* errormsg))failure{
    NSString *urlstr = strURL;
    if(![self StringIsEmpt:body]){
        if ([method isEqualToString:@"GET"]) {
            urlstr = [NSString stringWithFormat:@"%@?%@",strURL,body];
        }
    }
    NSURL *url = [NSURL URLWithString:urlstr];
    
    //NSLog(@"___url______%@",url);
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    
    // 超时设置
    [request setTimeoutInterval:30.0];
    // 访问方式
    [request setHTTPMethod:method];
    // body内容
    if ([method isEqualToString:@"POST"]) {
       [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:[request copy] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 网络连接失败
        if (error) {
            NSLog(@"--网络连接失败--%@",error);
            if (failure) {
                failure(@"-1",@"访问失败");
            }
            return;
        }
        // 请求成功
        if (success) {
            NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *jDic = [[self dictionaryWithJsonStr:dataString] copy];
            success(jDic);
        }
    }];
    
    [dataTask resume];
}
//GET请求
//原生GET网络请求
+ (void)getWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure
{
    //完整URL
    NSString *urlString = [NSString string];
    if (params) {
        //参数拼接url
        NSString *paramStr = [self dealWithParam:params];
        urlString = [url stringByAppendingString:paramStr];
    }else{
        urlString = url;
    }
    //对URL中的中文进行转码
    NSString *pathStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pathStr]];
    
    request.timeoutInterval = Interval;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                //利用iOS自带原生JSON解析data数据 保存为Dictionary
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                success(dict);
                
            }else{
                NSHTTPURLResponse *httpResponse = error.userInfo[ResponseErrorKey];
                
                if (httpResponse.statusCode != 0) {
                    
                    NSString *ResponseStr = [self showErrorInfoWithStatusCode:httpResponse.statusCode];
                    failure(ResponseStr);
                    
                } else {
                    NSString *ErrorCode = [self showErrorInfoWithStatusCode:error.code];
                    failure(ErrorCode);
                }
            }
            
        });
    }];
    
    [task resume];
}

//原生POST请求
+ (void)PostWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    //把字典中的参数进行拼接
    NSString *body = [self dealWithParam:params];
    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    //设置请求体
    [request setHTTPBody:bodyData];
    //设置本次请求的数据请求格式
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置本次请求请求体的长度(因为服务器会根据你这个设定的长度去解析你的请求体中的参数内容)
    [request setValue:[NSString stringWithFormat:@"%ld", bodyData.length] forHTTPHeaderField:@"Content-Length"];
    //设置请求最长时间
    request.timeoutInterval = Interval;
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            //利用iOS自带原生JSON解析data数据 保存为Dictionary
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //保证正确的闭包块在主线程中运行
            if([NSThread currentThread].isMainThread)
                success(dict);
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(dict);
                });
            }
        }else{
            NSHTTPURLResponse *httpResponse = error.userInfo[ResponseErrorKey];
            
            if (httpResponse.statusCode != 0) {
                
                NSString *ResponseStr = [self showErrorInfoWithStatusCode:httpResponse.statusCode];
                
                //保证正确的闭包块在主线程中运行
                if([NSThread currentThread].isMainThread)
                    failure(ResponseStr);
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(ResponseStr);
                    });
                }
            } else {
                NSString *ErrorCode = [self showErrorInfoWithStatusCode:error.code];
                
                //保证正确的闭包块在主线程中运行
                if([NSThread currentThread].isMainThread)
                    failure(ErrorCode);
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(ErrorCode);
                    });
                }
            }
        }
    }];
    [task resume];
}

#pragma mark -- 拼接参数
+ (NSString *)dealWithParam:(NSDictionary *)param
{
    NSArray *allkeys = [param allKeys];
    NSMutableString *result = [NSMutableString string];
    
    for (NSString *key in allkeys) {
        NSString *string = [NSString stringWithFormat:@"%@=%@&", key, param[key]];
        [result appendString:string];
    }
    return result;
}

#pragma mark
+ (NSString *)showErrorInfoWithStatusCode:(NSInteger)statusCode{
    
    NSString *message = nil;
    switch (statusCode) {
        case 401: {
            
        }
            break;
            
        case 500: {
            message = @"服务器异常！";
        }
            break;
            
        case -1001: {
            message = @"网络请求超时，请稍后重试！";
        }
            break;
            
        case -1002: {
            message = @"不支持的URL！";
        }
            break;
            
        case -1003: {
            message = @"未能找到指定的服务器！";
        }
            break;
            
        case -1004: {
            message = @"服务器连接失败！";
        }
            break;
            
        case -1005: {
            message = @"连接丢失，请稍后重试！";
        }
            break;
            
        case -1009: {
            message = @"互联网连接似乎是离线！";
        }
            break;
            
        case -1012: {
            message = @"操作无法完成！";
        }
            break;
            
        default: {
            message = @"网络请求发生未知错误，请稍后再试！";
        }
            break;
    }
    return message;
    
}

@end

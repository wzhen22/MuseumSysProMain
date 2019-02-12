//
//  SysPubHttpKit.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SysPubHttpKit.h"
#import <AFHTTPSessionManager.h>
#pragma mark ThirdPartLibs export
#import "AFNetworking.h"
#import "AFNetworkReachabilityManager.h"

static SysPubHttpKit *globalSysPubNetKit;

@interface SysPubHttpKit ()
- (void)runSuccessBlockWith:(id)targetRetValue andSuccessBlock:(void (^)(id))successBlock;
- (void)runFailBlockWith:(NSError*)targetError andContextInfo:(id)targetContextInfo andFailBlock:(void (^)(NSError *, id))failBlock;
- (BOOL)checkCMCCAppKitDelegateWith:(void (^)(NSError *, id))failBlock;
- (NSString*)getCMCCAppKitBaseServerUrl;
- (void)addCommonHeaderValueTo:(NSMutableURLRequest*)targetHTTPUrlRequest;
- (id)getCMCCJsonNetRetWith:(NSString*)targetApiName andResponseObj:(id)responseObject andFailBlock:(void (^)(NSError *, id))failBlock;
@end

@implementation SysPubHttpKit

+ (instancetype)shareHttpKit
{
    if(globalSysPubNetKit == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            globalSysPubNetKit = [[SysPubHttpKit alloc] init];
            globalSysPubNetKit.operationDic = [[NSMutableDictionary alloc]init];
        });
    }
    
    return globalSysPubNetKit;
}

- (void)runSuccessBlockWith:(id)targetRetValue
            andSuccessBlock:(void (^)(id))successBlock
{
    //保证正确的闭包块在主线程中运行
    if(successBlock == nil) return;
    if([NSThread currentThread].isMainThread)
        successBlock(targetRetValue);
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            successBlock(targetRetValue);
        });
    }
}


- (void)runFailBlockWith:(NSError *)targetError
          andContextInfo:(id)targetContextInfo
            andFailBlock:(void (^)(NSError *, id))failBlock
{
    //保证错误的闭包块在主线程中运行
    if(failBlock == nil) return;
    if([NSThread currentThread].isMainThread){
        failBlock(targetError,targetContextInfo);
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            failBlock(targetError,targetContextInfo);
        });
    }
}


- (NSString*)getCMCCAppKitBaseServerUrl
{
    //获取App中提供的基准服务器地址
    //    id appDel = [UIApplication sharedApplication].delegate;
    //    HTTP_SERVER;
    NSString *baseUrl =  BASE_HTTP_SERVER;
    return baseUrl;
}


- (BOOL)checkCMCCAppKitDelegateWith:(void (^)(NSError *, id))failBlock
{
    //    id appDel = [UIApplication sharedApplication].delegate;
    NSString *baseUrl = BASE_HTTP_SERVER;
    if (baseUrl == nil || [baseUrl isEqual:@""]) {
        NSError *retError = [[NSError alloc] initWithDomain:@"CMCCIOTAppKitDelegate Check Domain" code:-1 userInfo:@{@"errorDes":@"UIApplication provide nil base url"}];
        [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
        return NO;
        
    }
    return YES;
}


- (void)addCommonHeaderValueTo:(NSMutableURLRequest *)targetHTTPUrlRequest
{
    //在这里添加统一的请求Header
}


- (id)getCMCCJsonNetRetWith:(NSString*)targetApiName andResponseObj:(id)responseObject andFailBlock:(void (^)(NSError *, id))failBlock
{
    //统一判断返回值是否错误
    if(responseObject == nil)
    {
        //返回值为空
        NSError *retError = [[NSError alloc] initWithDomain:@"CMCCIOTAppKit Net Domain" code:-3 userInfo:@{@"errorDes":[NSString stringWithFormat:@"%@: responseObject is nil",targetApiName]}];
        [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
        return nil;
    }
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        return responseObject;
    }
    
    if(![responseObject isKindOfClass:[NSData class]])
    {
        //返回值类型错误
        NSError *retError = [[NSError alloc] initWithDomain:@"CMCCIOTAppKit Net Domain" code:-4 userInfo:@{@"errorDes":[NSString stringWithFormat:@"%@: responseObject is not NSData type",targetApiName]}];
        [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
        return nil;
    }
    
    
    NSError *convertJsonError;
    id retJsonValue = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&convertJsonError];
    if(retJsonValue == nil || convertJsonError != nil)
    {
        //返回值无法转换为Json对象
        NSString *errorJsonRet = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *retError = nil;
        if(errorJsonRet != nil)
            retError = [[NSError alloc] initWithDomain:@"CMCCIOTAppKit Net Domain" code:-4 userInfo:@{@"errorDes":[NSString stringWithFormat:@"%@: responseObject can't convert to json, the retStr is %@",targetApiName,errorJsonRet]}];
        else
            retError = [[NSError alloc] initWithDomain:@"CMCCIOTAppKit Net Domain" code:-4 userInfo:@{@"errorDes":[NSString stringWithFormat:@"%@: responseObject can't convert to json",targetApiName]}];
        [self runFailBlockWith:retError andContextInfo:nil andFailBlock:failBlock];
        return nil;
    }
    
    return retJsonValue;
}


- (void)sPubInvokeApiWithGetMethond:(NSString *)targetApiName
                         andParams:(NSDictionary *)targetRequestInfo
                   andSuccessBlock:(void (^)(id))successBlock
                      andFailBlock:(void (^)(NSError *, id))failBlock
{
    if(![self checkCMCCAppKitDelegateWith:failBlock]) return;
    NSString *tempApiName = targetApiName != nil ? targetApiName : @"";
    NSString *baseUrl = [self getCMCCAppKitBaseServerUrl];
    NSString *targetUrlStr = [NSString stringWithFormat:@"%@%@",baseUrl,tempApiName];
    //组装get请求
    NSString *requestPath = @"";
    
    if (targetRequestInfo.allKeys.count == 0) {
        requestPath = targetUrlStr;
    }
    
    int i = 0;
    for (NSString *key in targetRequestInfo.allKeys)
    {
        if ([targetRequestInfo objectForKey:key] !=nil)
        {
            if (i == 0) {
                requestPath = [NSString stringWithFormat:@"%@?%@=%@",targetUrlStr,key,[targetRequestInfo objectForKey:key]];
            }
            else
            {
                requestPath = [NSString stringWithFormat:@"%@&%@=%@",requestPath,key,[targetRequestInfo objectForKey:key]];
            }
            i++;
        }
        
    }
    
    NSMutableURLRequest *httpRequst = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[requestPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    DLog(@"get requestPath :%@",requestPath);
    
    [httpRequst setHTTPMethod:@"GET"];
    //    [self addCommonHeaderValueTo:httpRequst];
    
    /**  AFN3.0  #import <AFHTTPSessionManager.h> */
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    AFJSONRequestSerializer * requestSerializer = [AFJSONRequestSerializer serializer];
//    [requestSerializer setValue:[Singleton getHttpToken] forHTTPHeaderField:@"Authorization"];
    session.requestSerializer  = requestSerializer;
    // 加上这行代码，https ssl 验证。
    [session setSecurityPolicy:[self customSecurityPolicy]];
    
    AFJSONResponseSerializer * XJSONResponseSerializer = [AFJSONResponseSerializer serializer];
    XJSONResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/xml",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    session.responseSerializer  = XJSONResponseSerializer;
    
    NSURLSessionDataTask * task = [session GET:requestPath parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id retJsonValue = [self getCMCCJsonNetRetWith:targetApiName andResponseObj:responseObject andFailBlock:failBlock];
        if(retJsonValue == nil) return;
#if SysPubNeedPrintNetRetValue
        id jsonStringToPrint  = responseObject;
        if ([responseObject isKindOfClass:[NSData class]]) {
            jsonStringToPrint = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        }
        if(jsonStringToPrint != nil)
        {
            //后续NSLog可以替换自身的宏定义
            DLog(@"%@",@"----------- begin print api invoke --------------------");
            DLog(@"ThePostApiName is %@ , postValue is %@,  get the retValue is %@",targetApiName,(targetRequestInfo == nil)?@"":targetRequestInfo,retJsonValue);
            DLog(@"%@",@"----------- end print api invoke ----------------------");
        }
#endif
        [self runSuccessBlockWith:retJsonValue andSuccessBlock:successBlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self runFailBlockWith:error andContextInfo:nil andFailBlock:failBlock];
    }];
    
    
    [self ADDNetWorkToOperationDicWithOperation:task CommandKey:targetApiName];
}


- (void)sPubInvokeApiWithPostMethod:(NSString *)targetApiName
                         andParams:(NSDictionary *)targetRequestInfo
                   andSuccessBlock:(void (^)(id))successBlock
                      andFailBlock:(void (^)(NSError *, id))failBlock
{
    if(![self checkCMCCAppKitDelegateWith:failBlock]) return;
    NSString *tempApiName = targetApiName != nil ? targetApiName : @"";
    NSString *baseUrl = [self getCMCCAppKitBaseServerUrl];
    NSString *targetUrlStr = [NSString stringWithFormat:@"%@%@",baseUrl,tempApiName];
    
    NSMutableURLRequest *httpRequst = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[targetUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [httpRequst setHTTPMethod:@"POST"];
    [self addCommonHeaderValueTo:httpRequst];
    NSData *jsonData;
    if(targetRequestInfo != nil && [NSJSONSerialization isValidJSONObject:targetRequestInfo])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:targetRequestInfo options:NSJSONWritingPrettyPrinted error:nil];
        [httpRequst setHTTPBody:jsonData];
    }
    //在这里添加请求Header
    [httpRequst setValue:[@([jsonData length]) stringValue] forHTTPHeaderField:@"Content-Length"];
    [httpRequst setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [httpRequst setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSLog(@"httpRequst  Authorization:%@",[httpRequst valueForHTTPHeaderField:@"Authorization"]);
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    AFJSONRequestSerializer * requestSerializer = [AFJSONRequestSerializer serializer];
//    [requestSerializer setValue:[Singleton getHttpToken] forHTTPHeaderField:@"Authorization"];
    session.requestSerializer  = requestSerializer;
    // 加上这行代码，https ssl 验证。
    [session setSecurityPolicy:[self customSecurityPolicy]];
    
    AFJSONResponseSerializer * XJSONResponseSerializer = [AFJSONResponseSerializer serializer];
    XJSONResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/xml",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    session.responseSerializer  = XJSONResponseSerializer;
    
    
    NSURLSessionDataTask * task = [session POST:targetUrlStr parameters:targetRequestInfo progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id retJsonValue = [self getCMCCJsonNetRetWith:targetApiName andResponseObj:responseObject andFailBlock:failBlock];
        if(retJsonValue == nil) return;
#if SysPubNeedPrintNetRetValue
        id jsonStringToPrint  = responseObject;
        if ([responseObject isKindOfClass:[NSData class]]) {
            jsonStringToPrint = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        }
        if(jsonStringToPrint != nil)
        {
            //后续NSLog可以替换自身的宏定义
            DLog(@"%@",@"----------- begin print api invoke --------------------");
            DLog(@"ThePostApiName is %@ , postValue is %@,  get the retValue is %@",targetApiName,(targetRequestInfo == nil)?@"":targetRequestInfo,retJsonValue);
            DLog(@"%@",@"----------- end print api invoke ----------------------");
        }
#endif
        [self runSuccessBlockWith:retJsonValue andSuccessBlock:successBlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self runFailBlockWith:error andContextInfo:nil andFailBlock:failBlock];
    }];
    [self ADDNetWorkToOperationDicWithOperation:task CommandKey:targetApiName];
}

//===================
- (void)sPubInvokeApiWithGetBaseURL:(NSString *)baseURL
                        andMethond:(NSString*)targetApiName
                         andParams:(NSDictionary *)targetRequestInfo
                   andSuccessBlock:(void (^)(id))successBlock
                      andFailBlock:(void (^)(NSError *, id))failBlock
{
    if(![self checkCMCCAppKitDelegateWith:failBlock]) return;
    NSString *tempApiName = targetApiName != nil ? targetApiName : @"";
    NSString *baseUrl = baseURL;
    NSString *targetUrlStr = [NSString stringWithFormat:@"%@%@",baseUrl,tempApiName];
    //组装get请求
    NSString *requestPath = @"";
    
    if (targetRequestInfo.allKeys.count == 0) {
        requestPath = targetUrlStr;
    }
    
    int i = 0;
    for (NSString *key in targetRequestInfo.allKeys)
    {
        if ([targetRequestInfo objectForKey:key] !=nil)
        {
            if (i == 0) {
                requestPath = [NSString stringWithFormat:@"%@?%@=%@",targetUrlStr,key,[targetRequestInfo objectForKey:key]];
            }
            else
            {
                requestPath = [NSString stringWithFormat:@"%@&%@=%@",requestPath,key,[targetRequestInfo objectForKey:key]];
            }
            i++;
        }
    }
    //    NSError * error = nil;
    //    NSMutableURLRequest *httpRequst = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:targetUrlStr parameters:nil error:&error];
    //    NSLog(@"get requestPath :%@",requestPath);
    
    //    [self addCommonHeaderValueTo:httpRequst];
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    AFJSONRequestSerializer * requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *allHeaders = [SysPubSingleThings sharePublicSingle].loginCookie;
    NSString *cookieStr = [allHeaders safeObjectForKey:@"Set-Cookie"];
    NSString *tokenStr = [allHeaders safeObjectForKey:@"X-CSRF-TOKEN"];
    [requestSerializer setValue:cookieStr forHTTPHeaderField:@"cookie"];
    [requestSerializer setValue:tokenStr forHTTPHeaderField:@"X-CSRF-TOKEN"];
    session.requestSerializer  = requestSerializer;
    // 加上这行代码，https ssl 验证。
    [session setSecurityPolicy:[self customSecurityPolicy]];
    
    AFJSONResponseSerializer * XJSONResponseSerializer = [AFJSONResponseSerializer serializer];
    XJSONResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/xml",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    session.responseSerializer  = XJSONResponseSerializer;
    
    NSLog(@"targetUrlStr:%@",targetUrlStr);
    NSURLSessionDataTask * task = [session GET:targetUrlStr parameters:targetRequestInfo progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id retJsonValue = [self getCMCCJsonNetRetWith:targetApiName andResponseObj:responseObject andFailBlock:failBlock];
        if(retJsonValue == nil) return;
#if SysPubNeedPrintNetRetValue
        id jsonStringToPrint  = responseObject;
        if ([responseObject isKindOfClass:[NSData class]]) {
            jsonStringToPrint = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        }
        if(jsonStringToPrint != nil)
        {
            //后续NSLog可以替换自身的宏定义
//            DLog(@"%@",@"----------- begin print api invoke --------------------");
//            DLog(@"ThePostApiName is %@ , postValue is %@,  get the retValue is %@",targetApiName,(targetRequestInfo == nil)?@"":targetRequestInfo,retJsonValue);
//            DLog(@"%@",@"----------- end print api invoke ----------------------");
        }
#endif
        [self runSuccessBlockWith:retJsonValue andSuccessBlock:successBlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = response.statusCode;
        if (statusCode == 401 || statusCode == 402) {
            //重新登录
            [self loginHttpRequest];
        }
        [self runFailBlockWith:error andContextInfo:nil andFailBlock:failBlock];
    }];
    
    [self ADDNetWorkToOperationDicWithOperation:task CommandKey:targetApiName];
}


- (void)sPubInvokeApiWithPostBaseURL:(NSString *)baseURL
                         andMethond:(NSString*)targetApiName
                          andParams:(NSDictionary *)targetRequestInfo
                    andSuccessBlock:(void (^)(id))successBlock
                       andFailBlock:(void (^)(NSError *, id))failBlock
{
    if(![self checkCMCCAppKitDelegateWith:failBlock]) return;
    NSString *tempApiName = targetApiName != nil ? targetApiName : @"";
    NSString *baseUrl = baseURL;
    NSString *targetUrlStr = [NSString stringWithFormat:@"%@%@",baseUrl,tempApiName];
    DLog(@"post requestPath :%@",targetUrlStr);
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFJSONRequestSerializer * requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *allHeaders = [SysPubSingleThings sharePublicSingle].loginCookie;
    NSString *cookieStr = [allHeaders safeObjectForKey:@"Set-Cookie"];
    NSString *tokenStr = [allHeaders safeObjectForKey:@"X-CSRF-TOKEN"];
//    NSLog(@"cookieStr:%@,tokenStr:%@",cookieStr,tokenStr);
    [requestSerializer setValue:cookieStr forHTTPHeaderField:@"cookie"];
    [requestSerializer setValue:tokenStr forHTTPHeaderField:@"X-CSRF-TOKEN"];
    session.requestSerializer  = requestSerializer;
    // 加上这行代码，https ssl 验证。
    [session setSecurityPolicy:[self customSecurityPolicy]];
    
    
    NSURLSessionDataTask * task = [session POST:targetUrlStr parameters:targetRequestInfo progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //定制化需求http://inspection.museum.cqcztech.com/login
        if ([targetUrlStr hasSuffix:@"/login"]) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSDictionary *allHeaders = response.allHeaderFields;
//            NSLog(@"allHeaders:%@",allHeaders);
            NSString *cookieStr = [allHeaders safeObjectForKey:@"Set-Cookie"];
            if (cookieStr.length) {
                [SysPubSingleThings sharePublicSingle].loginCookie = allHeaders;
            }
        }
        id retJsonValue = [self getCMCCJsonNetRetWith:targetApiName andResponseObj:responseObject andFailBlock:failBlock];
        if(retJsonValue == nil) return;
        
#if SysPubNeedPrintNetRetValue
        id jsonStringToPrint  = responseObject;
        if ([responseObject isKindOfClass:[NSData class]]) {
            jsonStringToPrint = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        }
        if(jsonStringToPrint != nil)
        {
            //后续NSLog可以替换自身的宏定义
//            DLog(@"%@",@"----------- begin print api invoke --------------------");
//            DLog(@"ThePostApiName is %@ , postValue is %@,  get the retValue is %@",targetApiName,(targetRequestInfo == nil)?@"":targetRequestInfo,retJsonValue);
//            DLog(@"%@",@"----------- end print api invoke ----------------------");
        }
#endif
        [self runSuccessBlockWith:retJsonValue andSuccessBlock:successBlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = response.statusCode;
        if (statusCode == 401 || statusCode == 402) {
            //重新登录
            [self loginHttpRequest];
        }
        [self runFailBlockWith:error andContextInfo:nil andFailBlock:failBlock];
    }];
    [self ADDNetWorkToOperationDicWithOperation:task CommandKey:targetApiName];
}

//添加
-(void)ADDNetWorkToOperationDicWithOperation:(NSURLSessionDataTask *)Operation CommandKey:(NSString * )CommandKey{
    
    [_operationDic setObject:Operation forKey:CommandKey];
}

//取消所有网络请求
- (void)cancelAllRequest
{
    [_operationDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self cancelRequest:(NSURLSessionDataTask *)obj];
    }];
}


//删除网络请求线程
- (void)cancelRequest:(NSURLSessionDataTask *)operation
{
    if (operation) {
        [operation cancel];
    }
}

//取消某一个
-(void)sPubInvokeApiCancelNetWWithCommandKey:(NSString *)CommandKey
{
    NSURLSessionDataTask * operation = [_operationDic objectForKey:CommandKey];
    //如果网络请求存在,取消网络请求
    if (operation) {
        [self cancelRequest:operation];
    }
}
//ssl加密验证
- (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"cbg.cn" ofType:@"cer"];//证书的路径
    //    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    //
    //    // AFSSLPinningModeCertificate 使用证书验证模式
    //    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //
    //    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //    // 如果是需要验证自建证书，需要设置为YES
    //    securityPolicy.allowInvalidCertificates = YES;
    //
    //    //validatesDomainName 是否需要验证域名，默认为YES；
    //    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //    //如置为NO，建议自己添加对应域名的校验逻辑。
    //    securityPolicy.validatesDomainName = NO;
    //
    //    securityPolicy.pinnedCertificates = [NSSet setWithObjects:certData, nil];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    return securityPolicy;
}
//私有方法
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
@end

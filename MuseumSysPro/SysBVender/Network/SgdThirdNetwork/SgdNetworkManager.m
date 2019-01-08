//
//  SgdNetworkManager.m
//  HTTPNetworkLibrary
//
//  Created by 王志盼 on 2017/1/3.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import "SgdNetworkManager.h"
#import "SgdQueryStringPair.h"
#import "SgdFileEntity.h"


@interface SgdNetworkManager()
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, assign) SgdNetworkManagerMethodType type;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSArray<SgdFileEntity *> *fileArr;

@property (nonatomic, copy) void(^callBack)(NSData *data, NSURLResponse *response, NSError *error);


@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSURLSessionDataTask *task;
@end

@implementation SgdNetworkManager

FOUNDATION_EXPORT NSArray * SgdQueryStringPairsFromDictionary(NSDictionary *dictionary);
FOUNDATION_EXPORT NSArray * SgdQueryStringPairsFromKeyAndValue(NSString *key, id value);

- (instancetype)initWithUrlStr:(NSString *)urlStr type:(SgdNetworkManagerMethodType)type params:(NSDictionary *)params callBack:(void(^)(NSData *data, NSURLResponse *response, NSError *error))callBack
{
    if (self = [super init])
    {
        self.urlStr = urlStr;
        self.params = params;
        self.type = type;
        self.callBack = callBack;
        self.session = [NSURLSession sharedSession];
        
        switch (type) {
            case SgdNetworkManagerMethodTypeGet:
                self.method = @"GET";
                break;
                
            case SgdNetworkManagerMethodTypePost:
                self.method = @"POST";
                break;
                
            case SgdNetworkManagerMethodTypeHead:
                self.method = @"HEAD";
                break;
            default:
                break;
        }
    }
    return self;
}

- (instancetype)initWithUrlStr:(NSString *)urlStr type:(SgdNetworkManagerMethodType)type params:(NSDictionary *)params fileArr:(NSArray<SgdFileEntity *> *)fileArr callBack:(void(^)(NSData *data, NSURLResponse *response, NSError *error))callBack
{
    if (self = [super init])
    {
        self.urlStr = urlStr;
        self.params = params;
        self.type = type;
        self.callBack = callBack;
        self.session = [NSURLSession sharedSession];
        self.fileArr = fileArr;
        
        switch (type) {
            case SgdNetworkManagerMethodTypeGet:
                self.method = @"GET";
                break;
                
            case SgdNetworkManagerMethodTypePost:
                self.method = @"POST";
                break;
                
            case SgdNetworkManagerMethodTypeHead:
                self.method = @"HEAD";
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)dealloc
{
    //销毁session对象
    [self.session invalidateAndCancel];
}

- (void)bulidRequest
{
    NSString *completeUrlStr = self.urlStr;
    NSString *paramStr = nil;
    if (self.type == SgdNetworkManagerMethodTypeGet && self.params != nil && self.params.count >0)
    {
        paramStr = SgdQueryStringFromParameters(self.params);
        completeUrlStr = [NSString stringWithFormat:@"%@?%@", self.urlStr, paramStr];
        
    }
    self.request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:completeUrlStr] cachePolicy:0 timeoutInterval:10];
    self.request.HTTPMethod = self.method;
    
    if (self.fileArr.count > 0)
    {
        [self.request setValue:@"multipart/form-data; boundary=PitayaUGl0YXlh" forHTTPHeaderField:@"Content-Type"];
    }
    else if (self.params.count > 0)
    {
        [self.request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
}

- (void)bulidBody
{
    NSMutableData *data = [NSMutableData data];
    
    if (self.fileArr != nil && self.fileArr.count > 0)
    {
        //拼接参数
        for (NSString *key in self.params.allKeys)
        {
            NSObject *value = self.params[key];
            [data appendData:[[NSString stringWithFormat:@"--PitayaUGl0YXlh\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *tmpStr = [NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", key];
            [data appendData: [tmpStr dataUsingEncoding:NSUTF8StringEncoding]];
            tmpStr = [NSString stringWithFormat:@"%@\r\n", value.description];
            [data appendData: [tmpStr dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        //拼接图片
        for (SgdFileEntity *entity in self.fileArr)
        {
            [data appendData:[[NSString stringWithFormat:@"--PitayaUGl0YXlh\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *tmpStr = [NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; fileName=%@ \r\n\r\n", entity.name, entity.url.description.lastPathComponent];
            [data appendData: [tmpStr dataUsingEncoding:NSUTF8StringEncoding]];
            NSData *imageData = [NSData dataWithContentsOfURL:entity.url];
            [data appendData:imageData];
            [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [data appendData:[[NSString stringWithFormat:@"--PitayaUGl0YXlh--\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else if (self.type == SgdNetworkManagerMethodTypePost && self.params != nil && self.params.count >0)
    {
        [data appendData:[SgdQueryStringFromParameters(self.params) dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    self.request.HTTPBody = data;
    
}

- (void)executeTask
{
    self.task = [self.session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (self.callBack)
        {
            self.callBack(data, response, error);
        }
    }];
    
    [self.task resume];
}

//开始请求服务器
- (void)executeRequest
{
    [self bulidRequest];
    [self bulidBody];
    [self executeTask];
}

#pragma mark - 封装的类方法

+ (void)executeGet:(NSString *)urlStr params:(NSDictionary *)params callBack:(void(^)(NSData *data, NSURLResponse *response, NSError *error))callBack
{
    SgdNetworkManager *manager = [[self alloc] initWithUrlStr:urlStr type:SgdNetworkManagerMethodTypeGet params:params callBack:callBack];
    [manager executeRequest];
}

+ (void)executePost:(NSString *)urlStr params:(NSDictionary *)params callBack:(void(^)(NSData *data, NSURLResponse *response, NSError *error))callBack
{
    SgdNetworkManager *manager = [[self alloc] initWithUrlStr:urlStr type:SgdNetworkManagerMethodTypePost params:params callBack:callBack];
    [manager executeRequest];
}

+ (void)uploadFile:(NSString *)urlStr params:(NSDictionary *)params files:(NSArray<SgdFileEntity *>*)files callBack:(void(^)(NSData *data, NSURLResponse *response, NSError *error))callBack
{
    SgdNetworkManager *manager = [[self alloc] initWithUrlStr:urlStr type:SgdNetworkManagerMethodTypePost params:params fileArr:files callBack:callBack];
    [manager executeRequest];
}

#pragma mark - 处理请求参数的拼接，拷贝自AFN

static NSString * SgdQueryStringFromParameters(NSDictionary *parameters) {
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (SgdQueryStringPair *pair in SgdQueryStringPairsFromDictionary(parameters)) {
        [mutablePairs addObject:[pair URLEncodedStringValue]];
    }
    
    return [mutablePairs componentsJoinedByString:@"&"];
}

NSArray * SgdQueryStringPairsFromDictionary(NSDictionary *dictionary) {
    return SgdQueryStringPairsFromKeyAndValue(nil, dictionary);
}

NSArray * SgdQueryStringPairsFromKeyAndValue(NSString *key, id value) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = value;
        // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            id nestedValue = dictionary[nestedKey];
            if (nestedValue) {
                [mutableQueryStringComponents addObjectsFromArray:SgdQueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        for (id nestedValue in array) {
            [mutableQueryStringComponents addObjectsFromArray:SgdQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
        }
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = value;
        for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            [mutableQueryStringComponents addObjectsFromArray:SgdQueryStringPairsFromKeyAndValue(key, obj)];
        }
    } else {
        [mutableQueryStringComponents addObject:[[SgdQueryStringPair alloc] initWithField:key value:value]];
    }
    
    return mutableQueryStringComponents;
}

@end

//
//  SgdFileDownLoad.m
//  HTTPNetworkLibrary
//
//  Created by 王志盼 on 2017/2/12.
//  Copyright © 2017年 王志盼. All rights reserved.
//

#import "SgdFileDownLoad.h"

#define DirectoryName @"SgdFileDownLoadDirectory"

#define FileTotalSizeName @"SgdFileTotalSizeName"

#define DirectoryPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:DirectoryName]

@interface SgdFileDownLoad () <NSURLSessionDataDelegate>
@property (nonatomic, strong) NSOutputStream *outputStream;

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) NSURLSession *session;

//将urlStr转化后产生的urlPath
@property (nonatomic, copy) NSString *urlPath;

@end

//存储正在删除的文件的url
static NSMutableArray *_delArr;

@implementation SgdFileDownLoad

+(void)load
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (_delArr == nil)
        {
            _delArr = [NSMutableArray array];
        }
    });
}

- (void)start
{
    for (int i = 0; i < _delArr.count; i++)    //是否正在删除这个url所在的文件
    {
        NSString *delStr = _delArr[i];
        
        if ([delStr isEqualToString:self.urlStr])
        {
            NSLog(@"error: 正在删除该文件");
            return;
        }
    }
    
    [self createDirectoryForDownLoadFile];
    
    [self fetchCurrentSize];
    
    [self fetchFileTotalSize];
    
    if (self.totalSize)
    {
        self.progressHandler ? self.progressHandler(self.currentSize / (self.totalSize * 1.0)) : nil;
    }
    
    _downLoading = YES;
    [self.dataTask resume];
}

/*暂停下载*/
- (void)pause
{
    _downLoading = NO;
    [self.dataTask suspend];
}


- (void)cancle
{
    _downLoading = NO;
    
    !self.progressHandler? :self.progressHandler(0);
    [self.dataTask cancel];
    [self.outputStream close];
    [self.session invalidateAndCancel];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *tmpUrlStr = [self.urlStr mutableCopy];
    [_delArr addObject:tmpUrlStr];
    //如果文件存在沙盒中
    if ([fileManager fileExistsAtPath:self.storePath])
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [fileManager removeItemAtPath:self.storePath error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delArr removeObject:tmpUrlStr];
            });
        });
        
    }
    NSString *tmpStr = [NSString stringWithFormat:@"%@%@", self.urlPath, FileTotalSizeName];
    NSString *fileSizePath = [DirectoryPath stringByAppendingPathComponent:tmpStr];
    //如果文件totalSize存在沙盒中
    if ([fileManager fileExistsAtPath:fileSizePath])
    {
        [fileManager removeItemAtPath:fileSizePath error:nil];
    }
    
    self.session = nil;
    self.dataTask = nil;
    self.outputStream = nil;
    self.urlPath = nil;
    _currentSize = 0;
    _totalSize = 0;
    self.progressHandler = nil;
    self.urlStr = nil;
}


- (void)dealloc
{
    //销毁session对象
    [self.session invalidateAndCancel];
}

#pragma mark - private method

//创建一个专用于装下载文件的文件夹
- (void)createDirectoryForDownLoadFile
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![fileManager fileExistsAtPath:DirectoryPath])
    {
        [fileManager createDirectoryAtPath:DirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    _storePath = [DirectoryPath stringByAppendingPathComponent:self.urlPath];
}

/*得到文件当前下载大小*/
- (void)fetchCurrentSize
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *infoDict = [fileManager attributesOfItemAtPath:self.storePath error:nil];
//    NSLog(@"%@", infoDict);
    
    _currentSize = 0;
    if (infoDict)
    {
        _currentSize = [infoDict[@"NSFileSize"] longLongValue];
    }
    
    
}

/*存储文件总大小到沙盒中*/
- (void)storeFileTotalSize:(long long)size
{
    NSString *tmpStr = [NSString stringWithFormat:@"%@%@", self.urlPath, FileTotalSizeName];
    NSString *fileSizePath = [DirectoryPath stringByAppendingPathComponent:tmpStr];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[FileTotalSizeName] = @(size);
    [dict writeToFile:fileSizePath atomically:YES];
}

/*获取沙盒中存储的文件总大小*/
- (void)fetchFileTotalSize
{
    NSString *tmpStr = [NSString stringWithFormat:@"%@%@", self.urlPath, FileTotalSizeName];
    NSString *fileSizePath = [DirectoryPath stringByAppendingPathComponent:tmpStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:fileSizePath];
    _totalSize = 0;
    if (dict)
    {
        _totalSize = [dict[FileTotalSizeName] longLongValue];
    }
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    _totalSize = response.expectedContentLength + self.currentSize;
    [self storeFileTotalSize:self.totalSize];
    
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.storePath append:YES];
    [self.outputStream open];
    
    completionHandler(NSURLSessionResponseAllow); //响应
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.outputStream write:data.bytes maxLength:data.length];
    _currentSize += data.length;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.progressHandler)
        {
            self.progressHandler(self.currentSize / (self.totalSize * 1.0));
        }
    });
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    [self.outputStream close];
    _downLoading = NO;
    if (error)
    {
        NSLog(@"下载出错，文件URL: %@", self.urlStr);
    }
}

#pragma mark - getter && setter
- (NSURLSession *)session
{
    if (!_session)
    {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _session;
}

- (NSURLSessionDataTask *)dataTask
{
    if (!_dataTask)
    {
        NSURL *url = [NSURL URLWithString:self.urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        
        NSString *header = [NSString stringWithFormat:@"bytes=%lld-", self.currentSize];
        [request setValue:header forHTTPHeaderField:@"Range"];
        _dataTask = [self.session dataTaskWithRequest:request];
    }
    return _dataTask;
}

- (void)setUrlStr:(NSString *)urlStr
{
    _urlStr = urlStr;
    self.urlPath = [urlStr stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
}

@end

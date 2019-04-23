//
//  HQMUploadRequest.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/25.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "HQMUploadRequest.h"
#import "AFNetworking.h"

@implementation HQMUploadRequest

- (HQMRequestMethod)requestMethod {
    return HQMRequestMethodPOST;
}
- (HQMRequestSerializerType)requestSerializerType{
    return HQMRequestSerializerTypeJSON;
}
- (HQMResponseSerializerType)responseSerializerType{
    return HQMResponseSerializerTypeXMLParser;
}
- (NSString *)requestURLPath {
    return @"/sys/file/item/upload";
}

- (NSDictionary *)requestArguments {
    return @{
             ///< 注意：两种方式传参 --> 1.直接设置 POST 请求的参数来传递
//             @"files[]": @"1181",
              @"modelName": @"common"
             };
}
///< 配置请求头，根据需求决定是否重写
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    NSDictionary *allHeaders = [SysPubSingleThings sharePublicSingle].loginCookie;
    NSString *cookieStr = [allHeaders safeObjectForKey:@"Set-Cookie"];
    NSString *tokenStr = [allHeaders safeObjectForKey:@"X-CSRF-TOKEN"];
    NSLog(@"cookieStr:%@,tokenStr:%@",cookieStr,tokenStr);
    NSDictionary *requestSerializer = [[NSDictionary alloc]initWithObjectsAndKeys:cookieStr,@"cookie",tokenStr,@"X-CSRF-TOKEN", nil];
    return requestSerializer;
//    return nil;
}

- (AFConstructingBodyBlock)constructingBodyBlock {
    @weakify(self);
    void (^bodyBlock)(id<AFMultipartFormData> formData) = ^(id<AFMultipartFormData> formData) {
        @strongify(self);
        
//        NSAssert(self.images.count != 0, @"上传内容没有包括图片"); ///< 断言，防止图片数组为空
        
        NSInteger imgIndex = 0;
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        // 设置日期格式
//        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
//        int value = (arc4random() % 100) + 1;
//        NSString *dateString = [NSString stringWithFormat:@"%d_%@",value,timeSp];
        
        int value = (arc4random() % 10000) + 1;
        NSString *rStr = [self randomStringWithLength:3];
        NSString *dateString = [NSString stringWithFormat:@"%@%d_%@",rStr,value,timeSp];
        for (UIImage *img in self.images) {
            NSString *fileName = [NSString stringWithFormat:@"%@%@.png", dateString, @(imgIndex)];
            NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
            [formData appendPartWithFileData:imgData name:@"files[]" fileName:fileName mimeType:@"image/png/jpg/jpeg"];
            
            imgIndex++;
        }
//        ///< 注意：两种方式传参 --> 2.通过 body 体传
//        NSString *token = @"51d8ab705465128b27bd5cffa944db81";
//        NSString *uid = @"1160";
//        //直接拼接参数 注意 参数 要和服务端的字段一致
//        [formData appendPartWithFormData:[token dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
//        [formData appendPartWithFormData:[uid dataUsingEncoding:NSUTF8StringEncoding] name:@"uid"];
        
        //        if (self.avatar) {
        //            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //            // 设置日期格式
        //            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        //            NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
        //
        //            [formData appendPartWithFileData:self.avatar name:@"file" fileName:fileName mimeType:@"image/png"];
        //
        //            ///< 注意：两种方式传参 --> 2.通过 body 体传
        //            NSString *token = @"12d2eae5d0ec3b8b3d965f388127ddfd";
        //            NSString *uid = @"1181";
        //            //直接拼接参数 注意 参数 要和服务端的字段一致
        //            [formData appendPartWithFormData:[token dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
        //            [formData appendPartWithFormData:[uid dataUsingEncoding:NSUTF8StringEncoding] name:@"uid"];
        //        }
    };
    
    return bodyBlock;
}
-(NSString *)randomStringWithLength:(NSInteger)len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    return randomString;
}
- (void)handleData:(id)data errCode:(NSInteger)errCode {
    NSDictionary *dict = (NSDictionary *)data;
    NSString *path = nil;
    if (VALID_DICTIONARY(dict)) {
        path = [dict objectForKey:@"path"];
    }
    if (self.successBlock) {
        self.successBlock(errCode,dict,path);
    }
}


@end

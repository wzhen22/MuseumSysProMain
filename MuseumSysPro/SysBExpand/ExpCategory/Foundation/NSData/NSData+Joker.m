//
//  NSData+Joker.m
//  Additions_PS
//
//  Created by w on 15/1/4.
//  Copyright (c) 2015年 pengshuai. All rights reserved.
//

#import "NSData+Joker.h"
//#import <CommonCrypto/CommonCrypto.h>

#import <CommonCrypto/CommonCrypto.h>
@implementation NSData (Joker)

- (NSData *)AES256EncryptWithKey:(NSData *)key   //加密
{
    //對於塊加密算法，輸出大小總是等於或小於輸入大小加上一個塊的大小
    //所以在下邊需要再加上一個塊的大小
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding/*這裏就是剛才說到的PKCS7Padding填充了*/ | kCCOptionECBMode,
                                          [key bytes], kCCKeySizeAES256,
                                          NULL,/* 初始化向量(可選) */
                                          [self bytes], dataLength,/*輸入*/
                                          buffer, bufferSize,/* 輸出 */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);//釋放buffer
    return nil;
}

- (NSData *)AES256DecryptWithKey:(NSData *)key   //解密
{
    //同理，解密中，密鑰也是32位的
    const void * keyPtr2 = [key bytes];
    const char (*keyPtr)[32] = keyPtr2;
    
    //對於塊加密算法，輸出大小總是等於或小於輸入大小加上一個塊的大小
    //所以在下邊需要再加上一個塊的大小
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding/*這裏就是剛才說到的PKCS7Padding填充了*/ | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL,/* 初始化向量(可選) */
                                          [self bytes], dataLength,/* 輸入 */
                                          buffer, bufferSize,/* 輸出 */
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

@end

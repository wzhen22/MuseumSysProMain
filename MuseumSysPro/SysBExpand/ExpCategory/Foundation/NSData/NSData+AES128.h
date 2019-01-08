//
//  NSData+AES128.h
//  YuYanNet
//
//  Created by admin on 16/3/8.
//  Copyright © 2016年 cbg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES128)


-(NSData *)Aes128EncryWithKey:(NSString *)key;
-(NSData *)Aes128DecryWithKey:(NSString *)key;

-(NSString *)dataToString;

@end

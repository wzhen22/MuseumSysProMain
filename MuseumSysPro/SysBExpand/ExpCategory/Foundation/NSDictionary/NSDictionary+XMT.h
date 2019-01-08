//
//  NSDictionary+XMT.h
//  RainbowFM
//
//  Created by admin on 16/1/5.
//  Copyright © 2016年 RB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (XMT)

- (id)safeObjectForKey:(NSString *)key;

+ (NSDictionary *)_yy_dictionaryWithJSON:(id)json;
@end

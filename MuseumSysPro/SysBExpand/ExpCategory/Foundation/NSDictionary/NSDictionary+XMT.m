//
//  NSDictionary+XMT.m
//  RainbowFM
//
//  Created by admin on 16/1/5.
//  Copyright © 2016年 RB. All rights reserved.
//

#import "NSDictionary+XMT.h"

@implementation NSDictionary (XMT)

- (id)safeObjectForKey:(NSString *)key
{
    id object = [self objectForKey:key];
    if (self == nil || self == NULL || [self isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    
    if (object == nil || object == NULL || [object isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
        NSString *str = [object stringByTrimmingCharactersInSet:whitespace];
        if (str.length == 0)
        {
            return @"";
        }
    }
    
    return object;

}
+ (NSDictionary *)_yy_dictionaryWithJSON:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}

@end

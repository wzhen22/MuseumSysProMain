//
//  SysPubSingleThings.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SysPubSingleThings.h"

static dispatch_once_t getSysPubSharePublicSingle;//保证单例只创建一次

@implementation SysPubSingleThings

+(SysPubSingleThings *)sharePublicSingle{
    static SysPubSingleThings *sharePublicSingleWork=nil;
    
    @synchronized(self)
    {
        if (!sharePublicSingleWork){
            dispatch_once(&getSysPubSharePublicSingle, ^{
                sharePublicSingleWork = [[SysPubSingleThings alloc] init];
            });
        }
        return sharePublicSingleWork;
    }
    
}

@end

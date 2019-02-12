//
//  HQMUploadRequest.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/25.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "HQMBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface HQMUploadRequest : HQMBaseRequest

@property (nonatomic, strong) NSArray<UIImage *> *images;

@end

NS_ASSUME_NONNULL_END

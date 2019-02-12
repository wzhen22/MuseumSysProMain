//
//  UITableView+EmptyData.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/25.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (EmptyData)

//添加一个方法
- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;

@end

NS_ASSUME_NONNULL_END

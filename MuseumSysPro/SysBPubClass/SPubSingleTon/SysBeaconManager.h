//
//  SysBeaconManager.h
//  MuseumSysPro
//
//  Created by admin on 2019/2/20.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ScanResultBlock)(NSArray *deviceArray);

@interface SysBeaconManager : NSObject

@property(nonatomic,strong) UIViewController *awnVC;
@property(nonatomic,strong) NSArray *scannedDevice;
@property (nonatomic, copy) ScanResultBlock scanResultBlock;
+(SysBeaconManager *)sharedInstance;

- (void)scanBeaconAboutArray:(NSArray *)beaconArray;
- (void)stopScan;

@end

NS_ASSUME_NONNULL_END

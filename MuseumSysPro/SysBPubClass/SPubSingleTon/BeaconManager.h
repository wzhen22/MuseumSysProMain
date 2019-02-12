//
//  BeaconManager.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/24.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MinewBeacon.h"
#import "MinewBeaconValue.h"
#import "MinewBeaconManager.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ScanResultBlock)(NSArray *deviceArray);

@interface BeaconManager : NSObject<MinewBeaconManagerDelegate>
@property(nonatomic,strong) UIViewController *awnVC;
@property(nonatomic,strong) NSArray *scannedDevice;
@property (nonatomic, copy) ScanResultBlock scanResultBlock;
+(BeaconManager *)sharedInstance;

- (void)scanBeaconAboutArray:(NSArray *)beaconArray;
- (void)stopScan;

@end

NS_ASSUME_NONNULL_END

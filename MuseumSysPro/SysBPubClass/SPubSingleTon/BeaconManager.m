//
//  BeaconManager.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/24.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "BeaconManager.h"
#define uuid1 @"FDA50693-A4E2-4FB1-AFCF-C6EB07647825"
#define uuid2 @"AB8190D5-D11E-4941-ACC4-42F30510B408"

@implementation BeaconManager{
    MinewBeaconManager *_manager;
}
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _manager = [MinewBeaconManager sharedInstance];
        _manager.delegate = self;
    }
    return self;
}

+(BeaconManager *)sharedInstance
{
    static BeaconManager *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[BeaconManager alloc]init];
    });
    
    return m;
}

- (void)scanBeaconAboutArray:(NSArray *)beaconArray
{
    //用于测试
//    [_manager startScan:@[uuid1, uuid2] backgroundSupport:YES];

    if (beaconArray.count) {
        [_manager startScan:beaconArray backgroundSupport:YES];
        BluetoothState bs = [_manager checkBluetoothState];
        if ( bs == BluetoothStatePowerOn)
        {
            NSLog(@"The bluetooth state is power on, start scan now.");
//            [_manager startScan:beaconArray backgroundSupport:YES];
        }
        else{
            NSLog(@"The bluetooth state isn't power on, we can't start scan.");
//        [_manager startScan:beaconArray backgroundSupport:YES];
        }
    }else{
        //用于测试
        [_manager startScan:@[uuid1, uuid2] backgroundSupport:YES];
    }

    
    
//    if (beaconArray.count) {
//        [_manager startScan:beaconArray backgroundSupport:YES];
//    }else{
//        //用于测试
//        [_manager startScan:@[uuid1, uuid2] backgroundSupport:YES];
//    }
    
}

- (void)stopScan
{
    [[MinewBeaconManager sharedInstance] stopScan];
    _scannedDevice = nil;
}

#pragma mark **********************************Device Manager Delegate
- (void)minewBeaconManager:(MinewBeaconManager *)manager didRangeBeacons:(NSArray<MinewBeacon *> *)beacons
{
    
    @synchronized (self)
    {
        _scannedDevice = [beacons copy];
//        MinewBeacon *device = _scannedDevice[indexPath.row];
//        cell.textLabel.text = [device getBeaconValue:BeaconValueIndex_Name].stringValue? [device getBeaconValue:BeaconValueIndex_Name].stringValue: @"N/A";
//        cell.detailTextLabel.numberOfLines = 0;
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"UUID:%@\nMajor:%ld, Minor:%ld RSSI:%ld Battery:%ld \nTemp:%.2f, Humi:%.2f, Mac:%@, \nConnectable:%@",[device getBeaconValue:BeaconValueIndex_UUID].stringValue, (long)[device getBeaconValue:BeaconValueIndex_Major].intValue, (long)[device getBeaconValue:BeaconValueIndex_Minor].intValue, (long)[device getBeaconValue:BeaconValueIndex_RSSI].intValue, (long)[device getBeaconValue:BeaconValueIndex_BatteryLevel].intValue,  [device getBeaconValue:BeaconValueIndex_Temperature].floatValue, [device getBeaconValue:BeaconValueIndex_Humidity].floatValue, [device getBeaconValue:BeaconValueIndex_Mac].stringValue, [device getBeaconValue:BeaconValueIndex_Connectable].boolValue? @"YES": @"NO"];
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
        {
            [self pushNotification:[NSString stringWithFormat:@"Devices:%lu",(unsigned long)_scannedDevice.count]];
        }
        else
        {
            dispatch_async( dispatch_get_main_queue(), ^{
                //回主线程更新数据
                if (self.scanResultBlock) {
                    self.scanResultBlock(self.scannedDevice);
                }
            });
        }
    }
}

- (void)minewBeaconManager:(MinewBeaconManager *)manager appearBeacons:(NSArray<MinewBeacon *> *)beacons
{
    NSLog(@"===appear beacons:%@", beacons);
}

- (void)minewBeaconManager:(MinewBeaconManager *)manager disappearBeacons:(NSArray<MinewBeacon *> *)beacons
{
    NSLog(@"---disappear beacons:%@", beacons);
    if (self.scanResultBlock) {
        self.scanResultBlock(self.scannedDevice);
    }
}


- (void)minewBeaconManager:(MinewBeaconManager *)manager didUpdateState:(BluetoothState)state
{
    NSLog(@"++++Bluetooth state:%ld", (long)state);
    
    if ( state != BluetoothStatePowerOn)
        [self showAlert:state == BluetoothStatePowerOff? 1: 0];
}


- (void)pushNotification:(NSString *)notString
{
    
    UILocalNotification *unf = [[UILocalNotification alloc]init];
    unf.alertBody = notString;
    [[UIApplication sharedApplication] presentLocalNotificationNow:unf];
}

- (void)showAlert:(NSInteger)type
{
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:type? @"Bluetooth is power off": @"Bluetooth status Error！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *aa = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    
    [ac addAction:aa];
    if (self.awnVC) {
        [self.awnVC presentViewController:ac animated:YES completion:nil];
    }
}

@end

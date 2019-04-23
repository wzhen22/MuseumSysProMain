//
//  SpbBlueModel.h
//  MuseumSysPro
//
//  Created by admin on 2019/2/22.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpbBlueModel : NSObject

@property (nonatomic, strong) NSString *blueName;   //蓝牙名称
@property (nonatomic, strong) NSString *AddressName;   //设备按照地点名称
@property (nonatomic, strong) NSString *blueBatteryLevel;   //蓝牙电量
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBCharacteristic * GPrint_Chatacter;
@property (nonatomic, strong) NSString * UUIDString; //UUID
@property (nonatomic, strong) NSString * distance;  //中心到外设的距离

@end

NS_ASSUME_NONNULL_END

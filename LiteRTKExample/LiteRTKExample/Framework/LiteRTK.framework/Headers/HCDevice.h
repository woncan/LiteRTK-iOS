//
//  HCDevice.h
//  LiteRTK
//
//  Created by iband on 2021/6/3.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CBPeripheral.h>
#import "HCFilterRulesProtocol.h"
 
 
NS_ASSUME_NONNULL_BEGIN

@class HCCentralMgr;
@class HCDevice;
@protocol HCDeviceDelegate <NSObject>

@required
- (HCCentralMgr*)BTDeviceGetBTCentralManager;

@optional

///发现服务 /或错误
- (void)btDevice:(HCDevice *)device didDiscoverServices:(NSError *)error;

///发现完特征 回调
- (void)btDevice:(HCDevice *)device didDiscoverCharacteristics:(NSArray<CBCharacteristic *>* )characteristic error:(nullable NSError *)error;

///订阅响应
- (void)btDevice:(HCDevice *)device didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
///写入回调响应

- (void)btDevice:(HCDevice *)device didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;

///收到蓝牙设备反馈信息；
- (void)btDevice:(HCDevice *)device didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;

@end

@interface HCDevice : NSObject<CBPeripheralDelegate>

@property(nonatomic,copy)NSString *name;
/*kCBAdvDataManufacturerData*/
@property(nonatomic,copy)NSString *macAddess;
@property(nonatomic,copy)NSString *RSSI;
@property(nonatomic,copy)NSString *identifierUUIDString;

@property(nonatomic,strong,readonly) CBPeripheral *cbPeripheral;

@property(nonatomic,strong,readonly) NSArray<CBCharacteristic*> * __nullable foundCharacteristics;
 
@property(nonatomic,weak) id<HCDeviceDelegate> delegate;

@property(nonatomic,weak) id<HCFilterRulesProtocol> filterRulesDelegate;

- (instancetype)initWithPeriphral:(CBPeripheral*__nonnull)peripheal;
- (void)connect;
- (void)disconnect;
- (void)writeData:(NSData*__nonnull)data writeCharacteristicWithUUIDStr:(NSString*__nonnull)wuuid;
- (CBCharacteristic*__nullable)getCharacteristicWithUUIDStr:(NSString*__nonnull)wuuid;
- (void)addNotificationCharacteristicWithUUID:(NSArray*__nonnull)uuids;
- (void)cancelNotificationCharacteristicWithUUID:(NSArray*__nonnull)uuids;
- (void)readValueForCharacteristicWithUUIDStr:(NSString*__nonnull)wuuid;
 
@end

NS_ASSUME_NONNULL_END

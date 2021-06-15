//
//  HCBluetoothUtil.m
//  LiteRTK
//
//  Created by iband on 2021/6/3.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

#import "HCBluetoothUtil.h"
#import "HCDevice.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HCToolDelegate <NSObject>

@optional
 
/// 时时响应扫描过程中的结果
/// @param devices 扫描到的设备
- (void)btToolScanResbonsWithDevice:(NSArray<HCDevice *> *__nullable)devices;
 
/// 扫描结束后的响应
/// @param devices 扫描到的设备
/// @param reason 停止扫描的原因
- (void)btToolScanEndResbonsWithDevice:(NSArray<HCDevice *> *__nullable)devices why:(HCScanEndReason)reason;
  
/// 设备连接状态响应 成功/失败
/// @param isConnected 成功/失败
/// @param device 连接的设备实体
- (void)btToolIsConnected:(BOOL)isConnected withDevice:(HCDevice *)device;

/// 设备扫描服务的响应
/// @param device 设备
/// @param error 错误
- (void)btToolDiscoverServicesWithDevice:(HCDevice*)device error:(NSError *__nullable)error;

/// 扫描完设备特征之后的响应
/// @param device 设备
/// @param error 错误
- (void)btToolDiscoverCharacteristicsEndWithDevice:(HCDevice *)device error:(NSError *__nullable)error;
 
/// 订阅消息的响应
/// @param device 设备
/// @param uuidStr 特征标识
/// @param error  错误
- (void)btToolNotificationStatefromDevice:(HCDevice *)device characteristicUUIDsString:(NSString *)uuidStr error:(NSError *)error;
 
/// 可用此检测是否写入成功
/// CBCharacteristicWriteWithResponse:
/// @param device 设备
/// @param uuidStr 特征标识
/// @param error 错误
- (void)btToolDidWriteValuefromDevice:(HCDevice *)device characteristicUUIDsString:(NSString *)uuidStr error:(NSError *__nullable)error;

 
/// 设备连接后 断开的响应
/// @param device 断开的设备实体
/// @param error 错误信息
- (void)btToolDisconnected:(HCDevice *)device error:(NSError *__nullable)error;
 
/// 收到外设来的消息
/// @param device 设备
/// @param uuidStr 特征标识
/// @param data 内容
/// @param error 错误
- (void)btToolDidUpdateFrom:(HCDevice *)device characteristicUUIDsString:(NSString *)uuidStr value:(NSData *)data error:(NSError *__nullable)error;


/// ping 倒计时 次数
/// @param sec miao
- (void)btToolPingBTStatusTimeCountdown:(NSTimeInterval)sec;

/// 监听手机硬件信息
/// @param isOn 连接/断开
/// @param des 原因
- (void)BTState:(BOOL)isOn describe:(NSString*)des;

@end

@interface HCBluetoothUtil : NSObject

@property(nonatomic,weak) id<HCFilterRulesProtocol> filterDelegate;

@property(nonatomic,strong,readonly) NSMutableArray<HCDevice *>* __nullable connectPeripherals;

@property(nonatomic,weak) id<HCToolDelegate> delegate;

///扫描时长
@property(nonatomic,assign) NSTimeInterval scanSeconds;

///等待用户开启蓝牙时长
@property(nonatomic,assign) NSTimeInterval pingBTStateSeconds;
 
+ (HCBluetoothUtil*)shared;

- (void)beginScan;

- (void)stopScan;
 
/// 向蓝牙写数据
- (void)writeDatas:(NSArray<NSData *> *)datas btDevice:(HCDevice *__nullable)device characteristicUUIDStr:(NSString *__nullable)uuid;

- (void)cancelConnection:(HCDevice *)device;
 
- (void)cancelAllConnection;

/// 连接外设设备
- (void)connect:(HCDevice *)device;

NS_ASSUME_NONNULL_END

@end

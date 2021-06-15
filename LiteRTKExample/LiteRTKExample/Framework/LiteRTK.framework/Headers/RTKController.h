//
//  RTKController.h
//  LiteRTK
//
//  Created by iband on 2021/6/10.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCBluetoothUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTKController : NSObject

/**
 发送RTK指令
 */
+ (void)sendDatas:(NSArray<NSData *> *)datas toDevice:(HCDevice *)device;

/**
 设置频率
 interval: 间隔的毫秒数，例：5000=5秒一次   2000=2秒一次
 */
+ (void)setFrequency:(NSUInteger)interval toDevice:(HCDevice *)device;

/**
 开启日志
 */
+ (void)setLoggerOnToDevice:(HCDevice *)device;

/**
 设置高度角，0-90度
 */
+ (void)setHeightAngle:(NSUInteger)angle toDevice:(HCDevice *)device;

/**
 设置激光状态(开启|关闭)
 */
+ (void)setLaserState:(BOOL)isOn toDevice:(HCDevice *)device;;

@end

NS_ASSUME_NONNULL_END

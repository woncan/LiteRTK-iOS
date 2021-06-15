//
//  HCFilter.h
//  LiteRTK
//
//  Created by iband on 2021/6/3.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCFilterRulesProtocol.h"
#import <CoreBluetooth/CBUUID.h>
#import <CoreBluetooth/CBPeripheral.h>
NS_ASSUME_NONNULL_BEGIN
@class CBUUID;
@interface HCFilter : NSObject
@property(nonatomic,weak)id<HCFilterRulesProtocol>filterRulesDelegate;
/// 获取 扫描指定的服务uuid
- (NSArray<CBUUID*>*_Nullable)parseFilterServersUUIDParameter;
/// 获取 扫描过后 指定的参数配置
- (NSDictionary<HCScanAfterFilterConfigKey,id>*) getAfterFilterConfig;
/// 获取 指定被发现的特征 UUIDS
- (NSMutableArray<CBUUID*>*) getFilterCharacteristicUUIDs;
 
/// 扫描的结果   是否满足指定的参数配置
/// @param scanAfterFilterDic 扫描过后需过滤的参数
/// @param peripheral 外围设备
/// @param advertisementData 广播数据
/// @param RSSI 信号值
-(BOOL)isfilterRules:(NSDictionary<HCScanAfterFilterConfigKey,id>*) scanAfterFilterDic didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI;
 
///工具
+ (NSString *)convertDataToHexStr:(NSData *)data;

@end

NS_ASSUME_NONNULL_END

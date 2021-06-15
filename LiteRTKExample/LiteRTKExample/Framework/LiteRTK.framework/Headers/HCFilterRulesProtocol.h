//
//  HCFilterRulesProtocol.h
//  LiteRTK
//
//  Created by iband on 2021/6/3.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCDefine.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HCFilterRulesProtocol <NSObject>

@optional
 
///设置发现外设前的过滤条件 服务UUIDs:[CBUUID UUIDWithString:xxxx]
- (NSArray<NSString*> *)centerManagerSetScanServersUUIDs;

///设置发现外设后的筛选条件
- (NSDictionary<HCScanAfterFilterConfigKey, id> *)centerManagerSetScanAfterRules;
 
///过滤外设特征uuid
- (NSArray <NSString*> *)peripheralCharacteristicProtocol;

@end

NS_ASSUME_NONNULL_END

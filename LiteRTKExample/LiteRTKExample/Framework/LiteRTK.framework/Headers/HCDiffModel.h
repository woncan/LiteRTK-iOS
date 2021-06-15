//
//  HCDiffModel.h
//  LiteRTK
//
//  Created by iband on 2021/6/11.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//  Socket登录信息

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCDiffModel : NSObject

/// ip地址，默认rtk.ntrip.qxwz.com
@property (nonatomic, copy) NSString *ip;
/// 端口号，默认8003
@property (nonatomic, assign) NSInteger port;
/// 账号
@property (nonatomic, copy) NSString *account;
/// 密码
@property (nonatomic, copy) NSString *password;
/// 挂载点列表
@property (nonatomic, copy) NSArray<NSString *> *mountPointList;
/// 当前挂载点
@property (nonatomic, copy) NSString *currentMountPoint;

@end

NS_ASSUME_NONNULL_END

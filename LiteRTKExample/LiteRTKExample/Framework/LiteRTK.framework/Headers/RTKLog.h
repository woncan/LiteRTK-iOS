//
//  RTKLogUtil.h
//  LiteRTK
//
//  Created by iband on 2021/6/15.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define RTKLog(fmt, ...)  [RTKLog customLogWithFunction:__FUNCTION__ lineNumber:__LINE__ formatString:[NSString stringWithFormat:fmt, ##__VA_ARGS__]]

@interface RTKLog : NSObject

+ (void)setLogEnable:(BOOL)enable;

+ (void)customLogWithFunction:(const char *)function lineNumber:(int)lineNumber formatString:(NSString *)formatString;

@end

NS_ASSUME_NONNULL_END

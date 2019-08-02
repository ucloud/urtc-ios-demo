//
//  UCloudRtcLog.h
//  UCloudRtcSdk-ios
//
//  Created by Tony on 2019/7/26.
//  Copyright © 2019 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UCloudRtcLog : NSObject
//系统日志级别
typedef NS_ENUM(NSUInteger,LogLevel) {
    /*! 显示包括(UCloudRtcDebugLog,UCloudRtcVerboseLog,UCloudRtcInfoLog,UCloudRtcWarningLog,UCloudRtcErrorLog的Log)*/
    UCloudRtvLogLevel_DEBUG   = 1,
    /*! 显示包括(UCloudRtcVerboseLog,UCloudRtcInfoLog,UCloudRtcWarningLog,UCloudRtcErrorLog的Log)*/
    UCloudRtvLogLevel_VERBOSE = 1 << 1,
    /*! 显示包括(UCloudRtcInfoLog,UCloudRtcWarningLog,UCloudRtcErrorLog的Log)*/
    UCloudRtvLogLevel_INFO    = 1 << 2,
    /*! 显示包括(UCloudRtcWarningLog,UCloudRtcErrorLog的Log)*/
    UCloudRtcLogLevel_WARNING = 1 << 3,
    /*! 只显示UCloudRtcErrorLog的log*/
    UCloudRtcLogLevel_ERROR   = 1 << 4,
    /*! 不显示log*/
    UCloudRtcLogLevel_OFF   = 1 << 5,
};
/*
 * 设置SDK日志级别 默认：UCloudRtcLogLevel_OFF 不显示log
 */
- (void)setLogLevel:(LogLevel)level;


/*
 * 设置日志回滚大小，单位字节 默认10MB
 */
- (void)setRollBack:(double)fileSize;

FOUNDATION_EXPORT void UCloudRtcDebugLog(NSString *message,...) NS_FORMAT_FUNCTION(1,2);
FOUNDATION_EXPORT void UCloudRtcVerboseLog(NSString *message,...) NS_FORMAT_FUNCTION(1,2);
FOUNDATION_EXPORT void UCloudRtcInfoLog(NSString *message,...) NS_FORMAT_FUNCTION(1,2);
FOUNDATION_EXPORT void UCloudRtcWarningLog(NSString *message,...) NS_FORMAT_FUNCTION(1,2);
FOUNDATION_EXPORT void UCloudRtcErrorLog(NSString *message,...) NS_FORMAT_FUNCTION(1,2);
@end



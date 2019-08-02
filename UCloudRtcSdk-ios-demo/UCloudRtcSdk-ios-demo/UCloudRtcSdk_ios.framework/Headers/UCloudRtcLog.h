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
    /*! 显示包括(DEBUGLog,VERBOSELog,INFOLog,WARNINGLog,ERRORLog的Log)*/
    LogLevel_DEBUG   = 1,
    /*! 显示包括(VERBOSELog,INFOLog,WARNINGLog,ERRORLog的Log)*/
    LogLevel_VERBOSE = 1 << 1,
    /*! 显示包括(INFOLog,WARNINGLog,ERRORLog的Log)*/
    LogLevel_INFO    = 1 << 2,
    /*! 显示包括(WARNINGLog,ERRORLog的Log)*/
    LogLevel_WARNING = 1 << 3,
    /*! 只显示ERRORLog的log*/
    LogLevel_ERROR   = 1 << 4,
    /*! 不显示log*/
    LogLevel_OFF   = 1 << 5,
};
/*
 * 设置SDK日志级别 默认：LogLevel_OFF 不显示log
 */
- (void)setLogLevel:(LogLevel)level;


/*
 * 设置日志回滚大小，单位字节 默认10MB
 */
- (void)setRollBack:(double)fileSize;

FOUNDATION_EXPORT void DEBUGLog(NSString *message,...) NS_FORMAT_FUNCTION(1,2);
FOUNDATION_EXPORT void VERBOSELog(NSString *message,...) NS_FORMAT_FUNCTION(1,2);
FOUNDATION_EXPORT void INFOLog(NSString *message,...) NS_FORMAT_FUNCTION(1,2);
FOUNDATION_EXPORT void WARNINGLog(NSString *message,...) NS_FORMAT_FUNCTION(1,2);
FOUNDATION_EXPORT void ERRORLog(NSString *message,...) NS_FORMAT_FUNCTION(1,2);
@end



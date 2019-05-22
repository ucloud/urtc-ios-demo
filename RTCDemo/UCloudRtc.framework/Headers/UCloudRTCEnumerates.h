//
//  UCloudRTCEnumerates.h
//  UCloudRTC
//
//  Created by Tony on 2019/5/10.
//  Copyright © 2019 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//本地媒体流类型
typedef enum {
    UCloudMediaTypeDefault = 0, //默认摄像头
    UCloudMediaTypeCamrea = 1, // 摄像头
    UCloudMediaTypeDesktop = 2  // 桌面
} UCloudMediaType;

//媒体轨道类型类型描述
typedef enum {
    UCloudTrackTypeAudio = 0, // 音频轨道
    UCloudTrackTypeVideo = 1  // 视频轨道
} UCloudTracktype;
//媒体流类型描述
typedef enum {
    UCloudStreamtypeNo  = 0,  //无类型
    UCloudStreamtypeMic = 1,  //纯音频类型
    UCloudStreamtypeVideo = 2, //音频加视频
    UCloudStreamtypeScreen = 3 //桌面视频
} UCloudStreamtype;

//网络质量回调
typedef enum {
    UCloudRtcNetworkQualityExcellent = 1, // 用户网络优秀
    UCloudRtcNetworkQualityGood = 2, // 用户网络良好
    UCloudRtcNetworkQualityPoor = 3, // 用户网络不佳
    UCloudRtcNetworkQualityTerrible = 4 //网络糟糕
} UCloudRtcNetworkQuality;
//渲染模式
typedef enum {
    UCloudRtcRenderModeAuto    = 0, //默认保持比例
    UCloudRtcRenderModeStretch = 1, //平铺
    UCloudRtcRenderModeFill    = 2  //保持比例
} UCloudRtcRenderMode;
//日志级别
typedef enum {
    UCloudRtcLogLevelDebug,
    UCloudRtcLogLevelVerbose,
    UCloudRtcLogLevelInfo,
    UCloudRtcLogLevelWarn,
    UCloudRtcLogLevelError,
    UCloudRtcLogLevelFatal,
    UCloudRtcLogLevelNone,
} UCloudRtcLogLevel;
//视频质量级别
typedef enum {
    UCloudRtcVideoProfileInvalid = -1,
    UCloudRtcVideoProfile_320_240 = 1,
    UCloudRtcVideoProfile_640_480 = 3,
    UCloudRtcVideoProfile_1280_720 = 4
} UCloudRtcVideoProfile;
//桌面输出等级
typedef enum {
    UCloudRtcScreenProfileLow = 1,
    UCloudRtcScreenProfileMiddle = 2,
    UCloudRtcScreenProfileHigh = 3
} UCloudRtcScreenProfile;

//流权限
typedef enum {
    STREAM_PUB, // 上传权限
    STREAM_SUB,// 下载权限
    STREAM_BOTH //全部权限
} UCloudStreamRole;


@interface UCloudRTCEnumerates : NSObject


@end

NS_ASSUME_NONNULL_END

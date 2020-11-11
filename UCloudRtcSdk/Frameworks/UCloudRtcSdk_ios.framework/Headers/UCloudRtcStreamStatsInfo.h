//
//  UCloudRtcStreamStatsInfo.h
//  UCloudRtcSDK
//
//  Created by tony on 2019/3/29.
//  Copyright © 2019年 ucloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCloudRtcStreamStatsInfo : NSObject

@property (nonatomic, strong) NSString *streamId;

@property(nonatomic, strong) NSString *userId;

@property(nonatomic, assign) NSInteger volume;
@property (nonatomic, assign) NSInteger fps;
@property (nonatomic, assign) NSInteger bitrate;
@property (nonatomic, assign) NSInteger frameRate;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger lost;
@property (nonatomic, assign) NSInteger rtt;
@property (nonatomic, assign) NSInteger connRtt;

@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger jitter;
@property (nonatomic, assign) NSInteger delay;
@property (nonatomic, strong) NSString *mime;
@property (nonatomic, strong) NSString *codec;
@property (nonatomic, strong) NSString *trackType;//区分音频h轨道 、视频轨道
@property (nonatomic, strong) NSString *type;//区分ssrc：上行send、下行recv、googCandidatePair、VideoBwe

// 博学
@property (nonatomic, assign) double totalAudioEnergy;//总音频发送量
@property (nonatomic, assign) double googPreemptiveExpandRate;//伸缩抢占率
@property (nonatomic, assign) NSInteger audioInputLevel;//采集音频幅度
@property (nonatomic, assign) NSInteger audioOutputLevel;// 播放音频幅度

// 立飞
/** VideoBwe >>>*/
@property (nonatomic, assign) NSInteger googActualEncBitrate;//当前估算的发送或者接收码率(kbps)（"ab"）
@property (nonatomic, assign) NSInteger googRetransmitBitrate;//kbps（"rb"）

/**video/audio*/
@property (nonatomic, assign) NSInteger packetsSent_Recv;//每秒发送包量、接收包量 （"ps"）
@property (nonatomic, assign) NSInteger googJitterBufferMs;//接收缓冲区 (ms) （"jb"）

/** audio >>>*/
@property (nonatomic, assign) NSInteger googDecodingNormal;//每秒解码包量  (ms) （"dn"）
@property (nonatomic, assign) NSInteger googDecodingPLC;//每秒丢包隐藏包量  (ms) （"plc"）
@property (nonatomic, assign) NSInteger googJitterReceived;//接收或者发送抖动  (ms) （"jr"）
@property (nonatomic, assign) NSInteger googExpandRate;//音频拉伸率（0 -- 1.0 用于计算卡顿指标） （"exp"）
@property (nonatomic, assign) NSInteger googAccelerateRate;//音频加速率  （"ar"）

/** video >>>*/
@property (nonatomic, assign) NSInteger googFrameRateReceived;//编码或者解码帧率 （"frr"）
@property (nonatomic, assign) NSInteger googDecodeMs;//解码耗时 （"dms"）
@property (nonatomic, assign) NSInteger googAvgEncodeMs;//编码平均耗时 （"ems"）
@property (nonatomic, assign) NSInteger googInterframeDelayMax;//接收 帧内最大delay （"ifd"）



@end

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
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger jitter;
@property (nonatomic, assign) NSInteger delay;
@property (nonatomic, strong) NSString *mime;
@property (nonatomic, strong) NSString *codec;
@property (nonatomic, strong) NSString *trackType;//区分音频h轨道 、视频轨道

@property (nonatomic, assign) double totalAudioEnergy;//总音频发送量
@property (nonatomic, assign) double googAccelerateRate;//加速率
@property (nonatomic, assign) NSInteger googJitterReceived;//抖动反馈
@property (nonatomic, assign) NSInteger googDecodingPLC;//抗丢包解码
@property (nonatomic, assign) double googExpandRate;//伸缩率
@property (nonatomic, assign) double googPreemptiveExpandRate;//伸缩抢占率
@property (nonatomic, assign) NSInteger audioInputLevel;//采集音频幅度
@property (nonatomic, assign) NSInteger audioOutputLevel;// 播放音频幅度

@property (nonatomic, strong) NSString *type;//区分ssrc：上行send、下行recv
@end

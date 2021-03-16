//
//  UCloudRtcStream.h
//  UCloudRtcSDK
//
//  Created by tony on 2019/2/23.
//  Copyright © 2019年 ucloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCloudRtcEngine.h"

@protocol UCloudRtcRenderDelegate <NSObject>
/**
 远端视频渲染首帧通知
 
 @param streamID 流的唯一标识
 */
- (void)uCloudRtcRenderVideoFirstFrame:(NSString *)streamID;

@end


@class UCloudRtcStreamStatsInfo,UCloudRtcAudioStats;

@interface UCloudRtcStream : NSObject

@property (nonatomic, weak) id <UCloudRtcRenderDelegate> delegate;
@property (nonatomic, readonly) NSString *streamId;
@property(nonatomic, readonly) NSString *userId;
/// 是否有视频
@property (nonatomic, assign) BOOL video;
/// 是否有音频
@property (nonatomic, assign) BOOL audio;
@property (nonatomic, assign) BOOL mutevideo;
@property (nonatomic, assign) BOOL muteaudio;
@property(nonatomic, assign) BOOL hasSubscribe;//是否被当前用户订阅
@property(nonatomic, assign) UCloudRtcStreamMediaType mediaType;//流类型：音视频、桌面
/// 是否订阅视频（自动订阅：取决于对端流是否有视频；手动订阅：依据场景设置是否订阅）
@property(nonatomic, assign) BOOL isSubscribeVideo;
/// 是否订阅音频（自动订阅：取决于对端流是否有音频；手动订阅：依据场景设置是否订阅）
@property(nonatomic, assign) BOOL isSubscribeAudio;
/// 远端流渲染模式
@property (nonatomic, assign) UCloudRtcVideoViewMode remoteVideoViewMode;

/**渲染到指定视图*/
- (void)renderOnView:(UIView *)view;
/**获取流状态信息*/
- (NSMutableArray *)getReportStates:(NSString *)userId;

/** 获取音量*/
- (UCloudRtcAudioStats *)getAudioLevel;

@end

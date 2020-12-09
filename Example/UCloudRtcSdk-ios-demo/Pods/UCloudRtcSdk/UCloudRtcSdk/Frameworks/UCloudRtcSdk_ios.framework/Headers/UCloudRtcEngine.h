//
//  UCloudRtcEngine.h
//  UCloudRtcSDK
//
//  Created by tony on 2019/2/1.
//  Copyright © 2019年 ucloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
typedef NS_ENUM(NSInteger)
{
    UCloudRtcEngineModeNormal = 0,//正式
    UCloudRtcEngineModeTrival = 1,//测试
    
}UCloudRtcEngineMode;

typedef NS_ENUM(NSInteger)
{
    UCloudRtcEngineRoomType_Communicate = 0,//小班课 、视频会议  默认值
    UCloudRtcEngineRoomType_Broadcast = 1,//大班课
    
}UCloudRtcEngineRoomType;

typedef NS_ENUM(NSInteger)
{
    UCloudRtcEngine_StreamProfileUpload = 0,// 上传权限
    UCloudRtcEngine_StreamProfileDownload = 1,//下载权限
    UCloudRtcEngine_StreamProfileAll= 2,//所有权限 默认值
    
} UCloudRtcEngineStreamProfile;


typedef NS_ENUM(NSInteger)
{
    UCloudRtcEngine_VideoProfile_180P_1 = 0, // 分辨率:240*180,  码率范围:100-200kpbs, 帧率:15fps
    UCloudRtcEngine_VideoProfile_180P_2 = 1, // 分辨率:320*180,  码率范围:100-200kpbs, 帧率:15fps
    UCloudRtcEngine_VideoProfile_360P_1 = 2, // 分辨率:480*360,  码率范围:100-300kpbs, 帧率:15fps(默认值)
    UCloudRtcEngine_VideoProfile_360P_2 = 3, // 分辨率:640*360,  码率范围:100-400kpbs, 帧率:20fps
    UCloudRtcEngine_VideoProfile_480P = 4,   // 分辨率:640*480,  码率范围:100-500kpbs, 帧率:20fps
    UCloudRtcEngine_VideoProfile_720P = 5,   // 分辨率:1280*720, 码率范围:300-1000kpbs,帧率:30fps
    UCloudRtcEngine_VideoProfile_1080P = 6,  // 分辨率:1920*1080,码率范围:500-1500kpbs,帧率:30fps
} UCloudRtcEngineVideoProfile;

typedef NS_ENUM(NSInteger,UCloudRtcEngineErrorType) {
    UCloudRtcEngineErrorTypeJoinRoomError,
    UCloudRtcEngineErrorTypeRoomExist,
    UCloudRtcEngineErrorTypeTokenInvalid,
    UCloudRtcEngineErrorTypeStreamDisconnected, //流已断开
};

//发布状态
typedef NS_ENUM(NSInteger,UCloudRtcEnginePublishState) {
    UCloudRtcEnginePublishStateUnPublish = 0,
    UCloudRtcEnginePublishStatePublishing,
    UCloudRtcEnginePublishStatePublishSucceed,
    UCloudRtcEnginePublishStateRepublishing,
    UCloudRtcEnginePublishStatePublishFailed,
    UCloudRtcEnginePublishStatePublishStoped,
};
// 流媒体类型
typedef NS_ENUM(NSInteger, UCloudRtcStreamMediaType) {
    UCloudRtcStreamMediaTypeCamera = 1,  // 摄像头
    UCloudRtcStreamMediaTypeScreen = 2, // 桌面
} ;


typedef NS_ENUM(NSInteger, UCloudRtcConnectState) {
    UCloudRtcConnectStateDisConnect,//连接断开
    UCloudRtcConnectStateConnecting,//连接中
    UCloudRtcConnectStateConnected,//连接成功
    UCloudRtcConnectStateConnectFailed,//连接失败
    UCloudRtcConnectStateReConnected//重连成功
};

/** 网络质量*/
typedef NS_ENUM(NSInteger, UCloudRtcNetworkQuality) {
    UCloudRtcNetworkQualityUnknown,     // 网络质量未知
    UCloudRtcNetworkQualityExcellent,   // 网络质量优秀
    UCloudRtcNetworkQualityGood,        // 网络质量良好
    UCloudRtcNetworkQualityPoor,        // 网络质量一般
    UCloudRtcNetworkQualityPoorer,      // 网络质量较差
    UCloudRtcNetworkQualityPoorest,     // 网络质量糟糕
    UCloudRtcNetworkQualityDisconnect   // 网络连接已断开
};

/** 本地预览视频视图的模式 */
typedef NS_ENUM(NSInteger,UCloudRtcVideoViewMode) {
    /** 等比缩放，可能有黑边 */
    UCloudRtcVideoViewModeScaleAspectFit     = 0,
    /** 等比缩放填充整View，可能有部分被裁减 */
    UCloudRtcVideoViewModeScaleAspectFill    = 1,
    /** 填充整个View */
    UCloudRtcVideoViewModeScaleToFill        = 2,
};
/** 本地预览视频视图镜像模式*/
typedef NS_ENUM(NSUInteger, UCloudRtcVideoMirrorMode) {
    /** 默认模式，根据系统处理*/
    UCloudRtcVideoMirrorModeAuto = 0,
    /** 打开镜像 */
    UCloudRtcVideoMirrorModeEnabled = 1,
    /** 关闭镜像 */
    UCloudRtcVideoMirrorModeDisabled = 2,
};
/** 视频采集旋转方向，与 UIInterfaceOrientation方向一致*/
typedef NS_ENUM(NSUInteger, UCloudRtcOrientationMode) {
    UCloudRtcOrientationModeAdaptive,
    UCloudRtcOrientationModeLandscapeLeft,
    UCloudRtcOrientationModeLandscapeRight,
};

//0或者1退出不重连 2退出重连并使用原服务器列表 3退出并重连网关
/**强制用户退出或者重连*/
typedef NS_ENUM(NSUInteger, UCloudRtcKickOffType) {
    UCloudRtcKickOffTypeExit = 1,                 // 退出不重连
    UCloudRtcKickOffTypeRejoin = 2,               // 退出后再使用原服务器列表重连
    UCloudRtcKickOffTypeRejoinWithNewServer = 3,  // 退出后再使用新服务器列表重连
};

/** 自定义视频采集的视频方向*/
typedef NS_ENUM(NSInteger, UCloudRtcVideoRotation) {
  UCloudRtcVideoRotation_0 = 0,
  UCloudRtcVideoRotation_90 = 90,
  UCloudRtcVideoRotation_180 = 180,
  UCloudRtcVideoRotation_270 = 270,
};



//
typedef NS_ENUM(NSInteger, UCloudRtcMixState) {
    UCloudRtcMixStateStart,     // 开始转推/录制/开始更新
    UCloudRtcMixStateSuccess,   // 录制、转推、更新任务成功
    UCloudRtcMixStateUpdate,    // 更新
    UCloudRtcMixStateStop,      // 停止
    UCloudRtcMixStateStartFailed,    // 开始任务失败
    UCloudRtcMixStateStopFailed,    // 停止任务失败
    UCloudRtcMixStateUpdateFailed,    // 更新任务失败
    UCloudRtcMixStateFailed,    // 录制和转推过程中任务失败

};
typedef NS_ENUM(NSInteger, UCloudRtcLeaveRoomReason) {
    UCloudRtcLeaveRoomReasonActive,     // 主动离开
    UCloudRtcLeaveRoomReasonForced,     // 被强制离开(被人强制踢出房间)
    UCloudRtcLeaveRoomReasonNoResponse, // 没有响应自动离开（如断线时间超过上限后，会回调离开房间的通知）
};


@class UCloudRtcEngine,UCloudRtcStream,UCloudRtcError,UCloudRtcRoomStream,UCloudRtcStreamVolume,UCloudRtcStreamStatsInfo,UCloudRtcLog,UCloudRtcMixConfig, UCloudRtcMixResponse,UCloudRtcRecordResponse, UCloudRtcRelayResponse,UCloudRtcAudioStats,UCloudRtcVideoFrame;
@protocol UCloudRtcEngineDelegate <NSObject>
@optional
/**
@brief 退出房间的回调 （1.6.1后废弃，使用“uCloudRtcEngine: didLeaveRoomWithReason:”）

@discussion 该方法是在调用退出房间：-leaveRoom方法后会收到的d回调通知。
*/
- (void)uCloudRtcEngineDidLeaveRoom:(UCloudRtcEngine *_Nonnull)manager;

/**
@brief 退出房间的回调

@discussion 该方法是在调用退出房间：-leaveRoom方法后会收到的d回调通知。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager didLeaveRoomWithReason:(UCloudRtcLeaveRoomReason)reason;

/**
@brief 发布状态的变化
@param publishState 发布状态：UCloudRtcEnginePublishState
@discussion 该方法是本地流发布过程中,发布状态变化的回调。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager didChangePublishState:(UCloudRtcEnginePublishState)publishState;



/**
@brief 发布状态的变化
@param publishState 发布状态：UCloudRtcEnginePublishState
@param mediaType 媒体类型：摄像头、桌面
@discussion 该方法是本地流发布过程中,发布状态变化的回调。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager didChangePublishState:(UCloudRtcEnginePublishState)publishState mediaType:(UCloudRtcStreamMediaType)mediaType ;

/**
@brief 收到远程流
@param stream 远端流对象
@discussion 当成功订阅远程流时会收到该回调。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager receiveRemoteStream:(UCloudRtcStream *_Nonnull)stream;

/**
@brief 远程流断开
@param stream 远端流对象
@discussion 当取消订阅远程流或远程流退出房间时会收到该回调。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager didRemoveStream:(UCloudRtcStream *_Nonnull)stream;


/**
@brief 新成员加入
@param memberInfo 新成员信息
@discussion 当新用户加入房间会收到该回调 注：可能同时收到该回调和可订阅流加入的回调。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager memberDidJoinRoom:(NSDictionary *_Nonnull)memberInfo;

/**
@brief 成员退出
@param memberInfo 成员信息
@discussion 当用户退出房间会收到该回调 注：可能同时收到该回调和可订阅流退出的回调。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager memberDidLeaveRoom:(NSDictionary *_Nonnull)memberInfo;

/**
@brief 手动订阅模式下 可订阅流加入
@param stream 流对象
@discussion 手动订阅模式下,当有新的流加入房间会收到该回调 注：该流需要客户端主动发起订阅。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)channel newStreamHasJoinRoom:(UCloudRtcStream *_Nonnull)stream;

/**
@brief 手动订阅模式下 可订阅流退出
@param stream 流对象
@discussion 手动订阅模式下,当有未订阅过的流退出房间会收到该回调。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)channel streamHasLeaveRoom:(UCloudRtcStream *_Nonnull)stream;

/**
@brief 流状态回调
@param status 流状态信息
@discussion 流状态信息包含音频轨道和视频轨道的数据信息。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager didReceiveStreamStatus:(NSArray<UCloudRtcStreamStatsInfo*> *_Nonnull)status;

/**
@brief 音量回调
@param audioStatus 音量信息
@discussion 200ms回调一次音量信息，如果存在多个远端用户200ms内会被触发多次。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager didReceiveAudioStatus:(UCloudRtcAudioStats *_Nonnull)audioStatus;

/**
@brief 通话中每个用户的网络上下行质量报告回调
@param userId       用户 ID
@param txQuality 该用户的上行网络质量
@param rxQuality 该用户的下行网络质量
@discussion 流状态信息包含音频轨道和视频轨道的数据信息。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager networkQuality:(NSString *)userId txQuality:(UCloudRtcNetworkQuality)txQuality rxQuality:(UCloudRtcNetworkQuality)rxQuality;

/***/
/**
@brief 流连接失败的回调
@param streamId 流ID
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager streamConnectionFailed:(NSString *_Nonnull)streamId;

/**
@brief 错误的回调
@param error 错误信息
@discussion 当方式错误是会收到该回调。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager error:(UCloudRtcError *_Nonnull)error;

/**
@brief 开始录制、转推的回调 《 废弃 》
@param recordResponse 回调信息
@discussion 开启云端录制服务成功时会收到该回调，回调信息里面包含录制生成的视频文件的文件名。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager startRecord:(NSDictionary *_Nonnull)recordResponse;

/**
@brief 开始录制、转推的回调
@param mixReponse 回调信息
@discussion 开启云端转推录制服务成功时会收到该回调，回调信息里面包含录制生成的视频文件的文件名；手动添加流到录制、转推中，也会在该代理方法中回调。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager didChangeRecordState:(UCloudRtcMixState)mixState response:(UCloudRtcMixResponse *_Nullable)recordResponse ;

- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager didChangeRelayState:(UCloudRtcMixState)mixState response:(UCloudRtcMixResponse *_Nullable)relayResponse;

/**
@brief 删除录制、转推中指定的流回调 （已废弃）
@param mixId 录制任务id
@discussion mixId。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager deleteMixStream:(NSString *_Nullable)mixId;
/**
@brief 查询录制、转推的信息
@param response 回调信息
@discussion 查询录制、转推的信息，response包含type、mixId、filename。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager queryMix:(UCloudRtcMixResponse *_Nullable)response;


/**
@brief 收到自定义消息的回调
@param fromUserID 发送自定义消息的用户ID
@param content 消息内容
@discussion 接收到服务端转发过来的自定义消息。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager receiveCustomCommand:(NSString *_Nonnull)fromUserID  content:(NSString *_Nonnull)content;

/**
@brief 远端音视频禁用或打开的回调
@param remoteMuteInfo 回调信息:用户ID、是否禁用、轨道类型
@discussion 当远端用户禁用/打开摄像头/麦克风时会收到该回调。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)channel remoteMute:(NSDictionary *_Nonnull)remoteMuteInfo;

/**
@brief 媒体播放器播放结束的回调
@param isEnd 是否播放结束
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)channel mediaPlayerOnPlayEnd:(BOOL)isEnd;

/**
@brief 网络连接状态变化
@param connectState UCloudRtcConnectState 网络连接状态
@discussion 当网络连接状态发生变化时会收到该回调。
*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager connectState:(UCloudRtcConnectState)connectState;

/**
@brief 重连房间时回调
@discussion 当连接失败后会尝试重连，开始重连房间时回调。
*/
- (void)uCloudRtcEngineRejoiningRoom:(UCloudRtcEngine *_Nonnull)manager;


/**
@brief 与房间的连接断开
@discussion 当连接断开时会收到该回调。
*/
- (void)uCloudRtcEngineDisconnectRoom:(UCloudRtcEngine *_Nonnull)manager;


@end

@interface UCloudRtcEngine : NSObject

/**SDK模式  默认是: 测试  正式上线前需要切换到正式模式*/
@property (nonatomic, assign) UCloudRtcEngineMode engineMode;

/**是否自动发布  默认是: YES  必须在加入房间之前设置才会生效 否则采用默认值*/
@property (nonatomic, assign) BOOL isAutoPublish;

/**是否自动订阅  默认是: YES 必须在加入房间之前设置才会生效 否则采用默认值*/
@property (nonatomic, assign) BOOL isAutoSubscribe;

/**是否开启纯音频模式  默认否: NO  必须在加入房间之前设置才会生效 否则采用默认值*/
@property (nonatomic, assign) BOOL isOnlyAudio;

/**是否开启视频  默认否: YES  必须在加入房间之前设置才会生效 否则采用默认值*/
@property (nonatomic, assign) BOOL enableLocalVideo;

/**是否开启音频  默认否: YES  必须在加入房间之前设置才会生效 否则采用默认值*/
@property (nonatomic, assign) BOOL enableLocalAudio;


/**视频分辨率设置 默认:480*360  必须在加入房间之前设置才会生效 否则采用默认值*/
@property (nonatomic, assign) UCloudRtcEngineVideoProfile videoProfile;

/**本地流权限设置 默认:所有权限  必须在加入房间之前设置才会生效 否则采用默认值*/
@property (nonatomic, assign) UCloudRtcEngineStreamProfile streamProfile;

/**URTC 房间类型  默认是: 0  必须在加入房间之前设置才会生效 否则采用默认值*/
@property (nonatomic, assign) UCloudRtcEngineRoomType roomType;

/**是否开启免提*/
@property (nonatomic, assign, readonly) BOOL isLoudSpeaker;

@property (nonatomic, weak) id <UCloudRtcEngineDelegate> _Nullable delegate;

@property (nonatomic, readonly) UCloudRtcStream * _Nonnull localStream;
@property (nonatomic, readonly) UCloudRtcStream * _Nonnull screenStream;

@property (nonatomic, strong) UCloudRtcLog * _Nullable logger;

/**是否开启混音*/
@property (nonatomic, assign) BOOL fileMix;

/**混音文件路径*/
@property (nonatomic, copy) NSString * _Nullable filePath;

/**混音文件是否循环播放*/
@property (nonatomic, assign) BOOL fileLoop;

/**视频编码格式 默认VP8 可选 VP8 || H264 */
@property (nonatomic, copy) NSString * _Nullable videoDefaultCodec;


//本地视频录制参数
@property (nonatomic, assign) BOOL openNativeRecord;//是否开启本地录制

@property (nonatomic, copy) NSString *_Nullable outputpath;//混音文件路径

/**断网重连次数 默认为：60次 */
@property (nonatomic, assign) NSInteger reConnectTimes;

/**重连时间间隔，默认5秒钟*/
@property(nonatomic, assign) NSInteger overTime;

/**是否开启网络质量监控，默认开启*/
@property(nonatomic, assign) BOOL isTrackNetQuality;

/**是否开启音量监控,200ms回调一次所有流的音量，默认关闭*/
@property(nonatomic, assign) BOOL isTrackVolume;

/** 本地预览视图镜像模式 */
@property(nonatomic, assign) UCloudRtcVideoMirrorMode mirrorMode;
/** 视频采集旋转方向 */
@property(nonatomic, assign) UCloudRtcOrientationMode orientationMode ;
/**
 *使用外部视频源，默认是NO，
 *当设置为YES时，本地摄像头将不再采集视频数据，
 *视频数据由用户自行上传，
 */
@property(nonatomic, assign) BOOL enableExtendVideoCapture;

/**
* 使用外部视频源，配置视频信息，
*不设置时，默认使用源视频信息；加入房间前设置
*/
@property(nonatomic, strong) UCloudRtcVideoFrame * _Nullable extendVideoFrame;
/**
 @brief 返回SDK当前版本号

 @return currentVersion
 */
+ (NSString *_Nonnull)currentVersion;


/**
 @brief 初始化UCloudRtcEngine  已弃用
 @param userId 当前用户的ID
 @param appId 分配得到的应用ID
 @param roomId 即将加入的房间ID
 @param appKey 分配得到的appkey
 @param token  生成的token
 @return UCloudRtcEngine
 */
- (instancetype _Nonnull )initWithUserId:(NSString *_Nonnull)userId appId:(NSString *_Nonnull)appId roomId:(NSString *_Nonnull)roomId appKey:(NSString *_Nullable)appKey token:(NSString *_Nullable)token;

/**
@brief 初始化UCloudRtcEngine
@param appId 分配得到的应用ID
@param appKey 分配得到的appkey
@return UCloudRtcEngine
*/
- (instancetype _Nonnull )initWithAppID:(NSString *_Nonnull)appId appKey:(NSString *_Nullable)appKey completionBlock:(void (^_Nonnull)(int errorCode))completion;


/**
 @brief 加入房间 已弃用

 @param completion completion
 */
- (void)joinRoomWithcompletionHandler:(void (^_Nonnull)(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error))completion;


/**
@brief 加入房间
 
@param roomId 即将加入的房间ID
@param userId 当前用户的ID
@param token  生成的token
@param completion completion
*/
- (void)joinRoomWithRoomId:(NSString *_Nonnull)roomId userId:(NSString *_Nonnull)userId token:(NSString *_Nullable)token completionHandler:(void (^_Nonnull)(NSDictionary * _Nonnull response,int errorCode))completion;


/**
 @brief 退出房间

 @return 0: 方法调用成功  < 0: 方法调用失败
 */
- (int)leaveRoom;

/**
 @brief 手动发布摄像头
 
 */
- (void)publish;


/**
 @brief 取消发布摄像头
 
 */
- (void)unPublish;

/**
 @brief 手动发布
 
 @param mediaType 流媒体类型:摄像头、桌面
*/
- (void)publishWithMediaType:(UCloudRtcStreamMediaType)mediaType;
/**
 @brief 取消发布
 
 @param mediaType 流媒体类型:摄像头、桌面
*/
- (void)unpublishWithMediaType:(UCloudRtcStreamMediaType)mediaType;

/**
 @brief 手动订阅

 @param stream 将要订阅的流 <UCloudRtcStream *>
 */
- (void)subscribeMethod:(UCloudRtcStream *_Nonnull)stream;


/**
 @brief 取消订阅

 @param stream 将要取消订阅的流 <UCloudRtcStream *>
 */
- (void)unSubscribeMethod:(UCloudRtcStream *_Nonnull)stream;


/**
 @brief 设置本地的预览画面

 @param preview 本地画面即将渲染到的目标视图
 @return 0: 方法调用成功  < 0: 方法调用失败
 */
- (int)setLocalPreview:(UIView *_Nonnull)preview;


/**
 @brief 设置本地预览视频视图的模式

 @param previewMode 本地画面渲染模式
 @return 0: 方法调用成功  < 0: 方法调用失败
 */
- (int)setPreviewMode:(UCloudRtcVideoViewMode)previewMode;

/**
 @brief 设置远程视频视图的模式

 @param remoteViewMode 远程画面渲染模式
 @return 0: 方法调用成功  < 0: 方法调用失败
 */
- (int)setRemoteViewMode:(UCloudRtcVideoViewMode)remoteViewMode;


/**
 @brief 切换本地摄像头
 
 @return 0: 方法调用成功  < 0: 方法调用失败
 */
- (int)switchCamera;


/**
 @brief 设置本地流是否静音

 @param isMute 是否禁用
 @return 0: 方法调用成功  < 0: 方法调用失败
 */
- (int)setMute:(BOOL)isMute;


/**
 @brief 设置本地流是否禁用视频

 @param isOpen 是否开启
 @return 0: 方法调用成功  < 0: 方法调用失败
 */
- (int)openCamera:(BOOL)isOpen;


/**
 @brief 开启免提

 @param isOpen 是否开启
 @return 0: 方法调用成功  < 0: 方法调用失败
 */
- (int)openLoudspeaker:(BOOL)isOpen;


/**
 @brief 设置远程流是否禁用视频

 @param stream 目标远端流
 @param isMute 是否禁用视频
 @return 0: 方法调用成功  < 0: 方法调用失败
 */
- (int)setRemoteStream:(UCloudRtcStream *_Nonnull)stream muteVideo:(BOOL)isMute;


/**
 @brief 设置远程流是否禁用音频

 @param stream 目标远端流
 @param isMute 是否禁用音频频
 @return 0: 方法调用成功  < 0: 方法调用失败
 */
- (int)setRemoteStream:(UCloudRtcStream *_Nonnull)stream muteAudio:(BOOL)isMute;


/**
@brief 依据type类型，强制users下线/重连操作

@param users 用户ID列表[用户id]
@param type 强制下线类型
@return 0: 方法调用成功  < 0: 方法调用失败
*/
- (int)kickOffUsers:(NSArray *)users type:(UCloudRtcKickOffType)type;

/**
 @brief 本地视频录制
 
 @discussion 会根据你选择的视频分辨率进行录制，默认是 480 X 360
 @return 0: 方法调用成功  < 0: 方法调用失败
 */
- (int)startNativeRecord;

/**
@brief 停止本地录制

@return 0: 方法调用成功  < 0: 方法调用失败
*/
- (int)stopNativeRecord;


/**
@brief 音频播放
 
@param path 文件路径
@param repeat 是否循环播放
@return 0: 方法调用成功  < 0: 方法调用失败
*/
- (int)startMediaPlay:(NSString *_Nonnull)path repeat:(BOOL)repeat;


/**
@brief 停止音频播放
 
@return 0: 方法调用成功  < 0: 方法调用失败
*/
- (int)stopMediaPlay;

/**
@brief 暂停音频播放
 
@return 0: 方法调用成功  < 0: 方法调用失败
*/
- (int)pauseMediaPlay;


/**
@brief 恢复音频播放
 
@return 0: 方法调用成功  < 0: 方法调用失败
*/
- (int)resumeMediaPlay;

/**
@brief 获取音效文件播放音量
 
@return 音效文件播放音量
*/
- (double)getMediaVolume;

/**
@brief 设置音效文件播放音量
 
@param volume 音效文件播放音量
@return 设置结果 0: 方法调用成功  < 0: 方法调用失败
*/
- (int)setMediaVolume:(double)volume;

/**
@brief 发送自定义消息
 
@param customCommand 自定义消息内容
@return 0: 方法调用成功  < 0: 方法调用失败
*/
- (int)sendCustomCommand:(NSString *_Nonnull)customCommand;


/**
 @brief 停止音频播放
 
 @discussion 停止的是远端音频播放
 */
- (void)stopAudioPlay;

/**
 @brief 开始音频播放
 
 @discussion 开始的是远端音频播放
 
 */
- (void)startAudioPlay;


/**
 @brief 停止音视频的采集和播放
 
 @discussion 如果你的应用没有后台模式，那么当点击home键应用退到后台时，可以调用此方法停止音频和视频的采集以及远端音频的播放。
 */
- (void)stopAVCollectionAndPaly;

/**
 @brief 开始音频的采集和播放
 
 @discussion 和上面的`- (void)stopAVCollectionAndPaly`方法对应，当app重新进入活跃状态时，调用该方法恢复本地音视频的采集和远端音频的播放。
 */
- (void)startAVCollectionAndPaly;


/**
@brief 销毁引擎
 
@return 0: 方法调用成功  < 0: 方法调用失败
*/
- (int)distory;

/**
@brief 录制
@discussion 开启录制任务
@param mixConfig 构建录制的模型，bucket、region必须设置
@return 0: 方法调用成功  < 0: 方法调用失败
*/
- (int)startRecord:(UCloudRtcMixConfig *_Nonnull)mixConfig;

/**
@brief 停止

@return 0: 方法调用成功  < 0: 方法调用失败
*/
- (int)stopRecord;
/**
@brief 转推
@discussion 添加、删除流时，设置streams为更改后的全量列表
@param mixConfig 构建转推、录制的模型
@return 0: 方法调用成功  < 0: 方法调用失败
*/
- (int)startRelay:(UCloudRtcMixConfig *_Nonnull)mixConfig;


/**
@brief 停止

@return 0: 方法调用成功  < 0: 方法调用失败
*/
- (int)stopRelay:(NSArray *_Nullable)pushUrls;
/**
@brief 更新转推、录制
@discussion 转推和录制使用同一个模板 ，若转推和录制同时进行时，则会同时更新转推和录制； 添加、删除流时，设置streams为更改后的全量列表
@param mixConfig 构建转推、录制的模型
@return 0: 方法调用成功  < 0: 方法调用失败
*/
- (int)updateMixConfig:(UCloudRtcMixConfig *_Nonnull)mixConfig;
/**
@brief 查询

@return 0: 方法调用成功  < 0: 方法调用失败
*/
- (int)queryMix;


/**
@brief 添加流 （已弃用，使用 "startMix:"，UCloudRtcMixStopConfig的streams全量列表 ）

@return 0: 方法调用成功  < 0: 方法调用失败
*/
- (int)addMixStream:(NSArray *_Nonnull)streams;


/**
@brief 删除流 （（已弃用，使用 "startMix:"，UCloudRtcMixStopConfig的streams全量列表）

@return 0: 方法调用成功  < 0: 方法调用失败
*/
- (int)deleteMixStream:(NSArray *_Nonnull)streams;

/**
@brief 本地视频流截图（该方法将废弃，v1.5.9后请使用“snapshotWithStream: completion:”）
*/
- (void)captuerVideoImage:(void(^_Nullable)(UIImage *_Nullable))captureImage;
/**
 *@brief 视频快照
 *@param stream 该流对象的快照，可以是本地流和远端流
 *@param complete 快照回调
*/
- (void)snapshotWithStream:(UCloudRtcStream *_Nonnull)stream completion:(void(^_Nullable)(UIImage *_Nullable))complete;


/**
 *@brief 上传自定义视频
 *@param pixelBuffer 每帧图片信息
 *@param timestamp 每帧对应的时间
 *@param rotation 旋转方向
*/
- (void)publishPixelBuffer:(CVPixelBufferRef _Nonnull)pixelBuffer timestamp:(CMTime)timestamp rotation:(UCloudRtcVideoRotation)rotation;

@end

//
//  UCloudRtcEngine.h
//  UCloudRtcSDK
//
//  Created by tony on 2019/2/1.
//  Copyright © 2019年 ucloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger)
{
    UCloudRtcEngine_StreamProfileAll = 0,            // 所有权限 默认值
    UCloudRtcEngine_StreamProfileUpload = 1,          // 上传权限
    UCloudRtcEngine_StreamProfileDownload = 2,          // 下载权限
    
} UCloudRtcEngineStreamProfile;


typedef NS_ENUM(NSInteger)
{
    
    UCloudRtcEngine_VideoProfile_180P = 0,            // 240*180  100 --- 200 15
    UCloudRtcEngine_VideoProfile_360P_1 = 1,          // 480*360  100 -- 300 15   默认值
    UCloudRtcEngine_VideoProfile_360P_2 = 2,          // 640*360  100 -- 400 20
    
    UCloudRtcEngine_VideoProfile_480P = 3,           // 640*480  100 -- 500 20
    UCloudRtcEngine_VideoProfile_720P = 4,           // 1280*720 300 -- 1000 30
//    UCloudRtcEngine_VideoProfile_1080P = 5,          // 1920*1080 500 -- 1000 30
    
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

@class UCloudRtcEngine,UCloudRtcStream,UCloudRtcError,UCloudRtcRoomStream,UCloudRtcStreamVolume;
@protocol UCloudRtcEngineDelegate <NSObject>
@optional
/**加入房间成功*/
- (void)uCloudRtcEngineDidJoinRoom:(NSMutableArray<UCloudRtcStream *> * _Nonnull)canSubStreamList;
/**退出房间*/
- (void)uCloudRtcEngineDidLeaveRoom:(UCloudRtcEngine *_Nonnull)manager;
/**与房间的连接断开*/
- (void)uCloudRtcEngineDisconnectRoom:(UCloudRtcEngine *_Nonnull)manager;


/**发布状态的变化*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager didChangePublishState:(UCloudRtcEnginePublishState)publishState;

/**收到远程流*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager receiveRemoteStream:(UCloudRtcStream *_Nonnull)stream;

/**远程流断开(本地移除对应的流)*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager didRemoveStream:(UCloudRtcStream *_Nonnull)stream;


/**新成员加入*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager memberDidJoinRoom:(NSDictionary *_Nonnull)memberInfo;

/**成员退出*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager memberDidLeaveRoom:(NSDictionary *_Nonnull)memberInfo;

/**非自动订阅模式下 可订阅流加入*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)channel newStreamHasJoinRoom:(UCloudRtcStream *_Nonnull)stream;

///**非自动订阅模式下 可订阅流退出*/
//- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)channel streamHasLeaveRoom:(UCloudRtcStream *_Nonnull)stream;

/**非自动订阅模式下 订阅成功的回调*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)channel didSubscribe:(UCloudRtcStream *_Nonnull)stream;

/**非自动订阅模式下 取消订阅成功的回调*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)channel didCancleSubscribe:(UCloudRtcStream *_Nonnull)stream;


/**流 音量回调*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager didReceiveStreamVolume:(NSArray<UCloudRtcStreamVolume*> *_Nonnull)volume;

/**流 连接失败*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager streamConnectionFailed:(NSString *_Nonnull)streamId;

/**错误的回调*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager error:(UCloudRtcError *_Nonnull)error;
@end

@interface UCloudRtcEngine : NSObject
@property (nonatomic, strong) NSString * _Nonnull userId;//用户id
@property (nonatomic, strong) NSString * _Nonnull roomId;//房间id
@property (nonatomic, strong) NSString * _Nonnull appId;//app id
@property (nonatomic, strong) NSString * _Nonnull token;

/**是否自动发布  默认是: YES  必须在加入房间之前设置才会生效 否则采用默认值*/
@property (nonatomic, assign) BOOL isAutoPublish;

/**是否自动订阅  默认是: YES 必须在加入房间之前设置才会生效 否则采用默认值*/
@property (nonatomic, assign) BOOL isAutoSubscribe;

/**是否开启纯音频模式  默认否: NO  必须在加入房间之前设置才会生效 否则采用默认值*/
@property (nonatomic, assign) BOOL isOnlyAudio;

/**视频分辨率设置 默认:480*360  必须在加入房间之前设置才会生效 否则采用默认值*/
@property (nonatomic, assign) UCloudRtcEngineVideoProfile videoProfile;

/**本地流权限设置 默认:所有权限  必须在加入房间之前设置才会生效 否则采用默认值*/
@property (nonatomic, assign) UCloudRtcEngineStreamProfile streamProfile;

/**是否开启免提*/
@property (nonatomic, assign, readonly) BOOL isLoudSpeaker;

@property (nonatomic, weak) id <UCloudRtcEngineDelegate> _Nullable delegate;

@property (nonatomic, readonly) UCloudRtcStream * _Nonnull localStream;

/**是否开启日志*/
+ (void)setLogEnable:(BOOL)enable;

/**当前版本号*/
+ (NSString *_Nonnull)currentVersion;

/**初始化方法 new */
- (instancetype _Nonnull )initWithUserId:(NSString *_Nonnull)userId appId:(NSString *_Nonnull)appId roomId:(NSString *_Nonnull)roomId;

/**加入房间*/
- (void)joinRoomWithcompletionHandler:(void (^_Nonnull)(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error))completion;

/**退出房间*/
- (void)leaveRoom;

/**手动发布*/
- (void)publish;
/**取消发布*/
- (void)unPublish;

/**手动订阅*/
- (void)subscribeMethod:(UCloudRtcStream *_Nonnull)stream;
///**取消订阅*/
- (void)unSubscribeMethod:(UCloudRtcStream *_Nonnull)stream;

/**设置本地的预览画面*/
- (void)setLocalPreview:(UIView *_Nonnull)preview;

/**切换本地摄像头*/
- (void)switchCamera;

/**设置本地流是否静音*/
- (void)setMute:(BOOL)isMute;

/**设置本地流是否禁用视频*/
- (void)openCamera:(BOOL)isOpen;

/**开启免提*/
- (void)openLoudspeaker:(BOOL)isOpen;

/**设置远程流是否禁用视频*/
- (void)setRemoteStream:(UCloudRtcStream *_Nonnull)stream muteVideo:(BOOL)isMute;

/**设置远程流是否禁用音频*/
- (void)setRemoteStream:(UCloudRtcStream *_Nonnull)stream muteAudio:(BOOL)isMute;

@end

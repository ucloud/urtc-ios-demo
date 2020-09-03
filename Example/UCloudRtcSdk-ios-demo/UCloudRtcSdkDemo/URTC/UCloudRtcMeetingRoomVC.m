//
//  UCloudRtcMeetingRoomVC.m
//  UCloudRtcSdkDemo
//
//  Created by ucloud on 2020/4/20.
//  Copyright © 2020 ucloud. All rights reserved.
//

#import "UCloudRtcMeetingRoomVC.h"
#import "UCloudRtcRoomCell.h"
#import "UIView+Toast.h"
#import "MLMenuView.h"
#import "NativeMediaViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "URTCRecodView.h"
#import "URTCFileCaptureController.h"
#import "URTCResolutionChoosePicker.h"


// 判断iPhoneX
// 判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhone11
#define IS_IPHONE_11 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define IS_IPHONE_11_Pro ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define IS_IPHONE_11_Pro_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define  k_StatusBarHeight    [UIApplication sharedApplication].statusBarFrame.size.height
#define  k_NavigationBarHeight  44.f
#define  k_StatusBarAndNavigationBarHeight   (k_StatusBarHeight + k_NavigationBarHeight)
// home indicator
#define HOME_INDICATOR_HEIGHT ((iPhoneX == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES || IS_IPHONE_11 == YES || IS_IPHONE_11_Pro == YES || IS_IPHONE_11_Pro_Max == YES) ? -34 : 0)
@interface UCloudRtcMeetingRoomVC ()<UCloudRtcEngineDelegate, UICollectionViewDataSource, UICollectionViewDelegate, URTCFileCaptureControllerDelegate>
{
    NSMutableArray<UCloudRtcStream*> *_canSubstreamList;
    AVAudioRecorder *recorder;
    NSTimer *levelTimer;
    URTCFileCaptureController *_fileCaptureController;
}

@property (weak, nonatomic) IBOutlet UILabel *roomIdLB;
@property (weak, nonatomic) IBOutlet UILabel *liveTimeLB;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *localPreview;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UIButton *audioBtn;
@property (weak, nonatomic) IBOutlet UIImageView *network;
@property (weak, nonatomic) IBOutlet UIImageView *volumImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraints;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewH;
@property (weak, nonatomic) IBOutlet UIImageView *useridBack;
@property (weak, nonatomic) IBOutlet UILabel *useridLabel;
@property (nonatomic , strong) UCloudRtcEngine *rtcEngine;
@property (nonatomic, strong) NSMutableArray *remoteStreamList;//已订阅远端流
@property (nonatomic, strong) NSMutableArray *collectionViewRenderList;//collectionview渲染列表
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) URTCRecodView *recordView;
@end

static NSString *roomCellId = @"roomCellId";
@implementation UCloudRtcMeetingRoomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _canSubstreamList = [NSMutableArray arrayWithCapacity:0];
    _remoteStreamList = [NSMutableArray arrayWithCapacity:0];
    _collectionViewRenderList = [NSMutableArray arrayWithCapacity:0];
    _roomIdLB.text = [NSString stringWithFormat:@"%@ / %@",_roomId,_userId];
    _useridLabel.text = _userId;
    _topViewH.constant = k_StatusBarAndNavigationBarHeight;
    _bottomViewC.constant = HOME_INDICATOR_HEIGHT;
    UITapGestureRecognizer *tapLocalView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLocalView)];
    [_localPreview addGestureRecognizer:tapLocalView];
    
    [self setupTimer];
    // 初始化RTC
    [self setupUCloudRtcEngine];
    
    // 渲染远程流的CollectionView
    [self setupCollectionView];
    
}


- (void)setupTimer {
    __block int count = 0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        count ++;
        int seconds = count % 60;
        int minutes = (count / 60) % 60;
        int hours = count / 3600;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.liveTimeLB.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
        });
    });
    dispatch_resume(_timer);
    
    //初始化音量检查代码
    [[AVAudioSession sharedInstance]
    setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
    [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
    [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
    [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
    [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,
    nil];
    NSError *error;
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (recorder)
    {
        [recorder prepareToRecord];
        recorder.meteringEnabled = YES;
        [recorder record];
        levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.3 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
    }
}

/* 音量会随环境音量变化而变化*/
- (void)levelTimerCallback:(NSTimer *)timer {
    [recorder updateMeters];
    float   level;
    float   minDecibels = -60.0f;
    float   decibels    = [recorder averagePowerForChannel:0];
    if (decibels < minDecibels)
    {
        level = 0.0f;
    }
    else if (decibels >= 0.0f)
    {
        level = 1.0f;
    }
    else
    {
        float   root            = 5.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        level = powf(adjAmp, 1.0f / root);
    }
    /* level 范围[0 ~ 1], 转为[0 ~120] 之间 */
    level = level * 120;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (level >= 0 && level < 20) {
            self->_volumImage.image = [UIImage imageNamed:@"volum1"];
        }else if (level >= 20 && level < 40) {
            self->_volumImage.image = [UIImage imageNamed:@"volum2"];
        }else if (level >= 40 && level < 60) {
            self->_volumImage.image = [UIImage imageNamed:@"volum3"];
        }else if (level >= 60 && level < 80) {
            self->_volumImage.image = [UIImage imageNamed:@"volum4"];
        }else if (level >= 80 && level < 100) {
            self->_volumImage.image = [UIImage imageNamed:@"volum5"];
        }else if (level >= 100 && level < 120) {
            self->_volumImage.image = [UIImage imageNamed:@"volum6"];
        }
    });
}

#pragma mark-- 初始化、设置RTC、启动
- (void)setupUCloudRtcEngine {
    // 创建引擎
    _rtcEngine = [[UCloudRtcEngine alloc] initWithAppID:self.appId appKey:self.appKey completionBlock:^(int errorCode) {
        NSLog(@"初始化errorCode：%d",errorCode);
    }];
    
    //获取配置页面信息 配置引擎
     NSDictionary *settingDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"setting"];
    if (settingDic == nil) {
        settingDic = @{
            @"isVideo": @(1),
            @"isAudio": @(1),
            @"isAutoPub": @(1),
            @"isAutoSub": @(1),
            @"isLog": @(0),
            @"videoProfile": @(3)
        };
    }
    NSInteger isVideo = ((NSString*)[settingDic valueForKey:@"isVideo"]).integerValue;
    NSInteger isAudio = ((NSString*)[settingDic valueForKey:@"isAudio"]).integerValue;
    NSInteger isAutoPub = ((NSString*)[settingDic valueForKey:@"isAutoPub"]).integerValue;
    NSInteger isAutoSub = ((NSString*)[settingDic valueForKey:@"isAutoSub"]).integerValue;
    NSInteger isLog = ((NSString*)[settingDic valueForKey:@"isLog"]).integerValue;
    NSInteger videoProfile = ((NSString*)[settingDic valueForKey:@"videoProfile"]).integerValue;
    //设置是否包含本地视频
    _rtcEngine.enableLocalVideo = (isVideo == 1) ? YES : NO;
    _videoBtn.selected = (isVideo == 1);
    //设置是否包含本地音频
    _rtcEngine.enableLocalAudio = (isAudio == 1) ? YES : NO;
    if (_rtcEngine.enableLocalVideo) {
            _useridLabel.hidden = YES;
            _useridBack.hidden = YES;
    }
    _audioBtn.selected = (isAudio == 1);
    //设置是否自动发布
    _rtcEngine.isAutoPublish = (isAutoPub == 1) ? YES : NO;
    //设置是否自动订阅
    _rtcEngine.isAutoSubscribe = (isAutoSub == 1) ? YES : NO;
    // 设置日志级别
    if (isLog == 1) {
        [_rtcEngine.logger setLogLevel:UCloudRtcLogLevel_DEBUG];
    }else{
        [_rtcEngine.logger setLogLevel:UCloudRtcLogLevel_OFF];
    }
    //设置视频分辨率
    _rtcEngine.videoProfile = videoProfile;
    //设置本地镜像
    _rtcEngine.mirrorMode = UCloudRtcVideoMirrorModeDisabled;
    //设置远端渲染模式
    [_rtcEngine setRemoteViewMode:(UCloudRtcVideoViewModeScaleAspectFit)];
    [_rtcEngine setPreviewMode:(UCloudRtcVideoViewModeScaleAspectFill)];
    
    // 本地录制文件输出路径
    NSString *tempDir = NSTemporaryDirectory();
    _rtcEngine.outputpath = [tempDir substringToIndex:tempDir.length-1];
    // 开启本地录制
    _rtcEngine.openNativeRecord = true;
    //房间类型
    _rtcEngine.roomType = self.roomType;
    // 断网重连次数   默认为：10次
    _rtcEngine.reConnectTimes = 30;
    // 重连时间间隔，默认60秒钟
    _rtcEngine.overTime = 10;
    // 设置视频编码格式，默认VP8，可选 VP8 || H264
    _rtcEngine.videoDefaultCodec = @"H264";
    // 设置视频分辨率
    _rtcEngine.videoProfile = UCloudRtcEngine_VideoProfile_480P;
    // 是否开启音量检测，默认NO
//    _rtcEngine.isTrackVolume = YES;
    // 开启自定义视频源,默认为NO
//    _rtcEngine.enableExtendVideoCapture = YES;
    if (_rtcEngine.enableExtendVideoCapture) {
        // 用户自行设置要发送的视频数据
        [self createFileCapture];// 测试
    }
    
    // 设置代理
    _rtcEngine.delegate = self;
    // 加入房间
    [_rtcEngine joinRoomWithRoomId:_roomId userId:_userId token:_token completionHandler:^(NSDictionary * _Nonnull response, int errorCode) {
        
    }];
    //添加本地预览
//    [_rtcEngine setLocalPreview:_localPreview];
}

/// 自定义视频源（从文件读取视频上传）
- (void)createFileCapture {
    _fileCaptureController = [URTCFileCaptureController new];
    [_fileCaptureController startCapturingFromFileNamed:@"test480.mp4" onError:^(NSString * _Nonnull error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    _fileCaptureController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark --操作--
/// 退出房间
/// @param sender btn
- (IBAction)leaveRoom:(UIButton *)sender {
    [_rtcEngine leaveRoom];
    if (_fileCaptureController) {
        [_fileCaptureController stopCapture];
    }
    [self dismissViewControllerAnimated:true completion:nil];
}


/// 切换摄像头
/// @param sender sender description
- (IBAction)didSwitchCameraAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [_rtcEngine switchCamera];
}

/// 关闭/开启麦克风
/// @param sender sender description
- (IBAction)didSetMicrophoneMuteAction:(UIButton *)sender {
    if (_rtcEngine.enableLocalAudio) {
        sender.selected = !sender.selected;
        [_rtcEngine setMute:!sender.selected];
    }else{
        [self.view makeToast:@"音频模块不可用,请在设置页面开启" duration:2 position:CSToastPositionCenter];
    }
}
/// 关闭/开启摄像头
/// @param sender sender description
- (IBAction)didOpenVideoAction:(UIButton *)sender {
    if (_rtcEngine.enableLocalVideo) {
        if (sender.selected) {
            _useridLabel.hidden = NO;
            _useridBack.hidden = NO;
        }else{
            _useridLabel.hidden = YES;
            _useridBack.hidden = YES;
        }
        sender.selected = !sender.selected;
        [_rtcEngine openCamera:sender.selected];
    }else{
        [self.view makeToast:@"视频模块不可用,请在设置页面开启" duration:2 position:CSToastPositionCenter];
        _useridLabel.hidden = NO;
        _useridBack.hidden = NO;
    }
}
/// 切换扬声器、听筒
/// @param sender sender description
- (IBAction)didOpenLoudspeakerAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [_rtcEngine openLoudspeaker:sender.selected];
}

- (IBAction)didOPenMoreAction:(UIButton *)sender {
   [self setupTopMenu];
}

- (IBAction)didMirrorAction:(UIButton *)sender {
    if (_rtcEngine.mirrorMode == UCloudRtcVideoMirrorModeEnabled) {
        _rtcEngine.mirrorMode = UCloudRtcVideoMirrorModeDisabled;
    }else if(_rtcEngine.mirrorMode == UCloudRtcVideoMirrorModeDisabled){
        _rtcEngine.mirrorMode = UCloudRtcVideoMirrorModeEnabled;
    }
}


#pragma mark -- UCloudRtcEngineDelegate
/**退出房间*/
- (void)uCloudRtcEngineDidLeaveRoom:(UCloudRtcEngine *_Nonnull)manager {
    
}

/**与房间的连接断开*/
- (void)uCloudRtcEngineDisconnectRoom:(UCloudRtcEngine *_Nonnull)manager {

}

/**收到远程流*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager receiveRemoteStream:(UCloudRtcStream *_Nonnull)stream {
    if (stream) {
        [_remoteStreamList addObject:stream];
    }
    [_collectionView reloadData];
}

/**远程流断开(本地移除对应的流)*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager didRemoveStream:(UCloudRtcStream *_Nonnull)stream {
    UCloudRtcStream *delete = [UCloudRtcStream new];
    for (UCloudRtcStream *obj in _remoteStreamList) {
        if ([obj.userId isEqualToString:stream.userId]) {
            delete = obj;
            break;
        }
    }
    [_remoteStreamList removeObject:delete];
    [_collectionView reloadData];
}

/**新成员加入*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager memberDidJoinRoom:(NSDictionary *_Nonnull)memberInfo {
    NSString *message = [NSString stringWithFormat:@"用户:%@ 加入房间",memberInfo[@"user_id"]];
    [self.view makeToast:message duration:1.5 position:CSToastPositionCenter];
}

/**成员退出*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager memberDidLeaveRoom:(NSDictionary *_Nonnull)memberInfo {
    NSString *message = [NSString stringWithFormat:@"用户:%@ 离开房间",memberInfo[@"user_id"]];
    [self.view makeToast:message duration:1.5 position:CSToastPositionCenter];
}

/**非自动订阅模式下 可订阅流加入*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)channel newStreamHasJoinRoom:(UCloudRtcStream *_Nonnull)stream {
    [self.view makeToast:@"有新的流可以订阅" duration:1.5 position:CSToastPositionCenter];
    [_canSubstreamList addObject:stream];
    [_rtcEngine subscribeMethod:stream];
}

///**非自动订阅模式下 可订阅流退出*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)channel streamHasLeaveRoom:(UCloudRtcStream *_Nonnull)stream {
    [self.view makeToast:@"可订阅的流离开" duration:1.5 position:CSToastPositionCenter];
    UCloudRtcStream *newS = [UCloudRtcStream new];
    for (UCloudRtcStream *tempS in _canSubstreamList) {
       if ([tempS.streamId isEqualToString:stream.streamId]) {
           newS = tempS;
           break;
       }
    }
    [_canSubstreamList removeObject:newS];
}


/**流 状态回调*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager didReceiveStreamStatus:(NSArray<UCloudRtcStreamStatsInfo*> *_Nonnull)status {
}

- (void)uCloudRtcEngine:(UCloudRtcEngine *)manager didChangePublishState:(UCloudRtcEnginePublishState)publishState mediaType:(UCloudRtcStreamMediaType)mediaType {
    NSString *titile = @"";
    NSString *tips = @"";
    switch (publishState) {
        case UCloudRtcEnginePublishStateUnPublish:
            titile = @"未发布";
            tips = @"未发布";
            break;
        case UCloudRtcEnginePublishStatePublishing: {
            titile = @"发布中...";
            tips = @"发布中...";
            break;
        }
            
        case UCloudRtcEnginePublishStatePublishSucceed:{
            titile = @"取消发布";
            tips = @"发布成功";
            if (mediaType == UCloudRtcStreamMediaTypeScreen) {
                // FIXME: screen
                
            } else {
                [self.rtcEngine.localStream renderOnView:_localPreview];
            }
            break;
        }
        case UCloudRtcEnginePublishStateRepublishing: {
            titile = tips = @"正在重新发布...";
            break;
        }
        case UCloudRtcEnginePublishStatePublishFailed: {
            titile = @"重新发布";
            tips = @"发布失败";
            break;
        }
        case UCloudRtcEnginePublishStatePublishStoped: {
            titile = @"重新发布";
            tips = @"发布已停止";
            if (mediaType == UCloudRtcStreamMediaTypeScreen) {

            }
            break;
        }
        default:
            break;
    }

    [self.view makeToast:tips duration:1.5 position:CSToastPositionCenter];
    NSLog(@"didChangePublishState:%@",tips);
    // FIXME:screen
//    [self didChangePublishStateWithMediaType:mediaType tittle:titile];
}

- (void)didChangePublishStateWithMediaType:(UCloudRtcStreamMediaType)mediaType tittle:(NSString *)title {
    switch (mediaType) {
        case UCloudRtcStreamMediaTypeCamera:
            break;
        case UCloudRtcStreamMediaTypeScreen:
            break;
        default:
            break;
    }
}
/**流 连接失败*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager streamConnectionFailed:(NSString *_Nonnull)streamId {

}

/**错误的回调*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager error:(UCloudRtcError *_Nonnull)error {
    switch (error.errorType) {
        case UCloudRtcErrorTypeTokenInvalid:
            [self.view makeToast:[NSString stringWithFormat:@"token无效"] duration:3.0 position:CSToastPositionCenter];
            break;
        case UCloudRtcErrorTypeJoinRoomFail:
            [self.view makeToast:[NSString stringWithFormat:@"加入房间失败：%@",error.message] duration:3.0 position:CSToastPositionCenter];
            break;
        case UCloudRtcErrorTypeCreateRoomFail:
            break;
        case UCloudRtcErrorTypePublishStreamFail: {
            [self.view makeToast:[NSString stringWithFormat:@"发布失败：%@",error.message] duration:3.0 position:CSToastPositionCenter];
        }
            break;
        default:
            [self.view makeToast:[NSString stringWithFormat:@"错误%ld:%@",(long)error.code,error.message] duration:3.0 position:CSToastPositionCenter];
            break;
    }
}

/**开始视频录制的回调*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager startRecord:(NSDictionary *_Nonnull)recordResponse {
    [self.view makeToast:[NSString stringWithFormat:@"视频录制文件:%@",recordResponse[@"FileName"]] duration:3.0 position:CSToastPositionCenter];
}



/**收到自定义消息的回调*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager receiveCustomCommand:(NSString *_Nonnull)fromUserID  content:(NSString *_Nonnull)content {

}

/**远端视频关闭的回调*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)channel remoteVideoMute:(BOOL)remoteVideoMute {

}

/**媒体播放器播放结束的回调*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)channel mediaPlayerOnPlayEnd:(BOOL)isEnd {

}

/**网络连接状态变化的回调*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *_Nonnull)manager connectState:(UCloudRtcConnectState)connectState {

}
/**音量回调 200ms一次：设置isTrackVolume=YES时可以接收各路流的音量*/
- (void)uCloudRtcEngine:(UCloudRtcEngine *)manager didReceiveAudioStatus:(UCloudRtcAudioStats *)audioStatus {
    
}
-(void)uCloudRtcEngine:(UCloudRtcEngine *)manager networkQuality:(NSString *)userId txQuality:(UCloudRtcNetworkQuality)txQuality rxQuality:(UCloudRtcNetworkQuality)rxQuality{
    if ([userId isEqualToString:self.userId]) {
        if (txQuality == UCloudRtcNetworkQualityDisconnect) {
            _network.image = [UIImage imageNamed:@"single0"];
        }
        else if(txQuality == UCloudRtcNetworkQualityPoorest || txQuality == UCloudRtcNetworkQualityPoorer){
            _network.image = [UIImage imageNamed:@"single1"];
        }
        else if(txQuality == UCloudRtcNetworkQualityPoor){
            _network.image = [UIImage imageNamed:@"single2"];
        }
        else if(txQuality == UCloudRtcNetworkQualityGood){
            _network.image = [UIImage imageNamed:@"single3"];
        }
        else if(txQuality == UCloudRtcNetworkQualityExcellent){
            _network.image = [UIImage imageNamed:@"single4"];
        }
    }
}

- (void)setupTopMenu{//@"旁路推流",@"push"
    NSArray *titles = @[@"云端录制",@"开始本地录制",@"结束本地录制",@"播放录制视频",@"截图"];
    NSArray *images = @[@"record_cloud",@"record",@"record_end",@"play",@"cut"];
    MLMenuView *menuView = [[MLMenuView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 130 - 10, 0, 130, 44 * titles.count) WithTitles:titles WithImageNames:images WithMenuViewOffsetTop:k_StatusBarAndNavigationBarHeight WithTriangleOffsetLeft:80];
    menuView.didSelectBlock = ^(NSInteger index) {
        NSLog(@"%zd",index);
        switch (index) {
            case 0:
                [self cloudRecord];
                break;
            case 1:
                [self startRecord];
                break;
            case 2:
                [self stopRecord];
                break;
            case 3:
                [self play];
                break;
//            case 4:
//                [self push];
//                break;
            case 4:
                [self cutLocalVideoImage];
                break;
            default:
                break;
        }
    };
    [menuView showMenuEnterAnimation:MLEnterAnimationStyleRight];
    [self.view addSubview:menuView];
}

//本地流截图
- (void)cutLocalVideoImage{
    [_rtcEngine captuerVideoImage:^(UIImage * _Nullable image) {
        if (image) {
            /// 保存到本地相册
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
    }];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (error) {
        NSLog(@"保存失败，请重试");
    } else {
        NSLog(@"保存成功");
    }
}

//开始本地视频录制
- (void)startRecord{
    [_rtcEngine startNativeRecord];
}

//停止本地视频录制
- (void)stopRecord{
    [_rtcEngine stopNativeRecord];
}

//播放本地视频录制
- (void)play{
    NativeMediaViewController *mediaVC = [NativeMediaViewController new];
    mediaVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:mediaVC animated:YES completion:nil];
}

//开始旁路推流
- (void)push{
    
}

//开始云端录制
- (void)cloudRecord{
    if (!_recordView) {
        _recordView = [[[NSBundle mainBundle] loadNibNamed:@"URTCRecodView" owner:self options:nil]objectAtIndex:0];
        _recordView.layer.masksToBounds = YES;
        _recordView.layer.cornerRadius = 22.f;
        _recordView.frame = CGRectMake(20, 120, 125, 44);
        _recordView.didSelectBlock = ^(URTCRecordViewStatus status) {
            switch (status) {
                case URTCRecordViewStatus_Start:
                    NSLog(@"start cloud record.");
                    [self record];
                    break;
                case URTCRecordViewStatus_Stop:
                    NSLog(@"stop cloud record.");
                    [self->_rtcEngine stopRecord];
                    break;
                case URTCRecordViewStatus_Close:
                    NSLog(@"close");
                    self->_recordView = nil;
                    break;
                default:
                    break;
            }
        };
        [self.view addSubview:_recordView];
    }
}

//配置云端录制相关参数
- (void)record{
    //配置视频录制相关参数
    UCloudRtcRecordConfig *recordConfig = [UCloudRtcRecordConfig new];
    recordConfig.mainviewid = _userId;
    recordConfig.mimetype = 3;
    recordConfig.mainviewmt = 1;
    recordConfig.bucket = @"urtc-test";
    recordConfig.region = @"cn-bj";
    recordConfig.watermarkpos = 1;
    recordConfig.width = 480;
    recordConfig.height = 640;
    recordConfig.isaverage = YES;
    recordConfig.waterurl = @"http://urtc-living-test.cn-bj.ufileos.com/test.png";
    recordConfig.watertype = 1;
    recordConfig.wtemplate = 9;
    [_rtcEngine startRecord:recordConfig];
}
#pragma mark-- CollectionView


- (void)setupCollectionView {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.itemSize = CGSizeMake(width*0.3, width*0.3);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView.collectionViewLayout = flowLayout;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.alwaysBounceHorizontal = YES;
    [_collectionView registerNib:[UINib nibWithNibName:@"UCloudRtcRoomCell" bundle:nil] forCellWithReuseIdentifier:roomCellId];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_remoteStreamList count];
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UCloudRtcRoomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:roomCellId forIndexPath:indexPath];
    cell.stream = _remoteStreamList[indexPath.item];
    
    __weak typeof(self) weakSelf = self;
    cell.muteComplete = ^(UCloudRtcStream * _Nonnull stream, int type, BOOL mute) {
        switch (type) {
            case 0:
                [weakSelf.rtcEngine setRemoteStream:stream muteVideo:mute];
                break;
             case 1:
                [weakSelf.rtcEngine setRemoteStream:stream muteAudio:mute];
                break;
            default:
                break;
        }
    };
    return cell;
}

//UI动画
- (void)tapLocalView{
    if (_topConstraints.constant == 0.0) {
        [UIView animateWithDuration:.25
                         animations:^{
            
            self->_topConstraints.constant = - k_StatusBarAndNavigationBarHeight;
            [self.view layoutIfNeeded];
        }];
    }else{
        [UIView animateWithDuration:.25 animations:^{
            self->_topConstraints.constant = 0.0;
            [self.view layoutIfNeeded];
        }];
    }
    if (_bottomConstraints.constant == HOME_INDICATOR_HEIGHT) {
        [UIView animateWithDuration:.25 animations:^{
            self->_bottomConstraints.constant =  -68 + HOME_INDICATOR_HEIGHT;
            [self.view layoutIfNeeded];
        }];
    }else{
        [UIView animateWithDuration:.25 animations:^{
            self->_bottomConstraints.constant = HOME_INDICATOR_HEIGHT;
            [self.view layoutIfNeeded];
        }];
    }

}

#pragma mark-- 自定义视频源采集回调
- (void)capturer:(URTCFileCaptureController *)fileCaptureController didCaptureVideoPixelBufferRef:(CVPixelBufferRef)pixelBufferRef timestamp:(CMTime)timestamp {
    if (self.rtcEngine.enableExtendVideoCapture) {
        [self.rtcEngine publishPixelBuffer:pixelBufferRef timestamp:timestamp rotation:(UCloudRtcVideoRotation_0)];
    }
    
}

- (void)dealloc {
    NSLog(@"-%@- dealloc", self);
}
@end

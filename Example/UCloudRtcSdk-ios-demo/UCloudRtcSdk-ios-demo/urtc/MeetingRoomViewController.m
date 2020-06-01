//
//  MeetingRoomViewController.m
//  UCloudRtcSdkDemo
//
//  Created by tony on 2019/4/2.
//  Copyright © 2019年 ucloud. All rights reserved.
//

#import "MeetingRoomViewController.h"
#import "UIView+Toast.h"
#import "MeetingRoomCell.h"
#import "YBPopupMenu.h"

@interface MeetingRoomViewController () <UCloudRtcEngineDelegate, UICollectionViewDataSource, UICollectionViewDelegate,YBPopupMenuDelegate,MeetingRoomCellDelegate>
{
    NSMutableArray<UCloudRtcStream*> *canSubstreamList;
}
@property (weak, nonatomic) IBOutlet UICollectionView *listView;
@property (weak, nonatomic) IBOutlet UIView *localView;
@property (weak, nonatomic) IBOutlet UIView *settingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthOfSettingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfListView;

@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
@property (nonatomic , strong) UCloudRtcEngine *manager;
@property (nonatomic, strong) NSMutableArray *streamList;//已订阅远端流

@property (nonatomic, assign) BOOL isConnected;
@property (nonatomic, strong) UCloudRtcStream *bigScreenStream;

@property (nonatomic, strong) YBPopupMenu *popupMenu;//可订阅流弹出视图

//视频录制相关
@property (nonatomic, assign) int seconds;
@property (nonatomic, assign) int minutes;
@property (nonatomic, assign) int hours;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end

static NSInteger kHorizontalCount = 3;

@implementation MeetingRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isConnected = NO;
    canSubstreamList = [NSMutableArray new];
    self.streamList = @[].mutableCopy;
    self.roomNameLabel.text = [NSString stringWithFormat:@"ROOM:%@",self.roomId];
    [self.listView registerNib:[UINib nibWithNibName:@"MeetingRoomCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    //初始化engine
    self.manager = [[UCloudRtcEngine alloc]initWithAppID:self.appId appKey:self.appKey completionBlock:^(int errorCode) {}];
    //设置远端视频渲染模式
    [self.manager setRemoteViewMode:UCloudRtcVideoViewModeScaleAspectFit];
    //指定SDK模式
    self.manager.engineMode = self.engineMode;
    //设置日志级别
    [self.manager.logger setLogLevel:UCloudRtcLogLevel_DEBUG];
//    self.manager.isTrackNetQuality = YES;
    //混音相关配置
//    NSString *file = [[NSBundle mainBundle] pathForResource:@"dy" ofType:@"mp3"];
//    self.manager.fileMix = NO;
//    self.manager.fileLoop = YES;
//    self.manager.filePath = file ? file : @"";
//
//    self.manager.videopath = @"aaa";
//    self.manager.audiopath = @"bbb";
    NSString *tmpDir = NSTemporaryDirectory();
    self.manager.outputpath = [tmpDir substringToIndex:tmpDir.length-1];
    self.manager.openNativeRecord = YES;

    self.manager.reConnectTimes = 30;
    self.manager.overTime = 10;
    
    //设置视频编码格式
    self.manager.videoDefaultCodec = @"H264";
    //设置代理
    self.manager.delegate = self;
    //配置SDK
    [self settingSDK:self.engineSetting];
    NSLog(@"sdk版本号：%@",[UCloudRtcEngine currentVersion]);
    //加入房间
    [self.manager joinRoomWithRoomId:self.roomId userId:self.userId token:@"" completionHandler:^(NSDictionary * _Nonnull response, int errorCode) {
    }];
}

- (void)settingSDK:(NSDictionary *)setting{
    if (setting[@"isAutoPublish"]) {
        NSString * isAutoPublish = [NSString stringWithFormat:@"%@",setting[@"isAutoPublish"]];
        NSString * isAutoSubscribe = [NSString stringWithFormat:@"%@",setting[@"isAutoSubscribe"]];
        NSString * isOnlyAudio = [NSString stringWithFormat:@"%@",setting[@"isOnlyAudio"]];
        NSString * videoProfile = [NSString stringWithFormat:@"%@",setting[@"videoProfile"]];
        NSString * streamProfile = [NSString stringWithFormat:@"%@",setting[@"streamProfile"]];
        NSString * roomType = [NSString stringWithFormat:@"%@",setting[@"roomType"]];
        NSString * isDebug = [NSString stringWithFormat:@"%@",setting[@"isDebug"]];
        self.manager.isAutoPublish = isAutoPublish.boolValue;
        self.manager.isAutoSubscribe = isAutoSubscribe.boolValue;
        self.manager.isOnlyAudio = isOnlyAudio.boolValue;
        
        switch (roomType.integerValue) {
            case 0:
                self.manager.roomType = UCloudRtcEngineRoomType_Communicate;
                break;
            case 1:
                self.manager.roomType = UCloudRtcEngineRoomType_Broadcast;
                break;
            default:
                break;
        }
        switch (videoProfile.integerValue) {
            case 0:
                self.manager.videoProfile = UCloudRtcEngine_VideoProfile_180P;
                break;
            case 1:
                self.manager.videoProfile = UCloudRtcEngine_VideoProfile_360P_1;
                break;
            case 2:
                self.manager.videoProfile = UCloudRtcEngine_VideoProfile_360P_2;
                break;
            case 3:
                self.manager.videoProfile = UCloudRtcEngine_VideoProfile_480P;
                break;
            case 4:
                self.manager.videoProfile = UCloudRtcEngine_VideoProfile_720P;
                break;
            default:
                break;
        }
        switch (streamProfile.integerValue) {
            case 0:
                self.manager.streamProfile =UCloudRtcEngine_StreamProfileUpload ;
                break;
            case 1:
                self.manager.streamProfile = UCloudRtcEngine_StreamProfileDownload;
                break;
            case 2:
                self.manager.streamProfile = UCloudRtcEngine_StreamProfileAll;
                break;
            default:
                break;
        }
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"----didReceiveMemoryWarning");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.manager setPreviewMode:UCloudRtcVideoViewModeScaleAspectFit];
    [self.manager setLocalPreview:self.localView];
    self.bigScreenStream = self.manager.localStream;
    
}

//开始视频录制
- (IBAction)startRecord:(UIButton *)sender {
    if (![sender.titleLabel.text isEqualToString:@"开始录制"]) {
        return;
    }
    [self.view makeToast:@"开始录制" duration:1.0 position:CSToastPositionCenter];
    
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
    [self.manager startRecord:recordConfig];
    
    self.hours = 0;
    self.minutes = 0;
    self.seconds = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
//停止视频录制
- (IBAction)stopRecord:(UIButton *)sender {
    [self.manager stopRecord];
    [self.view makeToast:@"停止录制" duration:1.0 position:CSToastPositionCenter];
    [self.startBtn setTitle:@"开始录制" forState:UIControlStateNormal];
    if (self.timer) {
        if ([self.timer respondsToSelector:@selector(isValid)]){
            if ([self.timer isValid]){
                [self.timer invalidate];
                self.timer = nil;
            }
        }
    }
}

- (void)startTimer {
    self.seconds++;
    if (_seconds == 60) {
        self.minutes++;
        self.seconds = 0;
    }
    if (self.minutes == 60) {
        self.hours++;
        self.minutes = 0;
    }
    [self.startBtn setTitle:[NSString stringWithFormat:@"%.2d:%.2d:%.2d",_hours, _minutes, _seconds] forState:UIControlStateNormal];
}
                  
//退出房间
- (IBAction)leaveRoom:(id)sender {
        [self showAlertWithMessage:@"您确定要退出房间吗" Sure:^{
            [self.manager leaveRoom];
            [self.manager stopMediaPlay];
            [self.manager stopAVCollectionAndPaly];
            [self dismissViewControllerAnimated:YES completion:^{}];
        }];
}


- (void)showAlertWithMessage:(NSString *)message Sure:(void (^)(void))block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     if (block) {
                                                         block();
                                                     }
                                                 }];
    [alert addAction:cancel];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)showSubscribeList:(UIButton *)sender {
    if (canSubstreamList.count > 0) {
        NSMutableArray *titleArray = [NSMutableArray new];
        for (UCloudRtcStream *stream in canSubstreamList) {
            [titleArray addObject:stream.userId];
        }
        [YBPopupMenu showRelyOnView:sender titles:titleArray icons:nil menuWidth:300 otherSettings:^(YBPopupMenu *popupMenu) {
            popupMenu.priorityDirection = YBPopupMenuPriorityDirectionBottom;
            popupMenu.borderWidth = 1;
            popupMenu.borderColor = [UIColor blueColor];
            popupMenu.delegate = self;
        }];
    }
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    //手动订阅一条流  仅限于非自动订阅模式
    UCloudRtcStream  *stream = canSubstreamList[index];
    [canSubstreamList removeObjectAtIndex:index];
    [self.manager subscribeMethod:stream];
}


- (IBAction)didSwitchCameraAction:(id)sender {
    [self.manager switchCamera];
    
}
- (IBAction)didSetMicrophoneMuteAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.manager setMute:sender.selected];
}

- (IBAction)didOpenLoudspeakerAction:(UIButton *)sender {
    [self.manager openLoudspeaker:sender.selected];
    sender.selected = !sender.selected;
}
- (IBAction)didOpenVideoAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.manager openCamera:!sender.selected];
}
#pragma mark - 流
//发布流
- (IBAction)didPublishStreamAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"发布成功"]) {
        [self showAlertWithMessage:@"您确定要取消发布吗" Sure:^{
            NSLog(@"取消发布");
            [self.manager unPublish];
        }];
    } else {
        [self.manager publish];
        self.bigScreenStream = self.manager.localStream;
    }

}


#pragma mark ------UCloudRtcEngineDelegate method-----
-(void)uCloudRtcEngineDidJoinRoom:(BOOL)succeed streamList:(NSMutableArray<UCloudRtcStream *> *)canSubStreamList{
    [self.view makeToast:@"加入房间成功" duration:1.0 position:CSToastPositionCenter];
    self.isConnected = YES;
}

//新成员加入房间
-(void)uCloudRtcEngine:(UCloudRtcEngine *)manager memberDidJoinRoom:(NSDictionary *)memberInfo{
    NSString *message = [NSString stringWithFormat:@"用户:%@ 加入房间",memberInfo[@"user_id"]];
    [self.view makeToast:message duration:1.5 position:CSToastPositionCenter];
}
//成员离开房间
-(void)uCloudRtcEngine:(UCloudRtcEngine *)manager memberDidLeaveRoom:(NSDictionary *)memberInfo{
    NSString *message = [NSString stringWithFormat:@"用户:%@ 离开房间",memberInfo[@"user_id"]];
    [self.view makeToast:message duration:1.5 position:CSToastPositionCenter];
}

//非自动订阅模式 新流加入会收到该回调
-(void)uCloudRtcEngine:(UCloudRtcEngine *)manager newStreamHasJoinRoom:(UCloudRtcStream *)stream{
    [self.view makeToast:@"有新的流可以订阅" duration:1.5 position:CSToastPositionCenter];
    [canSubstreamList addObject:stream];
//    [self.manager subscribeMethod:stream];
}
//非自动订阅模式 新流退出会收到该回调
-(void)uCloudRtcEngine:(UCloudRtcEngine *)manager streamHasLeaveRoom:(UCloudRtcStream *)stream{
    [self.view makeToast:@"可订阅的流离开" duration:1.5 position:CSToastPositionCenter];
    UCloudRtcStream *newS = [UCloudRtcStream new];
    for (UCloudRtcStream *tempS in canSubstreamList) {
        if ([tempS.streamId isEqualToString:stream.streamId]) {
            newS = tempS;
            break;
        }
    }
    [canSubstreamList removeObject:newS];
}

-(void)localAudioVolumeChange:(int)volume{
    NSLog(@"本地音频音量为:%d",volume);
}
-(void)remoteAudioVolumeChange:(int)volume userID:(NSString *)uId{
    NSLog(@"远端流：%@ 音频音量为：%d",uId,volume);
}

-(void)uCloudRtcEngine:(UCloudRtcEngine *)channel remoteMute:(NSDictionary *)remoteMuteInfo{
    NSLog(@"remoteMuteInfo==%@",remoteMuteInfo);
}
- (void)uCloudRtcEngineDidLeaveRoom:(UCloudRtcEngine *)manager {
    [self.view makeToast:@"退出房间" duration:1.5 position:CSToastPositionCenter];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)uCloudRtcEngineDisconnectRoom:(UCloudRtcEngine *)manager {
    [self.view makeToast:@"房间已断开连接" duration:1.5 position:CSToastPositionCenter];
}

- (void)uCloudRtcEngine:(UCloudRtcEngine *)manager streamPublishSucceed:(NSString *)streamId {

}
- (void)uCloudRtcEngine:(UCloudRtcEngine *)manager didChangePublishState:(UCloudRtcEnginePublishState)publishState{
    switch (publishState) {
        case UCloudRtcEnginePublishStateUnPublish:
            self.isConnected = NO;
            break;
        case UCloudRtcEnginePublishStatePublishing: {
            [self.bottomButton setTitle:@"正在发布..." forState:UIControlStateNormal];
        }
            break;
        case UCloudRtcEnginePublishStatePublishSucceed:{
            self.isConnected = YES;
            [self.view makeToast:@"发布成功" duration:1.5 position:CSToastPositionCenter];
            [self.bottomButton setTitle:@"发布成功" forState:UIControlStateNormal];
        }
            break;
        case UCloudRtcEnginePublishStateRepublishing: {
            [self.bottomButton setTitle:@"正在重新发布..." forState:UIControlStateNormal];
        }
            break;
        case UCloudRtcEnginePublishStatePublishFailed: {
            self.isConnected = NO;
            [self.bottomButton setTitle:@"开始发布" forState:UIControlStateNormal];
        }
            break;
        case UCloudRtcEnginePublishStatePublishStoped: {
            self.isConnected = NO;
            [self.view makeToast:@"发布已停止" duration:1.5 position:CSToastPositionCenter];
            [self.bottomButton setTitle:@"开始发布" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)uCloudRtcEngine:(UCloudRtcEngine *)manager didConnectFail:(id)data {
    NSLog(@"发布失败:%@",data);
    self.isConnected = NO;
    [self.view makeToast:[NSString stringWithFormat:@"发布失败:%@",data ?: @""] duration:5.0 position:CSToastPositionCenter];

}

- (void)uCloudRtcEngine:(UCloudRtcEngine *)manager receiveRemoteStream:(UCloudRtcStream *)stream {
    if (stream) {
        [self.streamList addObject:stream];
        [self reloadVideos];
    }
}

- (void)uCloudRtcEngine:(UCloudRtcEngine *)manager didRemoveStream:(UCloudRtcStream * _Nonnull)stream{
    self.isConnected = YES;
    UCloudRtcStream *delete = [UCloudRtcStream new];
    for (UCloudRtcStream *obj in self.streamList) {
        if ([obj.userId isEqualToString:stream.userId]) {
            delete = obj;
            break;
        }
    }
    [self.streamList removeObject:delete];
    [self reloadVideos];
}

- (void)uCloudRtcEngine:(UCloudRtcEngine *)manager error:(UCloudRtcError *)error{
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
            self.isConnected = NO;
            [self.bottomButton setTitle:@"开始发布" forState:UIControlStateNormal];
            [self.view makeToast:[NSString stringWithFormat:@"发布失败：%@",error.message] duration:3.0 position:CSToastPositionCenter];
        }
            break;
        default:
            [self.view makeToast:[NSString stringWithFormat:@"错误%ld:%@",(long)error.code,error.message] duration:3.0 position:CSToastPositionCenter];
            break;
    }
}

-(void)uCloudRtcEngine:(UCloudRtcEngine *)manager startRecord:(NSDictionary *)recordResponse{
    [self.view makeToast:[NSString stringWithFormat:@"视频录制文件:%@",recordResponse[@"FileName"]] duration:3.0 position:CSToastPositionCenter];
}

-(void)uCloudRtcEngine:(UCloudRtcEngine *)manager receiveCustomCommand:(NSString *)fromUserID content:(NSString *)content{
    [self.view makeToast:[NSString stringWithFormat:@"%@:%@",fromUserID,content] duration:3.0 position:CSToastPositionCenter];
}

-(void)uCloudRtcEngine:(UCloudRtcEngine *)manager didReceiveStreamStatus:(NSArray<UCloudRtcStreamStatsInfo *> * _Nonnull)status{
    for (UCloudRtcStreamStatsInfo *info in status) {
        NSLog(@"stream status info :%@",info);
    }
}

-(void)uCloudRtcEngine:(UCloudRtcEngine *)manager connectState:(UCloudRtcConnectState)connectState{
    NSLog(@"重连成功");
    [self reloadVideos];
}

- (void)uCloudRtcEngine:(UCloudRtcEngine *)manager networkQuality:(NSString *)userId txQuality:(UCloudRtcNetworkQuality)txQuality rxQuality:(UCloudRtcNetworkQuality)rxQuality {
    NSString *txQualityStr;
    NSString *rxQualityStr;
    switch (txQuality) {
        case UCloudRtcNetworkQualityUnknown:
            txQualityStr = @"未知";
            break;
        case UCloudRtcNetworkQualityExcellent:
            txQualityStr = @"优秀";
            break;
        case UCloudRtcNetworkQualityGood:
            txQualityStr = @"良好";
            break;
        case UCloudRtcNetworkQualityPoor:
            txQualityStr = @"一般";
            break;
        case UCloudRtcNetworkQualityPoorer:
            txQualityStr = @"较差";
            break;
        case UCloudRtcNetworkQualityPoorest:
            txQualityStr = @"糟糕";
            break;
        case UCloudRtcNetworkQualityDisconnect:
            txQualityStr = @"连接断开";
            break;
        default:
            break;
    }
   switch (rxQuality) {
        case UCloudRtcNetworkQualityUnknown:
            rxQualityStr = @"未知";
            break;
        case UCloudRtcNetworkQualityExcellent:
            rxQualityStr = @"优秀";
            break;
        case UCloudRtcNetworkQualityGood:
            rxQualityStr = @"良好";
            break;
        case UCloudRtcNetworkQualityPoor:
            rxQualityStr = @"一般";
            break;
        case UCloudRtcNetworkQualityPoorer:
            rxQualityStr = @"较差";
            break;
        case UCloudRtcNetworkQualityPoorest:
            rxQualityStr = @"糟糕";
            break;
        case UCloudRtcNetworkQualityDisconnect:
           txQualityStr = @"连接断开";
           break;
        default:
            break;
    }
    NSLog(@"userId:%@, 上行网络质量:%@，下行网络质量:%@",userId, txQualityStr, rxQualityStr);
}

- (void)reloadVideos {
    CGFloat width = (CGRectGetWidth(self.listView.frame) - kHorizontalCount * 5) / kHorizontalCount;
    CGFloat height = width / 3.0 * 4.0 + 5.0;
    
    double count = self.streamList.count * 1.0;
    int row = ceil(count / kHorizontalCount);
    row = row < 4 ? row : 4;
    
    self.heightOfListView.constant = height * row;
    [self.view layoutSubviews];
    
    [self.listView reloadData];
    
}
#pragma mark

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.streamList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MeetingRoomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UCloudRtcStream *stream = self.streamList[indexPath.row];
    [cell configureWithStream:stream];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UCloudRtcStream *stream = self.streamList[indexPath.row];
    if (self.bigScreenStream) {
        [self.streamList replaceObjectAtIndex:indexPath.row withObject:self.bigScreenStream];
    } else {
        [self.streamList removeObject:stream];
    }
    
    self.bigScreenStream = stream;
    [self.listView reloadData];
    
    [stream renderOnView:self.localView];
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(90, 120);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


#pragma  mark -- MeetingRoomCellDelegate ---
-(void)didMuteStream:(UCloudRtcStream *)stream muteAudio:(BOOL)mute{
    [self.manager setRemoteStream:stream muteAudio:mute];
}

-(void)didMuteStream:(UCloudRtcStream *)stream muteVideo:(BOOL)mute{
    [self.manager setRemoteStream:stream muteVideo:mute];
}

///截图
- (IBAction)cutImage:(id)sender {
    [self getImageViewWithView:self.localView];
}


- (void)getImageViewWithView:(UIView *)view{
    [self.manager captuerVideoImage:^(UIImage * _Nullable image) {
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

///播放/停止播放音频文件
- (IBAction)mediaPlay:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        NSString *audioPath = @"http://urtcdemo.cn-bj.ufileos.com/dy.mp3";
               [self.manager startMediaPlay:audioPath repeat:YES];
    }else{
        [self.manager stopMediaPlay];
    }
}



///开始/停止本地录制
- (IBAction)startNativeRecord:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        NSString *tmpDir = NSTemporaryDirectory();
        NSString *mp4OutPutPath = [tmpDir substringToIndex:tmpDir.length-1];
        [self.manager startNativeRecord];
        [sender setTitle:@"停止本地录制" forState:UIControlStateSelected];
    }else{
        [self.manager stopNativeRecord];
        [sender setTitle:@"开始本地录制" forState:UIControlStateNormal];
    }
}
- (IBAction)sendCustomCommand:(UIButton *)sender {
    [self.manager sendCustomCommand:@"Hello World"];
}

- (IBAction)unwindSegueBack:(UIStoryboardSegue *)segue {
    
}


#pragma mark mediaPlayerDelegate
- (void)uCloudRtcEngine:(UCloudRtcEngine *)channel mediaPlayerOnPlayEnd:(BOOL)isEnd{
    NSLog(@"音频播放结束");
}

#pragma mark 旁路推流相关接口
//开始旁路推流
- (IBAction)startMix:(id)sender{
    UCloudRtcMixConfig *mixConfig = [UCloudRtcMixConfig new];
    mixConfig.type = 1;
    mixConfig.streams = @[];
    mixConfig.pushurl = @[@"rtmp://rtcpush.ugslb.com/rtclive/URtc-h4r1txxy12111151yketwz111"];
    mixConfig.layout = 1;
    mixConfig.layouts = @[];
    mixConfig.bgColor = @{@"r": @200,@"g": @100, @"b": @50};
    mixConfig.bitrate = 600;
    mixConfig.framerate = 50;
    mixConfig.videocodec = @"H264";
    mixConfig.qualitylevel = @"CB";
    mixConfig.audiocodec = @"aac";
    mixConfig.mainviewtype = 1;
    mixConfig.width = 640;
    mixConfig.height = 720;
    mixConfig.bucket = @"urtc-test";
    mixConfig.region =@"cn-bj";
    mixConfig.watertype = 1;
    mixConfig.waterpos = 1;
    mixConfig.waterurl = @"http://urtc-living-test.cn-bj.ufileos.com/test.png";
    mixConfig.mimetype = 0;
    mixConfig.addstreammode = 1;
    [self.manager startMix:mixConfig];
}

//结束旁路推流
- (IBAction)stopMix:(id)sender{
    UCloudRtcMixStopConfig *mixStopConfig = [UCloudRtcMixStopConfig new];
    mixStopConfig.type = 1;
    mixStopConfig.pushurl = @[@"rtmp://rtcpush.ugslb.com/rtclive/URtc-h4r1txxy12111151yketwz111"];
    [self.manager stopMix: mixStopConfig];
}

//查询旁路推流
- (IBAction)queryMix:(id)sender{
    [self.manager queryMix];
    
}

//添加旁路推流
- (IBAction)addMixStream:(id)sender{
    NSArray *streams = @[];
    [self.manager addMixStream:streams];
}

//删除旁路推流
- (IBAction)deleteMix:(id)sender{
    NSArray *streams = @[];
    [self.manager deleteMixStream:streams];
}


@end

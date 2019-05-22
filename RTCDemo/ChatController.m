//
//  ChatController.m
//  URTC
//
//  Created by Tony on 2019/4/6.
//  Copyright © 2019年 Ucloud. All rights reserved.
//

#import "ChatController.h"
#import <WebRTC/WebRTC.h>
#import <UCloudRtc/UCloudRtc.h>


#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#define KVideoWidth KScreenWidth
#define KVideoHeight KScreenHeight -100

#define KVideoRemoteWidth KVideoWidth / 3
#define KVideoRemoteHeight 125.f



@interface ChatController () <UCloudRTCEngineDelegate, RTCEAGLVideoViewDelegate>
@property (nonatomic, strong) UCloudRTCEngine *engine;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *ACCESS_TOKEN;
@property (nonatomic, strong) NSString *KConnectAddress;
@property (nonatomic, strong) NSString *KConnectPort;
@property (nonatomic, strong) UCloudRTCVideoTrack *localVideoTrack; /**< local video track */
@property (nonatomic, strong) NSMutableDictionary <NSString *, UCloudRTCVideoTrack *> *remoteVideoTracks; /**< remote video track */

- (IBAction)clickBtnForChat:(UIButton *)sender;
@end

@implementation ChatController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_remoteVideoTracks) {
        _remoteVideoTracks = [NSMutableDictionary dictionary];
    }
    
    int R = (arc4random() % 998+1) ;
    _user_id = [NSString stringWithFormat:@"%d",R];
    [self getTokenWithAppID:@"URtc-h4r1txxy"];
    NSLog(@"[UCloudRTCEngine getSdkVersion] : %@",[UCloudRTCEngine getSdkVersion]);

}

//get token
-(void)getTokenWithAppID:(NSString *)appID
{
    NSDictionary *headers = @{ @"Content-Type": @"application/json",
                               @"cache-control": @"no-cache" };
    NSDictionary *parameters = @{ @"Action": @"rsusergetroomtoken",
                                  @"rpc_id": @"1",
                                  @"user_id": _user_id,
                                  @"room_id": _roomName,
                                  @"app_id": appID };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://pre.urtc.com.cn/uteach"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (!error) {
                                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                        self->_ACCESS_TOKEN = [[dict valueForKey:@"data"] valueForKey:@"access_token"];
                                                        //验证并连接服务器 进入房间
                                                        self.engine = [UCloudRTCEngine shareEngine];
                                                        [self.engine setLogEnabled:NO];//日志开关
                                                        [self.engine setAutoPublish:YES];
                                                        [self.engine setAutoSubscribe:YES];
                                                        [self.engine setAudioOnlyMode:NO];
                                                        self.engine.delegate = self;
                                                        
                                                        UCloudRTCConfig *config = [UCloudRTCConfig new];
                                                        config.app_id = appID;
                                                        config.user_id = self->_user_id;
                                                        config.room_id = self->_roomName;
                                                        config.access_token = self->_ACCESS_TOKEN;
                                                        [self.engine joinRoom:config completionHandler:^(NSDictionary * _Nullable response, NSError * _Nullable error) {
                                                            NSLog(@"response==%@",response);
                                                        }];
                                                    }
                                                }];
    [dataTask resume];
}




#pragma mark - WebRTCHelperDelegate
- (void)UCloudRTCEngine:(UCloudRTCEngine *)UCloudRTCEngine handleError:(NSDictionary * _Nullable)errorMsg{
}
- (void)UCloudRTCEngine:(UCloudRTCEngine *)UCloudRTCEngine setLocalStream:(UCloudRTCMediaStream *)stream {
    RTCEAGLVideoView *localView = [[RTCEAGLVideoView alloc] initWithFrame:CGRectMake(0, 100, KVideoWidth, KVideoHeight)];
    
    // 标记本地摄像头
    [localView setTag:10086];
    [localView setDelegate:self];
    _localVideoTrack = (UCloudRTCVideoTrack*)[stream.videoTracks lastObject];
    [_localVideoTrack addRenderer:localView];
    [self.view addSubview:localView];
}

- (void)UCloudRTCEngine:(UCloudRTCEngine *)UCloudRTCEngine addRemoteStream:(UCloudRTCMediaStream *)stream connectionID:(NSString *)connectionID {
    [_remoteVideoTracks setObject:(UCloudRTCVideoTrack*)[stream.videoTracks lastObject] forKey:connectionID];
    [self _refreshRemoteView];
}

- (void)UCloudRTCEngine:(UCloudRTCEngine *)UCloudRTCEngine removeConnection:(NSString *)connectionID {
    assert(connectionID);
    [_remoteVideoTracks removeObjectForKey:connectionID];
    [self _refreshRemoteView];
}

-(void)UCloudRTCEngine:(UCloudRTCEngine *)UCloudRTCEngine publishResponse:(NSDictionary *)response{
}

-(void)UCloudRTCEngine:(UCloudRTCEngine *)UCloudRTCEngine subscribeResponse:(NSDictionary *)response{
}


#pragma mark - RTCEAGLVideoViewDelegate
- (void)videoView:(RTCEAGLVideoView *)videoView didChangeVideoSize:(CGSize)size {
}

//手动发布
- (IBAction)publish:(id)sender {
    UCloudPublishStreamInfo *info = [UCloudPublishStreamInfo new];
    info.user_id = _user_id;
    info.audio = YES;
    info.video = YES;
    info.media_type = UCloudMediaTypeCamrea;
    info.data = NO;
    [self.engine publish:info];
}


//手动取消发布
- (IBAction)unPublish:(id)sender {
    [self.engine unPublish];
    NSArray *views = self.view.subviews;
    for (NSInteger i = 0; i < [views count]; i++) {
        UIView *view = [views objectAtIndex:i];
        if ([view isKindOfClass:[RTCEAGLVideoView class]]) {
            if (view.tag == 10086) {
                [view removeFromSuperview];
            }
        }
    }
}



//leave room
- (IBAction)clickBtnForChat:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.engine leaveRoom];
    }];
}

//mute/unmute video
- (IBAction)clickBtnForCamera:(UIButton *)sender {
    sender.selected = ! sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"video_open"] forState:UIControlStateSelected];
        [self.engine muteVideo];
    }else{
        [sender setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        [self.engine unMuteVideo];
    }
}

//mute/unmute audio
- (IBAction)clickBtnForMute:(UIButton *)sender {
    sender.selected = ! sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"audio_close"] forState:UIControlStateSelected];
        [self.engine muteAudio];
    }else{
        [sender setImage:[UIImage imageNamed:@"audio_open"] forState:UIControlStateNormal];
        [self.engine unMuteAudio];
    }
}

//switch
- (IBAction)clickBtnForSwitchCamera:(UIButton *)sender {
    sender.selected = ! sender.selected;
    if (sender.selected) {
        [self.engine switchCamreaToBack];
    }else{
        [self.engine switchCamreaToFront];
    }
}

#pragma mark - private method
- (void)_refreshRemoteView {
    NSArray *views = self.view.subviews;
    for (NSInteger i = 0; i < [views count]; i++) {
        UIView *view = [views objectAtIndex:i];
        if ([view isKindOfClass:[RTCEAGLVideoView class]]) {
            if (view.tag == 10086 ||view.tag == 10000||view.tag == 110) {
                continue;
            }
            [view removeFromSuperview];
        }
    }
    __block int column = 0;
    __block int row = 0;
    [_remoteVideoTracks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, UCloudRTCVideoTrack *remoteTrack, BOOL * _Nonnull stop) {
        RTCEAGLVideoView *remoteVideoView = [[RTCEAGLVideoView alloc] initWithFrame:CGRectMake(column * KVideoRemoteWidth, row * KVideoRemoteHeight+100, KVideoRemoteWidth, KVideoRemoteHeight)];
        [remoteVideoView setDelegate:self];
        [remoteTrack addRenderer:remoteVideoView];
        [self.view addSubview:remoteVideoView];
        column++;
        //一行多余3个在起一行
        if (column > 2) {
            row ++;
            column = 0;
        }
    }];
}

@end

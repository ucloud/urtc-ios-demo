//
//  SettingViewController.m
//  UCloudRtcSdk-ios-demo
//
//  Created by Tony on 2019/6/25.
//  Copyright © 2019 Tony. All rights reserved.
//

#import "SettingViewController.h"
#import <UCloudRtcSdk_ios/UCloudRtcSdk_ios.h>

@interface SettingViewController ()

@property (nonatomic , assign) BOOL isAutoPublish;//是否开启自动发布
@property (nonatomic , assign) BOOL isAutoSubscribe;//是否开启自动订阅
@property (nonatomic , assign) BOOL isDebug;//是否打印日志
@property (nonatomic , assign) BOOL isOnlyAudio;//是否采用纯音频模式
@property (nonatomic , assign) UCloudRtcEngineVideoProfile videoProfile;//视频分辨率
@property (nonatomic , assign) UCloudRtcEngineStreamProfile streamProfile;//本地流权限


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isAutoPublish = YES;
    self.isAutoSubscribe = YES;
    self.isDebug = YES;
    self.isOnlyAudio = NO;
    self.videoProfile = 0 ;
    self.streamProfile = 0;
}

- (IBAction)autoPub:(UISwitch *)sender {
    BOOL isButtonOn = [sender isOn];
    if (isButtonOn) {
        self.isAutoPublish = YES;
    }else {
        self.isAutoPublish = NO;
    }
}

- (IBAction)autoSub:(UISwitch *)sender {
    BOOL isButtonOn = [sender isOn];
    if (isButtonOn) {
        self.isAutoSubscribe = YES;
    }else {
        self.isAutoSubscribe = NO;
    }
}
- (IBAction)isBug:(UISwitch *)sender {
    BOOL isButtonOn = [sender isOn];
    if (isButtonOn) {
       self.isDebug = YES;
    }else {
        self.isDebug = NO;
    }
}

- (IBAction)isOnlyAudio:(UISwitch *)sender {
    BOOL isButtonOn = [sender isOn];
    if (isButtonOn) {
        self.isOnlyAudio = YES;
    }else {
        self.isOnlyAudio = NO;
    }
}
//分辨率设置
- (IBAction)selectedProfile:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.videoProfile = UCloudRtcEngine_VideoProfile_180P;
            break;
        case 1:
            self.videoProfile = UCloudRtcEngine_VideoProfile_360P_1;
            break;
        case 2:
            self.videoProfile = UCloudRtcEngine_VideoProfile_360P_2;
            break;
        case 3:
            self.videoProfile = UCloudRtcEngine_VideoProfile_480P;
            break;
        case 4:
            self.videoProfile = UCloudRtcEngine_VideoProfile_720P;
            break;
        default:
            break;
    }
}
//流权限设置
- (IBAction)selectedLimit:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.streamProfile = UCloudRtcEngine_StreamProfileAll;
            break;
        case 1:
            self.streamProfile = UCloudRtcEngine_StreamProfileUpload;
            break;
        case 2:
            self.streamProfile = UCloudRtcEngine_StreamProfileDownload;
            break;
        default:
            break;
    }
}

- (IBAction)save:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSDictionary *dictionary = @{
                                     @"isAutoPublish":@(self.isAutoPublish),
                                     @"isAutoSubscribe":@(self.isAutoSubscribe),
                                     @"isDebug":@(self.isDebug),
                                     @"isOnlyAudio":@(self.isOnlyAudio),
                                     @"videoProfile":@(self.videoProfile),
                                     @"streamProfile":@(self.streamProfile),
                                     };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"doSetting" object:self userInfo:dictionary];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

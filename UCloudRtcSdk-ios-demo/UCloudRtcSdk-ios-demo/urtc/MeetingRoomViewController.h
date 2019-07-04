//
//  MeetingRoomViewController.h
//  UCloudRtcSdkDemo
//
//  Created by tony on 2019/4/2.
//  Copyright © 2019年 ucloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UCloudRtcSdk_ios/UCloudRtcSdk_ios.h>

@class UCloudRtcRoomModel;
@interface MeetingRoomViewController : UIViewController

@property (nonatomic,strong) NSDictionary *engineSetting;//SDK相关配置信息

@property (nonatomic, assign) UCloudRtcEngineMode engineMode;
@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *token;//正式模式下必传

@property (nonatomic, strong) NSString *roomName;
@property (nonatomic, strong) UCloudRtcRoomModel *roomModel;
@end

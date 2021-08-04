//
//  UCloudRtcMeetingRoomVC.h
//  UCloudRtcSdkDemo
//
//  Created by ucloud on 2020/4/20.
//  Copyright © 2020 ucloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UCloudRtcSdk_ios/UCloudRtcSdk_ios.h>
NS_ASSUME_NONNULL_BEGIN

@interface UCloudRtcMeetingRoomVC : UIViewController

@property (nonatomic,strong) NSDictionary *engineSetting;//SDK相关配置信息
@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *token;//正式模式下必传
@property (nonatomic, strong) NSString *roomName;

@property (nonatomic, assign) UCloudRtcEngineMode engineMode;
@property (nonatomic, assign) UCloudRtcEngineRoomType roomType;//房间类型
@end

NS_ASSUME_NONNULL_END

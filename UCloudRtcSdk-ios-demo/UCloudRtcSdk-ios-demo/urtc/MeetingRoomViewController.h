//
//  MeetingRoomViewController.h
//  MeetingSDK
//
//  Created by jacksimjia on 2018/2/2.
//  Copyright © 2018年 ppyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCloudRtcRoomModel;
@interface MeetingRoomViewController : UIViewController

@property (nonatomic,strong) NSDictionary *engineSetting;//SDK相关配置信息

@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSString *roomName;
@property (nonatomic, strong) UCloudRtcRoomModel *roomModel;
@end

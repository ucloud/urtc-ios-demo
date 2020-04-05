//
//  UCloudRtcStreamStatsInfo.h
//  UCloudRtcSDK
//
//  Created by tony on 2019/3/29.
//  Copyright © 2019年 ucloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCloudRtcStreamStatsInfo : NSObject

@property (nonatomic, strong) NSString *streamId;

@property(nonatomic, strong) NSString *userId;

@property(nonatomic, assign) NSInteger volume;
@property (nonatomic, assign) NSInteger fps;
@property (nonatomic, assign) NSInteger bitrate;
@property (nonatomic, assign) NSInteger frameRate;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger lost;
@property (nonatomic, assign) NSInteger rtt;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger delay;
@property (nonatomic, strong) NSString *mime;
@property (nonatomic, strong) NSString *codec;
@property (nonatomic, strong) NSString *trackType;//区分音频h轨道 、视频轨道
@end

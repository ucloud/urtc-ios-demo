//
//  UCloudRTCConfig.h
//  UCloudRTC
//
//  Created by Tony on 2019/5/8.
//  Copyright © 2019 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCloudRTCEnumerates.h"

#define UCloudRTC_Version @"1.0.0"

NS_ASSUME_NONNULL_BEGIN

@interface UCloudRTCConfig : NSObject

//room 、server config
@property (nonatomic ,copy) NSString *access_token;

@property (nonatomic ,copy) NSString *app_id;

@property (nonatomic ,copy) NSString *user_id;

@property (nonatomic ,copy) NSString *room_id;



@end



@interface UCloudPublishStreamInfo : NSObject

//stream info
@property (nonatomic ,copy) NSString *user_id;

@property (nonatomic ,assign) UCloudMediaType media_type;

@property (nonatomic ,assign) BOOL audio;

@property (nonatomic ,assign) BOOL video;

@property (nonatomic ,assign) BOOL data;

@end



@interface UCloudSubscribeStreamInfo : NSObject

@property (nonatomic ,strong) NSArray *streams;//订阅目标流

//self stream info
@property (nonatomic ,copy) NSString *user_id;

@property (nonatomic ,copy) NSString *streamsub_id;

@property (nonatomic ,assign) BOOL audio;

@property (nonatomic ,assign) BOOL video;

@property (nonatomic ,assign) BOOL data;

//remote stream info
//@property (nonatomic ,assign) UCloudStreamtype media_type;
//
//@property (nonatomic ,copy) NSString *user_id_remote;
//
//@property (nonatomic ,copy) NSString *stream_id;

@end


NS_ASSUME_NONNULL_END

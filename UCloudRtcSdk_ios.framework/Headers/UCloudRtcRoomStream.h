//
//  UCloudRtcRoomStream.h
//  UCloudRtcSDK
//
//  Created by tony on 2019/6/14.
//  Copyright © 2019年 ucloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCloudRtcRoomStream : NSObject
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, assign) NSInteger media_type;
@property (nonatomic, assign) BOOL video;
@property (nonatomic, assign) BOOL audio;
@property (nonatomic, assign) BOOL data;
@property (nonatomic, assign) BOOL mutevideo;
@property (nonatomic, assign) BOOL muteaudio;
@end

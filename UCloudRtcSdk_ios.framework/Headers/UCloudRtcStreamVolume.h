//
//  UCloudRtcStreamVolume.h
//  UCloudRtcSdk-ios
//
//  Created by Tony on 2019/6/28.
//  Copyright © 2019 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UCloudRtcStreamVolume : NSObject

@property (nonatomic, strong) NSString *streamId;

@property(nonatomic, strong) NSString *userId;

// Sets the volume for the RTCMediaSource. |volume| is a gain value in the range
// [0, 10].
// Temporary fix to be able to modify volume of remote audio tracks.
// TODO(kthelgason): Property stays here temporarily until a proper volume-api
// is available on the surface exposed by webrtc.
@property(nonatomic, assign) double volume;
@end

NS_ASSUME_NONNULL_END

//
//  UCloudRtcVideoFrame.h
//  UCloudRtcSdk-ios-demo
//
//  Created by ucloud on 2020/9/2.
//  Copyright © 2020 Tony. All rights reserved.
// 自定义视频配置

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface UCloudRtcVideoFrame : NSObject

/** 视频宽. */
@property(nonatomic, assign) int width;
/** 视频高 */
@property(nonatomic, assign) int height;
/** 帧率 */
@property(nonatomic, assign) int fps;

- (instancetype)initVideoFrameWithWidth:(int)width height:(int)height fps:(int)fps;

@end

NS_ASSUME_NONNULL_END

//
//  URTCFileCaptureController.h
//  UCloudRtcSdk-ios-demo
//
//  Created by ucloud on 2020/9/2.
//  Copyright © 2020 YJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN
@class URTCFileCaptureController;

typedef void(^URTCFileVideoCapturerErrorBlock)(NSString *error);

@protocol URTCFileCaptureControllerDelegate <NSObject>
@optional
- (void)capturer:(URTCFileCaptureController *)fileCaptureController didCaptureVideoPixelBufferRef:(CVPixelBufferRef)pixelBufferRef timestamp:(CMTime)timestamp ;

@end

@interface URTCFileCaptureController : NSObject
@property (nonatomic, weak) id<URTCFileCaptureControllerDelegate> delegate;

- (void)startCapturingFromFileNamed:(NSString *)nameOfFile
                            onError:(__nullable URTCFileVideoCapturerErrorBlock)errorBlock;
- (void)stopCapture;
@end

NS_ASSUME_NONNULL_END

//
//  URTCFileCaptureController.m
//  UCloudRtcSdk-ios-demo
//
//  Created by ucloud on 2020/9/2.
//  Copyright © 2020 YJ. All rights reserved.
//

#import "URTCFileCaptureController.h"

typedef NS_ENUM(NSInteger, URTCFileVideoCapturerStatus) {
  URTCFileVideoCapturerStatusNotInitialized,
  URTCFileVideoCapturerStatusStarted,
  URTCFileVideoCapturerStatusStopped
};
@implementation URTCFileCaptureController
{
  AVAssetReader *_reader;
  AVAssetReaderTrackOutput *_outTrack;
  URTCFileVideoCapturerStatus _status;
  CMTime _lastPresentationTime;
  dispatch_queue_t _frameQueue;
  NSURL *_fileURL;
}

- (void)startCapturingFromFileNamed:(NSString *)nameOfFile
                            onError:(URTCFileVideoCapturerErrorBlock)errorBlock {
  if (_status == URTCFileVideoCapturerStatusStarted) {
    errorBlock(@"Capturer has been started.");
    return;
  } else {
    _status = URTCFileVideoCapturerStatusStarted;
  }

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSString *pathForFile = [self pathForFileName:nameOfFile];
    if (!pathForFile) {
      NSString *error =
          [NSString stringWithFormat:@"File %@ not found in bundle", nameOfFile];
      errorBlock(error);
      return;
    }
      self->_lastPresentationTime = CMTimeMake(0, 0);

      self->_fileURL = [NSURL fileURLWithPath:pathForFile];
    [self setupReaderOnError:errorBlock];
  });
}

- (void)setupReaderOnError:(URTCFileVideoCapturerErrorBlock)errorBlock {
  AVURLAsset *asset = [AVURLAsset URLAssetWithURL:_fileURL options:nil];
//     AVAsset *asset = [AVAsset assetWithURL:_fileURL];
  NSArray *allTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
  NSError *error = nil;

  _reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
  if (error) {
      errorBlock(error.localizedDescription);
    return;
  }

  NSDictionary *options = @{
    (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
  };
  _outTrack =
      [[AVAssetReaderTrackOutput alloc] initWithTrack:allTracks.firstObject outputSettings:options];
  [_reader addOutput:_outTrack];

  [_reader startReading];
  NSLog(@"File capturer started reading");
  [self readNextBuffer];
}
- (void)stopCapture {
  _status = URTCFileVideoCapturerStatusStopped;
  NSLog(@"File capturer stopped.");
}

#pragma mark - Private

- (nullable NSString *)pathForFileName:(NSString *)fileName {
  NSArray *nameComponents = [fileName componentsSeparatedByString:@"."];
  if (nameComponents.count != 2) {
    return nil;
  }

  NSString *path =
      [[NSBundle mainBundle] pathForResource:nameComponents[0] ofType:nameComponents[1]];
  return path;
}

- (dispatch_queue_t)frameQueue {
  if (!_frameQueue) {
    _frameQueue = dispatch_queue_create("org.webrtc.filecapturer.video", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(_frameQueue,
                              dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0));
  }
  return _frameQueue;
}

- (void)readNextBuffer {
  if (_status == URTCFileVideoCapturerStatusStopped) {
    [_reader cancelReading];
    _reader = nil;
    return;
  }

  if (_reader.status == AVAssetReaderStatusCompleted) {
    [_reader cancelReading];
    _reader = nil;
    [self setupReaderOnError:nil];
    return;
  }

  CMSampleBufferRef sampleBuffer = [_outTrack copyNextSampleBuffer];
  if (!sampleBuffer) {
    [self readNextBuffer];
    return;
  }
  if (CMSampleBufferGetNumSamples(sampleBuffer) != 1 || !CMSampleBufferIsValid(sampleBuffer) ||
      !CMSampleBufferDataIsReady(sampleBuffer)) {
    CFRelease(sampleBuffer);
    [self readNextBuffer];
    return;
  }

  [self publishSampleBuffer:sampleBuffer];
}

- (void)publishSampleBuffer:(CMSampleBufferRef)sampleBuffer {
  CMTime presentationTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
  Float64 presentationDifference =
      CMTimeGetSeconds(CMTimeSubtract(presentationTime, _lastPresentationTime));
  _lastPresentationTime = presentationTime;
  int64_t presentationDifferenceRound = lroundf(presentationDifference * NSEC_PER_SEC);
  __block dispatch_source_t timer = [self createStrictTimer];
  // Strict timer that will fire |presentationDifferenceRound| ns from now and never again.
  dispatch_source_set_timer(timer,
                            dispatch_time(DISPATCH_TIME_NOW, presentationDifferenceRound),
                            DISPATCH_TIME_FOREVER,
                            0);
  dispatch_source_set_event_handler(timer, ^{
    dispatch_source_cancel(timer);
    timer = nil;

    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if (!pixelBuffer) {
      CFRelease(sampleBuffer);
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self readNextBuffer];
      });
      return;
    }

      
    NSTimeInterval timeStampSeconds = CACurrentMediaTime();
    int64_t timeStampNs = lroundf(timeStampSeconds * NSEC_PER_SEC);

      CMTime timestamp = CMTimeMake(timeStampNs, (int32_t)presentationDifferenceRound);
      [self.delegate capturer:self didCaptureVideoPixelBufferRef:pixelBuffer timestamp:timestamp];
    CFRelease(sampleBuffer);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      [self readNextBuffer];
    });

  });
  dispatch_activate(timer);
}

- (dispatch_source_t)createStrictTimer {
  dispatch_source_t timer = dispatch_source_create(
      DISPATCH_SOURCE_TYPE_TIMER, 0, DISPATCH_TIMER_STRICT, [self frameQueue]);
  return timer;
}

- (void)dealloc {
  [self stopCapture];
}

@end

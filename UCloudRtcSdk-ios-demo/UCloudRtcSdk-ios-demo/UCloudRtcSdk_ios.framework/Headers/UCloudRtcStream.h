//
//  UCloudRtcStream.h
//  UCloudRtcSDK
//
//  Created by tony on 2019/2/23.
//  Copyright © 2019年 ucloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UCloudRtcRenderDelegate <NSObject>
/**
 远端视频渲染首帧通知
 
 @param streamID 流的唯一标识
 */
- (void)uCloudRtcRenderVideoFirstFrame:(NSString *)streamID;

@end


@class UCloudRtcStreamStatsInfo,UIView;

@interface UCloudRtcStream : NSObject

@property (nonatomic, weak) id <UCloudRtcRenderDelegate> delegate;
@property (nonatomic, readonly) NSString *streamId;
@property(nonatomic, readonly) NSString *userId;
@property(nonatomic, assign) BOOL hasSubscribe;//是否被当前用户订阅

/**渲染到指定视图*/
- (void)renderOnView:(UIView *)view;
/**获取流状态信息*/
- (NSMutableArray *)getReportStates:(NSString *)userId;


@end

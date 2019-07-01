//
//  UCloudRtcPortList.h
//  UCloudRtcSDK
//
//  Created by tony on 2019/1/30.
//  Copyright © 2019年 ucloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCloudRtcRequestInfo.h"
//#import "UCloudRtcPrivateHeader.h"

@interface UCloudRtcPortList : NSObject
+ (void)switchServer:(BOOL)isDeveloper;
+ (BOOL)isDeveloperServer;
#pragma mark - test
+ (NSString *)testTokenURL;
@end
@interface  UCloudRtcVerfyTokenRequestInfo : UCloudRtcRequestInfo
- (instancetype)initWithToken:(NSString *)token;
@end

/**创建房间*/
@interface UCloudRtcCreatRoomRequestInfo : UCloudRtcRequestInfo
- (instancetype)initWithRoomName:(NSString *)roomName extraInfo:(NSString *)extraInfo;
@end

/**加入房间*/
@interface UCloudRtcJoinRoomRequestInfo : UCloudRtcRequestInfo
- (instancetype)initWithRoomID:(NSString *)roomID;
@end

/**创建流*/
@interface UCloudRtcPublishStreamRequestInfo : UCloudRtcRequestInfo
@end

/**取消发布流*/
@interface UCloudRtcCancelPublishStreamRequestInfo : UCloudRtcRequestInfo
- (instancetype)initWithStreamId:(NSString *)streamId;
@end

/**订阅流*/
@interface UCloudRtcSubscribeStreamRequestInfo : UCloudRtcRequestInfo
- (instancetype)initWithStreamId:(NSString *)streamId;
@end

/**取消订阅流*/

@interface UCloudRtcCancelSubscribeStreamRequestInfo : UCloudRtcRequestInfo
- (instancetype)initWithStreamId:(NSString *)streamId;
@end


/*-------------------------待定接口--------------------------------*/


@interface UCloudRtcExitRoomRequestInfo : UCloudRtcRequestInfo
- (instancetype)initWithRoomID:(NSString *)roomID;
@end

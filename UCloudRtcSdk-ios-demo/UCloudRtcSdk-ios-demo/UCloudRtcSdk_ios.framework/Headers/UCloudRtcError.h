//
//  UCloudRtcError.h
//  UCloudRtcSDK
//
//  Created by tony on 2019/6/8.
//  Copyright © 2019年 ucloud. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,UCloudRtcErrorType) {
    UCloudRtcErrorTypeNone = 0,
    UCloudRtcErrorTypeTokenInvalid, //Token无效
    UCloudRtcErrorTypeRoomIsDisconnected, //房间未连接
    UCloudRtcErrorTypeCreateRoomFail, //创建房间失败
    UCloudRtcErrorTypeNotJoinRoom, //未加入房间
    UCloudRtcErrorTypeJoinRoomFail, //加入房间失败
    UCloudRtcErrorTypePublishStreamFail, //发布失败
    UCloudRtcErrorTypePublishStreamTimeout, //发布超时
};

@interface UCloudRtcError : NSObject
@property (nonatomic, assign, readonly) NSInteger code;
@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, assign, readonly) UCloudRtcErrorType errorType;

+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message type:(UCloudRtcErrorType)type;
@end

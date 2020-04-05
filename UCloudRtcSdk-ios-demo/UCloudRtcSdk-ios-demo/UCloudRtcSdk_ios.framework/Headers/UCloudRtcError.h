//
//  UCloudRtcError.h
//  UCloudRtcSDK
//
//  Created by tony on 2019/6/8.
//  Copyright © 2019年 ucloud. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,UCloudRtcErrorType) {
    UCloudRtcErrorTypeConnectField = 5000,//服务器连接失败
    UCloudRtcErrorTypeDisconnect = 5001,//服务器连接断开
    UCloudRtcErrorTypeTokenInvalid = 5002, //Token无效
    UCloudRtcErrorTypeRoomIsDisconnected = 5003, //房间未连接
    UCloudRtcErrorTypeCreateRoomFail = 5004, //创建房间失败
    UCloudRtcErrorTypeNotJoinRoom = 5005, //未加入房间
    UCloudRtcErrorTypeJoinRoomFail = 5006, //加入房间失败
    UCloudRtcErrorTypeLeaveRoomField = 5010, //离开房间失败
    UCloudRtcErrorTypePublishStreamFail = 5007, //发布失败
    UCloudRtcErrorTypePublishStreamTimeout = 5008, //发布超时
    UCloudRtcErrorTypeStreamProfileError = 5009, //权限错误
    
    UCloudRtcErrorTypeSDKInitField = 5104, //SDK初始化失败
    UCloudRtcErrorTypeParameterInvalid = 5100, //初始化参数错误
    UCloudRtcErrorTypeRecordInvalid = 5101, //视频录制服务未开启
    UCloudRtcErrorTypeWhiteBoardInvalid = 5102, //白板服务未开启
    UCloudRtcErrorTypeIMInvalid = 5103, //IM服务未开启
    
    
    
    
};



@interface UCloudRtcError : NSObject
@property (nonatomic, assign, readonly) NSInteger code;
@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, assign, readonly) UCloudRtcErrorType errorType;

+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message;
+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message type:(UCloudRtcErrorType)type;
@end

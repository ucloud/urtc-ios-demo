//
//  UCloudIMEngine.h
//  UCloudIMSdk
//
//  Created by Tony on 2019/11/27.
//  Copyright © 2019 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol UCloudIMEngineDelegate <NSObject>
@optional

/**接收到消息*/
- (void)uCloudIMEngineDidReceiveMessage:(NSData *_Nullable)data;

@end



@interface UCloudIMEngine : NSObject

@property (nonatomic ,assign) NSInteger mId;
@property (nonatomic,assign) NSInteger uid;
@property (nonatomic ,copy) NSString *roomId;
@property (nonatomic ,copy) NSString *userId;
@property (nonatomic ,copy) NSString *platform;

@property (nonatomic, weak) id <UCloudIMEngineDelegate> _Nullable delegate;

/**
@brief 初始化UCloudIMEngine
@return UCloudIMEngine
*/
+ (UCloudIMEngine *_Nonnull)sharedImEngine;


/**
@brief 连接IM服务器
*/
- (void)startConnect;



/**
@brief 断开IM服务器
*/
- (void)cutOffConnect;



/**
@brief 创建或加入房间 /JoinRoom
@param parameters  {"UserId": "dd","RoomId": "ddd","UserType":"admin"     //admin:管理员；default：普通成员}
@param completionHandler callBackBlock
*/
- (void)joinRoom:(NSDictionary *_Nonnull)parameters completionHandler:(void (^_Nonnull)(NSData * _Nullable data, NSError * _Nullable error))completionHandler;



/**
@brief 连接im  /IM/Connect
@param parameters {"UserId": "dd","RoomId": "ddd","ConnectType":"Create"    //Create:管理者（老师）连接房间的时候使用，学生不填}
@param completionHandler callBackBlock
*/
- (void)connect:(NSDictionary *_Nonnull)parameters completionHandler:(void (^_Nonnull)(NSData * _Nullable data, NSError * _Nullable error))completionHandler;



/**
@brief 断连im  /IM/Disconnect
@param parameters {"UserId": "dd","RoomId": "ddd"}
@param completionHandler callBackBlock
*/
- (void)disconnect:(NSDictionary *_Nonnull)parameters completionHandler:(void (^_Nonnull)(NSData * _Nullable data, NSError * _Nullable error))completionHandler;



/**
@brief 获取房间用户  /IM/GetRoomUser
@param parameters {"RoomId": "ddd"}
@param completionHandler callBackBlock
*/
- (void)getRoomUser:(NSDictionary *_Nonnull)parameters completionHandler:(void (^_Nonnull)(NSData * _Nullable data, NSError * _Nullable error))completionHandler;



/**
@brief 推送信息  /IM/PushRoom
@param parameters {"UserId": "dd", "RoomId": "ddd", "Msg": "哈哈哈哈哈"}
@param completionHandler callBackBlock
*/
- (void)pushRoom:(NSDictionary *_Nonnull)parameters completionHandler:(void (^_Nonnull)(NSData * _Nullable data, NSError * _Nullable error))completionHandler;



/**
@brief 推送广播  /IM/PushAll
@param parameters {"Msg": "哈哈哈哈哈"}
@param completionHandler callBackBlock
*/
- (void)pushAll:(NSDictionary *_Nonnull)parameters completionHandler:(void (^_Nonnull)(NSData * _Nullable data, NSError * _Nullable error))completionHandler;



/**
@brief 房间/成员禁言  /IM/BanRoom
@param parameters {"UserId": "dd","RoomId": "ddd"}
@param completionHandler callBackBlock
*/
- (void)banRoom:(NSDictionary *_Nonnull)parameters completionHandler:(void (^_Nonnull)(NSData * _Nullable data, NSError * _Nullable error))completionHandler;



/**
@brief 房间连麦权限  /Call/AuthCall
@param parameters {"UserId": "dd","RoomId": "ddd", "Operation": "open" //open:开启；close：关闭}
@param completionHandler callBackBlock
*/
- (void)authCall:(NSDictionary *_Nonnull)parameters completionHandler:(void (^_Nonnull)(NSData * _Nullable data, NSError * _Nullable error))completionHandler;



/**
@brief 连麦申请 /Call/ApplyCall
@param parameters {
    RoomId      string
    ReplyUserId string  //连麦接收人
    Operation   string //apply:申请；cancel:取消
}
@param completionHandler callBackBlock
*/
- (void)applyCall:(NSDictionary *_Nonnull)parameters completionHandler:(void (^_Nonnull)(NSData * _Nullable data, NSError * _Nullable error))completionHandler;



/**
@brief 连麦回复  /Call/ReplyCall
@param parameters {
    RoomId      string
    ReplyUserId string
    Operation   string //agree:同意；refuse：拒绝
}
@param completionHandler callBackBlock
*/
- (void)replyCall:(NSDictionary *_Nonnull)parameters completionHandler:(void (^_Nonnull)(NSData * _Nullable data, NSError * _Nullable error))completionHandler;



/**
@brief 获取房间信息  /GetRoomInfo
@param parameters {
    RoomId      string
}
@param completionHandler callBackBlock
*/
- (void)getRoomInfo:(NSDictionary *_Nonnull)parameters completionHandler:(void (^_Nonnull)(NSData * _Nullable data, NSError * _Nullable error))completionHandler;



/**
@brief 获取房间聊天记录  /IM/GetRoomMsg
@param parameters {
    RoomId      string
    StartTime   int64       //开始获取记录时间戳；0：获取全部
}
@param completionHandler callBackBlock
*/
- (void)getRoomMsg:(NSDictionary *_Nonnull)parameters completionHandler:(void (^_Nonnull)(NSData * _Nullable data, NSError * _Nullable error))completionHandler;




/**
@brief 发布公告 （公告信息可在获取房间信息中获取）（IMType类型值：IMBulletin）  /IM/PushBulletin
@param parameters {
    RoomId      string
    Bulletin    string       //公告内容
}
@param completionHandler callBackBlock
*/
- (void)pushBulletin:(NSDictionary *_Nonnull)parameters completionHandler:(void (^_Nonnull)(NSData * _Nullable data, NSError * _Nullable error))completionHandler;




/**
@brief 自定义消息 （IMType类型值：IMCustomContent）  /IM/PushCustomContent
@param parameters {
    RoomId      string
    CustomType  string       //自定义消息类型，由客户自行定义，可代表不同类型自定义内容，如：广告，视频，游戏，推广。。。。
    Content     string      //自定义消息内容
}
@param completionHandler callBackBlock
*/
- (void)pushCustomContent:(NSDictionary *_Nonnull)parameters completionHandler:(void (^_Nonnull)(NSData * _Nullable data, NSError * _Nullable error))completionHandler;




/**
@brief 点对点自定义消息 （IMType类型值：IMCustomContentPeers）  /IM/PushCustomContentPeers
@param parameters {
    RoomId      string
    UserId      string
    CustomType  string       //自定义消息类型，由客户自行定义，可代表不同类型自定义内容，如：广告，视频，游戏，推广。。。。
    Content     string      //自定义消息内容
}
@param completionHandler callBackBlock
*/
- (void)pushCustomContentPeers:(NSDictionary *_Nonnull)parameters completionHandler:(void (^_Nonnull)(NSData * _Nullable data, NSError * _Nullable error))completionHandler;


@end





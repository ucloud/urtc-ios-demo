//
//  UCloudRtcGetToken.h
//  UCloudRtcSDK
//
//  Created by tony on 2019/4/20.
//  Copyright © 2019年 ucloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UCloudRtcEngine;

@interface UCloudRtcGetToken : NSObject

+ (instancetype _Nonnull )sharedInstance;

- (void)getTokenWithAppId:(NSString *_Nonnull)appID userID:(NSString *_Nonnull)userID roomID:(NSString *_Nonnull)roomID  andAppSecret:(NSString *_Nonnull)appSecret completionHandler:(void (^_Nonnull)(NSString * _Nonnull token, NSError * _Nonnull error))completion;



@end

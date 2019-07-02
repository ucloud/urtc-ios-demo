//
//  UCloudRtcRequestInfo.h
//  UCloudRtcSDK
//
//  Created by tony on 2019/1/30.
//  Copyright © 2019年 UCloudRtcun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UCloudRtcRequestMethod) {
    UCloudRtcRequestMethodGet = 0,
    UCloudRtcRequestMethodPost,
    UCloudRtcRequestMethodPut,
    UCloudRtcRequestMethodDelete
};


@interface UCloudRtcRequestInfo : NSObject
@property (nonatomic, readonly) UCloudRtcRequestMethod requestMethod;
@property (nonatomic, readonly) NSString *requestURL;
@property (nonatomic, strong) NSDictionary *parameters;


#pragma mark - 子类重写
//请求方式，默认 GET
- (UCloudRtcRequestMethod)requestMethod;
//请求地址
- (NSString *)requestURL;

- (Class)modelClass;
@end

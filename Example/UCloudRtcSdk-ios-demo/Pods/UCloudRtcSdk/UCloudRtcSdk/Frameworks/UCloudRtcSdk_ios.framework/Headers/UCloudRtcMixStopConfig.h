//
//  UCloudRtcMixStopConfig.h
//  UCloudRtcSdk-ios
//
//  Created by Tony on 2020/4/22.
//  Copyright © 2020 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCloudRtcMixConfig.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCloudRtcMixStopConfig : NSObject

//1 转推 2 录制 3 转推和录制 4 更新设置
@property (nonatomic, assign) UCloudRtcMixConfigType type;

//如果type选1或3需要指定停止对哪个url的转推,如果留空停止对所有url的转推  [""]
@property (nonatomic, strong) NSArray *pushurl;

@end

NS_ASSUME_NONNULL_END

//
//  UCloudRtcStreamStatsInfo.h
//  UCloudRtcSDK
//
//  Created by tony on 2019/3/29.
//  Copyright © 2019年 ucloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCloudRtcAudioStats : NSObject

@property (nonatomic, strong) NSString *streamId;

@property(nonatomic, strong) NSString *userId;

@property(nonatomic, assign) NSInteger volume;

@end

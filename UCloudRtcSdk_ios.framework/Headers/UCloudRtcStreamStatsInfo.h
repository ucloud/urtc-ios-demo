//
//  UCloudRtcStreamStatsInfo.h
//  UCloudRtcSDK
//
//  Created by tony on 2019/3/29.
//  Copyright © 2019年 ucloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCloudRtcStreamStatsInfo : NSObject
@property (nonatomic, assign) NSInteger fps;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger delay;
@property (nonatomic, strong) NSString *codec;
@end
